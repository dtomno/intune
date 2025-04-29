import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class MetroController extends GetxController {
  // Observable values for UI
  RxInt count = 0.obs;         // Current beat position
  RxInt beats = 4.obs;         // Number of beats in measure (time signature)
  RxDouble tempo = 120.0.obs;  // Default to 120 BPM
  RxBool play = false.obs;     // Is metronome playing
  RxBool soundLoaded = false.obs; // Audio files loaded successfully
  RxBool isFirstBeat = false.obs;  // Whether current beat is the first beat in measure
  
  // Audio players
  late AudioPlayer _firstBeatPlayer;  // For accented first beats
  late AudioPlayer _otherBeatPlayer;  // For other beats
  
  Timer? _metronomeTimer;      // High-precision timer
  int _currentBeat = 0;        // Internal beat counter
  DateTime? _startTime;        // When metronome started
  int _beatCount = 0;          // Total number of beats since start
  
  double _latencyCompensation = 0.020; // 20ms default latency compensation
  
  // Calculate beat interval in milliseconds from tempo
  double get _beatIntervalMs => 60000 / tempo.value;
  
  @override
  void onInit() {
    super.onInit();
    _initAudio();
  }

  // Initialize audio session and load audio files
  Future<void> _initAudio() async {
    try {
      // Configure audio session for best performance
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.assistanceSonification,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      
      // Create audio players
      _firstBeatPlayer = AudioPlayer();
      _otherBeatPlayer = AudioPlayer();
      
      // Set volume levels
      await _firstBeatPlayer.setVolume(1.0);
      await _otherBeatPlayer.setVolume(1.0);
      
      // Try to load local sound files first
      try {
        await _firstBeatPlayer.setAsset('sounds/first_beat.wav');
        await _otherBeatPlayer.setAsset('sounds/other_beat.wav');
        soundLoaded.value = true;
      } catch (e) {
        debugPrint("Could not load local sound assets: $e");
        
        // Try network fallback sounds
        try {
          await _firstBeatPlayer.setUrl(
            'https://assets.mixkit.co/active_storage/sfx/2571/2571-preview.wav',
            preload: true
          );
          await _otherBeatPlayer.setUrl(
            'https://assets.mixkit.co/active_storage/sfx/209/209-preview.wav', 
            preload: true
          );
          soundLoaded.value = true;
        } catch (urlError) {
          debugPrint("Could not load network fallback sounds: $urlError");
          
          // Create synthesized sounds as final fallback
          _createSynthesizedSounds();
        }
      }
    } catch (e) {
      debugPrint("Audio session error: $e");
      // Create synthesized sounds as final fallback
      _createSynthesizedSounds();
    }
  }
  
  // Create synthesized sounds if audio files can't be loaded
  void _createSynthesizedSounds() {
    try {
      // Use different frequencies for first beat vs other beats
      final audioSource1 = SineWaveGenerator(frequency: 880, amplitude: 0.6);
      final audioSource2 = SineWaveGenerator(frequency: 440, amplitude: 0.5);
      
      _firstBeatPlayer = AudioPlayer();
      _otherBeatPlayer = AudioPlayer();
      
      _firstBeatPlayer.setAudioSource(audioSource1);
      _otherBeatPlayer.setAudioSource(audioSource2);
      
      soundLoaded.value = true;
    } catch (e) {
      debugPrint("Could not create synthesized sounds: $e");
      soundLoaded.value = false;
    }
  }
  
  // Check and adjust for timing drift
  void _updateTiming() {
    if (_startTime == null || _metronomeTimer == null) return;
    
    final now = DateTime.now();
    final expectedElapsed = (_beatIntervalMs * _beatCount);
    final actualElapsed = now.difference(_startTime!).inMilliseconds;
    
    // Calculate drift (how far ahead or behind we are)
    final drift = actualElapsed - expectedElapsed;
    
    // If drift is more than 15ms, adjust the next interval
    if (drift.abs() > 15) {
      // Cancel current timer
      _metronomeTimer?.cancel();
      
      // Calculate corrected interval for next beat
      final correctedInterval = math.max(1, _beatIntervalMs - drift);
      
      // Setup new timer with correction
      _metronomeTimer = Timer(Duration(milliseconds: correctedInterval.round()), _onBeat);
    }
  }
  
  // Called on each metronome beat
  void _onBeat() {
    if (!soundLoaded.value || !play.value) return;
    
    _beatCount++;
    
    // Play the appropriate sound
    if (_currentBeat == 0) {
      isFirstBeat.value = true;
      _playFirstBeat();
    } else {
      isFirstBeat.value = false;
      _playOtherBeat();
    }
    
    // Update beat counter
    _currentBeat = (_currentBeat + 1) % beats.value;
    count.value = _currentBeat;
    
    // Schedule next beat with high precision
    _scheduleNextBeat();
    
    // Periodically check and adjust timing
    if (_beatCount % 4 == 0) {
      _updateTiming();
    }
  }
  
  // Schedule the next beat with precise timing
  void _scheduleNextBeat() {
    final interval = _beatIntervalMs;
    
    // Apply latency compensation
    final adjustedInterval = interval - (_latencyCompensation * 1000);
    final intervalMs = math.max(10, adjustedInterval.round());
    
    // Cancel existing timer if any
    _metronomeTimer?.cancel();
    
    // Create new timer for next beat
    _metronomeTimer = Timer(Duration(milliseconds: intervalMs), _onBeat);
  }
  
  // Play first beat sound (accented beat)
  void _playFirstBeat() {
    try {
      _firstBeatPlayer.seek(Duration.zero);
      _firstBeatPlayer.play();
    } catch (e) {
      debugPrint("Error playing first beat: $e");
    }
  }
  
  // Play other beat sound
  void _playOtherBeat() {
    try {
      _otherBeatPlayer.seek(Duration.zero);
      _otherBeatPlayer.play();
    } catch (e) {
      debugPrint("Error playing other beat: $e");
    }
  }
  
  // Start the metronome
  void start() {
    if (!soundLoaded.value) {
      // Try to initialize audio again
      _initAudio().then((_) {
        if (soundLoaded.value) {
          _startMetronome();
        } else {
          debugPrint("Cannot start metronome - sounds not loaded");
        }
      });
    } else {
      _startMetronome();
    }
  }
  
  // Start metronome playback
  void _startMetronome() {
    play.value = true;
    _currentBeat = 0;
    count.value = 0;
    _beatCount = 0;
    _startTime = DateTime.now();
    
    // Create a small pre-delay to allow audio system to prepare
    Future.delayed(Duration(milliseconds: 50), () {
      if (play.value) {
        _onBeat(); // Start first beat immediately
      }
    });
  }
  
  // Stop the metronome
  void stop() {
    play.value = false;
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
    count.value = 0;
    _startTime = null;
  }
  
  // Update metronome settings
  void updateMetro(RxDouble newTempo) {
    // If playing, restart to apply new tempo immediately
    final wasPlaying = play.value;
    
    if (wasPlaying) {
      stop(); // Stop with old tempo
      
      // Small delay to ensure clean restart
      Future.delayed(Duration(milliseconds: 50), () {
        if (wasPlaying) {
          start(); // Start with new tempo
        }
      });
    }
  }
  
  // Set latency compensation (can be adjusted based on device)
  void setLatencyCompensation(double latencySeconds) {
    _latencyCompensation = latencySeconds;
  }
  
  // Auto-calibrate metronome (could be expanded with actual measurement)
  Future<void> calibrate() async {
    // Default calibration - could be expanded with actual device measurement
    _latencyCompensation = 0.025; // 25ms default
  }
  
  @override
  void onClose() {
    _metronomeTimer?.cancel();
    _firstBeatPlayer.dispose();
    _otherBeatPlayer.dispose();
    super.onClose();
  }
}

