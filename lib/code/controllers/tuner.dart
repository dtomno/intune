import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/settings_controller.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:permission_handler/permission_handler.dart';

class TunerController extends GetxController {
  // Audio processing constants - optimized for guitar pitch detection
  static const int sampleRate = 16000;
  // Smaller frame length for more responsive pitch detection (like Guitar Tuna)
  static const int frameLength = 2048; // Reduced from 4096 for faster response time

  final _settingsController = Get.find<SettingsController>();

  final _audioCapture = VoiceProcessor.instance;
  // Match the PitchDetector sample rate with the audio capture
  final _pitchDetector = PitchDetector(audioSampleRate: sampleRate.toDouble(), bufferSize: frameLength);
  final _pitchHandler = PitchHandler(InstrumentType.guitar);

  // Observable values
  Rx<String> note = ''.obs;
  Rx<String> status = 'Play something'.obs;
  Rx<double> frequency = 0.0.obs;
  Rx<double> diff = 0.0.obs;
  Rx<double> actualFrequency = 0.0.obs;
  RxList tuningNotes = [].obs;
  RxBool isRecording = false.obs;

  // UI feedback
  RxDouble tuningAccuracy = 0.0.obs; // Range from -1.0 to 1.0 where 0 is perfectly tuned
  RxBool isDetectingPitch = false.obs;
  RxInt consecutiveSilenceFrames = 0.obs;

  // Signal strength for better visual feedback (Guitar Tuna-like feature)
  RxDouble signalStrength = 0.0.obs; // 0.0 to 1.0

  // Improved sensitivity for pitch detection
  late final double silenceThreshold; // 0.1 to 1.0

  // Time-based update limits to prevent UI flicker
  int _lastUpdateTime = 0;
  static const int minUpdateIntervalMs = 50; // Minimum time between UI updates

  final List<DropdownMenuItem<String>> tunings = const [
    DropdownMenuItem(
        value: 'Any (Detects all notes)',
        child: Text('Any (Detects all notes)')),
    DropdownMenuItem(value: 'Standard', child: Text('Standard')),
    DropdownMenuItem(value: 'Bass (4 string)', child: Text('Bass (4 string)')),
    DropdownMenuItem(value: 'Bass (5 string)', child: Text('Bass (5 string)')),
    DropdownMenuItem(value: 'Bass (6 string)', child: Text('Bass (6 string)')),
    DropdownMenuItem(value: 'Drop D', child: Text('Drop D')),
    DropdownMenuItem(value: 'Drop A', child: Text('Drop A')),
    DropdownMenuItem(value: 'Half step down', child: Text('Half step down')),
    DropdownMenuItem(value: 'Open C', child: Text('Open C')),
    DropdownMenuItem(value: 'Open D', child: Text('Open D')),
    DropdownMenuItem(value: 'Open F', child: Text('Open F')),
    DropdownMenuItem(value: 'Open G', child: Text('Open G'))
  ];

  Rx<String> tuning = 'Any (Detects all notes)'.obs;

  late final VoiceProcessorFrameListener frameListener;

  @override
  void onInit() {
    super.onInit();
    silenceThreshold = _settingsController.settings.value.silenceThreshold.toDouble();
    frameListener = (buffer) => _processPitchData(buffer);
    _audioCapture?.addFrameListener(frameListener);

    // Fix the error listener implementation
    _audioCapture?.addErrorListener((dynamic msg) => onError(msg));
  }

  showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppThemes.getErrorColor().withValues(
          red: AppThemes.getErrorColor().red.toDouble(),
          green: AppThemes.getErrorColor().green.toDouble(),
          blue: AppThemes.getErrorColor().blue.toDouble(),
          alpha: 0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() async {
    _audioCapture?.removeFrameListener(frameListener);
    await _audioCapture?.stop();
    super.onClose();
  }

  ///Start recording audio
  Future<void> recordAudio() async {
    if (await _audioCapture?.hasRecordAudioPermission() ?? false) {
      try {
        // Clear previous values before starting
        _handleSilence();
        // Use the correct sample rate and buffer size for better pitch detection
        await _audioCapture?.start(frameLength, sampleRate);
        isRecording.value = true;
      } catch (e) {
        Get.snackbar(
          'Tuner Error',
          'Could not start the tuner: ${e.toString()}',
          backgroundColor: Colors.red.withValues(red: 255, green: 0, blue: 0, alpha: 204), // Fixed withOpacity(0.8)
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: Text('Microphone Permission Required'),
          content: Text(
              'InTune needs microphone access to detect your guitar\'s pitch. Please grant permission in settings.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> stopAudio() async {
    await _audioCapture?.stop();
    isRecording.value = false;
    // Reset values when stopped
    _handleSilence();
  }

  // Reset values when no audio is detected
  void _handleSilence() {
    note.value = '';
    frequency.value = 0.0;
    diff.value = 0.0;
    actualFrequency.value = 0.0;
    status.value = 'Play something';
    tuningAccuracy.value = 0.0;
    isDetectingPitch.value = false;
    signalStrength.value = 0.0;
  }

  // Calculate signal strength from audio buffer
  double _calculateSignalStrength(List<int> audioData) {
    if (audioData.isEmpty) return 0.0;

    // Compute average amplitude
    double sum = 0.0;
    for (int sample in audioData) {
      sum += sample.abs();
    }
    double averageAmplitude = sum / audioData.length;

    // Normalize to 0.0-1.0 range (adjust the divisor based on your audio range)
    return (averageAmplitude / 5000).clamp(0.0, 1.0);
  }

  // Process audio data for pitch detection
  void _processPitchData(List<int> audioData) async {
    try {
      if (audioData.isEmpty) {
        return;
      }

      // Update signal strength for visual feedback
      signalStrength.value = _calculateSignalStrength(audioData);

      // Throttle update frequency to prevent UI flicker
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastUpdateTime < minUpdateIntervalMs) {
        return;
      }
      _lastUpdateTime = now;

      // Convert to proper format for the pitch detector
      final Float64List buffer = Float64List(audioData.length);
      for (int i = 0; i < audioData.length; i++) {
        buffer[i] = audioData[i].toDouble();
      }
      final List<double> audioSample = buffer.toList();
      
      // Get pitch from audio buffer
      final result = await _pitchDetector.getPitchFromFloatBuffer(audioSample);

      // Check if the signal strength is above the threshold
      if (result.pitched && signalStrength.value > silenceThreshold) {
        // If we have a pitch, reset silence counter
        consecutiveSilenceFrames.value = 0;
        isDetectingPitch.value = true;

        // Process the detected pitch
        final handledResult = await _pitchHandler.handlePitch(result.pitch);

        note.value = handledResult.note;
        frequency.value = handledResult.expectedFrequency.truncateToDouble();
        diff.value = handledResult.diffFrequency.truncateToDouble();
        actualFrequency.value = result.pitch;
        status.value = handledResult.tuningStatus
            .toString()
            .replaceFirst('TuningStatus.', '');

        // Calculate tuning accuracy for UI - using a more intuitive scale (cents)
        // Convert frequency difference to cents for more intuitive display
        // A cent is 1/100 of a semitone
        double cents = 1200 * (diff.value / frequency.value) * math.log(2);
        tuningAccuracy.value =
            (cents / 50.0).clamp(-1.0, 1.0); // Normalize to -1.0 to 1.0

        // Process tuning notes based on selected tuning
        _processTuningNotes();
      } else {
        // Increase silence counter and check if we should reset
        consecutiveSilenceFrames.value++;

        // Faster response to silence - reset after 5 frames instead of 10
        if (consecutiveSilenceFrames.value > 5) {
          isDetectingPitch.value = false;
          _handleSilence();
        }
      }
    } catch (e) {
      print("Error processing audio: $e");
    }
  }

  void updateTuningNotes() {
    if (tuning.value == 'Standard') {
      tuningNotes.value = ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'];
    } else if (tuning.value == 'Bass (4 string)') {
      tuningNotes.value = ['E1', 'A1', 'D2', 'G2'];
    } else if (tuning.value == 'Bass (5 string)') {
      tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2'];
    } else if (tuning.value == 'Bass (6 string)') {
      tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2', 'C3'];
    } else if (tuning.value == 'Drop D') {
      tuningNotes.value = ['D2', 'A2', 'D3', 'G3', 'B3', 'E4'];
    } else if (tuning.value == 'Drop A') {
      tuningNotes.value = ['A1', 'A2', 'D3', 'G3', 'B3', 'E4'];
    } else if (tuning.value == 'Half step down') {
      tuningNotes.value = ['D#2', 'G#2', 'C#3', 'F#3', 'A#3', 'D#4'];
    } else if (tuning.value == 'Open C') {
      tuningNotes.value = ['C2', 'G2', 'C3', 'G3', 'C4', 'E4'];
    } else if (tuning.value == 'Open D') {
      tuningNotes.value = ['D2', 'A2', 'D3', 'F#3', 'A3', 'D4'];
    } else if (tuning.value == 'Open F') {
      tuningNotes.value = ['C2', 'F2', 'C3', 'F3', 'A3', 'F4'];
    } else if (tuning.value == 'Open G') {
      tuningNotes.value = ['D2', 'G2', 'D3', 'G3', 'B3', 'D4'];
    } else {
      tuningNotes.value = [];
    }
  }

  // Process tuning notes based on selected tuning
  void _processTuningNotes() {
    if (tuning.value == 'Standard') {
      tuningNotes.value = ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'];
      standardTuning();
    } else if (tuning.value == 'Bass (4 string)') {
      tuningNotes.value = ['E1', 'A1', 'D2', 'G2'];
      bass4Tuning();
    } else if (tuning.value == 'Bass (5 string)') {
      tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2'];
      bass5Tuning();
    } else if (tuning.value == 'Bass (6 string)') {
      tuningNotes.value = ['B0', 'E1', 'A1', 'D2', 'G2', 'C3'];
      bass6Tuning();
    } else if (tuning.value == 'Drop D') {
      tuningNotes.value = ['D2', 'A2', 'D3', 'G3', 'B3', 'E4'];
      dropDTuning();
    } else if (tuning.value == 'Drop A') {
      tuningNotes.value = ['A1', 'A2', 'D3', 'G3', 'B3', 'E4'];
      dropATuning();
    } else if (tuning.value == 'Half step down') {
      tuningNotes.value = ['D#2', 'G#2', 'C#3', 'F#3', 'A#3', 'D#4'];
      halfStepDownTuning();
    } else if (tuning.value == 'Open C') {
      tuningNotes.value = ['C2', 'G2', 'C3', 'G3', 'C4', 'E4'];
      openCTuning();
    } else if (tuning.value == 'Open D') {
      tuningNotes.value = ['D2', 'A2', 'D3', 'F#3', 'A3', 'D4'];
      openDTuning();
    } else if (tuning.value == 'Open F') {
      tuningNotes.value = ['C2', 'F2', 'C3', 'F3', 'A3', 'F4'];
      openFTuning();
    } else if (tuning.value == 'Open G') {
      tuningNotes.value = ['D2', 'G2', 'D3', 'G3', 'B3', 'D4'];
      openGTuning();
    } else {
      tuningNotes.value = [];
    }
  }

  void tune(target) {
    frequency.value = target;
    diff.value = (actualFrequency.value - target);
    if (diff.value.abs() <= 1.5) {
      status.value = 'tuned';
      diff.value = 0.0;
    } else if (diff.value > 1.5 && diff.value <= 3.0) {
      status.value = 'high';
    } else if (diff.value < -1.5 && diff.value >= -3.0) {
      status.value = 'low';
    } else if (diff.value <= -3.0) {
      status.value = 'too low';
    } else {
      status.value = 'too high';
    }
  }

  void standardTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'E2';
      tune(82.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass4Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0) {
      note.value = 'G2';
      tune(97.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass5Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 41.0) {
      note.value = 'B0';
      tune(30.0);
    }
    if (frequency.value >= 41.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0) {
      note.value = 'G2';
      tune(97.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void bass6Tuning() {
    if (frequency.value >= 30.0 && frequency.value < 41.0) {
      note.value = 'B0';
      tune(30.0);
    }
    if (frequency.value >= 41.0 && frequency.value < 55.0) {
      note.value = 'E1';
      tune(41.0);
    } else if (frequency.value >= 55.0 && frequency.value < 73.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 73.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0 && frequency.value < 130.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 130.0) {
      note.value = 'C3';
      tune(130.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void dropDTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void dropATuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'A1';
      tune(55.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 195.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 329.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void halfStepDownTuning() {
    if (frequency.value >= 30.0 && frequency.value < 103.0) {
      note.value = 'D#2';
      tune(77.0);
    } else if (frequency.value >= 103.0 && frequency.value < 138.0) {
      note.value = 'G#2';
      tune(103.0);
    } else if (frequency.value >= 138.0 && frequency.value < 185.0) {
      note.value = 'C#3';
      tune(138.0);
    } else if (frequency.value >= 185.0 && frequency.value < 233.0) {
      note.value = 'F#3';
      tune(185.0);
    } else if (frequency.value >= 233.0 && frequency.value < 311.0) {
      note.value = 'A#3';
      tune(233.0);
    } else if (frequency.value >= 311.0) {
      note.value = 'D#4';
      tune(311.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openCTuning() {
    if (frequency.value >= 30.0 && frequency.value < 97.0) {
      note.value = 'C2';
      tune(65.0);
    } else if (frequency.value >= 97.0 && frequency.value < 130.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 130.0 && frequency.value < 195.0) {
      note.value = 'C3';
      tune(130.0);
    } else if (frequency.value >= 195.0 && frequency.value < 261.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 261.0 && frequency.value < 329.0) {
      note.value = 'C4';
      tune(261.0);
    } else if (frequency.value >= 329.0) {
      note.value = 'E4';
      tune(329.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openDTuning() {
    if (frequency.value >= 30.0 && frequency.value < 110.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 110.0 && frequency.value < 146.0) {
      note.value = 'A2';
      tune(110.0);
    } else if (frequency.value >= 146.0 && frequency.value < 185.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 185.0 && frequency.value < 220.0) {
      note.value = 'F#3';
      tune(185.0);
    } else if (frequency.value >= 220.0 && frequency.value < 293.0) {
      note.value = 'A3';
      tune(220.0);
    } else if (frequency.value >= 293.0) {
      note.value = 'D4';
      tune(293.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openFTuning() {
    if (frequency.value >= 30.0 && frequency.value < 87.0) {
      note.value = 'C2';
      tune(65.0);
    } else if (frequency.value >= 87.0 && frequency.value < 130.0) {
      note.value = 'F2';
      tune(87.0);
    } else if (frequency.value >= 130.0 && frequency.value < 174.0) {
      note.value = 'C3';
      tune(130.0);
    } else if (frequency.value >= 174.0 && frequency.value < 220.0) {
      note.value = 'F3';
      tune(174.0);
    } else if (frequency.value >= 220.0 && frequency.value < 349.0) {
      note.value = 'A3';
      tune(220.0);
    } else if (frequency.value >= 349.0) {
      note.value = 'F4';
      tune(349.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void openGTuning() {
    if (frequency.value >= 30.0 && frequency.value < 97.0) {
      note.value = 'D2';
      tune(73.0);
    } else if (frequency.value >= 97.0 && frequency.value < 146.0) {
      note.value = 'G2';
      tune(97.0);
    } else if (frequency.value >= 146.0 && frequency.value < 196.0) {
      note.value = 'D3';
      tune(146.0);
    } else if (frequency.value >= 195.0 && frequency.value < 246.0) {
      note.value = 'G3';
      tune(195.0);
    } else if (frequency.value >= 246.0 && frequency.value < 293.0) {
      note.value = 'B3';
      tune(246.0);
    } else if (frequency.value >= 293.0) {
      note.value = 'D4';
      tune(293.0);
    } else {
      note.value = '';
      frequency.value = 0.0;
      diff.value = 0.0;
      status.value = 'Play something';
    }
  }

  void onError(e) {
    print("Error in tuner: $e");
  }
}