// Synthesized sound generator as fallback
class SineWaveGenerator extends StreamAudioSource {
  final double frequency;
  final double amplitude;
  
  SineWaveGenerator({required this.frequency, required this.amplitude});
  
  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Create a simple sine wave with attack and decay
    const sampleRate = 44100;
    final bytesPerSample = 2;
    final duration = 0.08; // 80ms
    final numSamples = (sampleRate * duration).toInt();
    final bytes = Uint8List(numSamples * bytesPerSample);
    final byteData = ByteData.view(bytes.buffer);
    
    // Create a sine wave with envelope
    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      
      // Apply attack/decay envelope
      double envelope;
      if (i < numSamples * 0.1) {
        // Attack (first 10%)
        envelope = i / (numSamples * 0.1);
      } else if (i > numSamples * 0.6) {
        // Decay (last 40%)
        envelope = (numSamples - i) / (numSamples * 0.4);
      } else {
        // Sustain
        envelope = 1.0;
      }
      
      final sample = (amplitude * envelope * 32767 * math.sin(2 * math.pi * frequency * t)).toInt();
      byteData.setInt16(i * bytesPerSample, sample, Endian.little);
    }
    
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentType: 'audio/wav',
      stream: Stream.value(bytes),
      contentLength: bytes.length,
      offset: start ?? 0,
    );
  }
}
