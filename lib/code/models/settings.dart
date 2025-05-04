import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  // Guitar image preference
  String guitarType; // 'acoustic' or 'electric'
  
  // Tuner settings
  int sampleRate;
  int frameLength;
  double silenceThreshold;
  
  // App settings
  bool showTutorialTips;
  bool saveRecentTunings;
  int maxSavedTunings;

  Settings({
    this.guitarType = 'acoustic',
    this.sampleRate = 44100,
    this.frameLength = 2048,
    this.silenceThreshold = 0.05,
    this.showTutorialTips = true,
    this.saveRecentTunings = true,
    this.maxSavedTunings = 5,
  });

  // Convert settings to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'guitarType': guitarType,
      'sampleRate': sampleRate,
      'frameLength': frameLength,
      'silenceThreshold': silenceThreshold,
      'showTutorialTips': showTutorialTips,
      'saveRecentTunings': saveRecentTunings,
      'maxSavedTunings': maxSavedTunings,
    };
  }

  // Create settings from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      guitarType: json['guitarType'] ?? 'acoustic',
      sampleRate: json['sampleRate'] ?? 44100,
      frameLength: json['frameLength'] ?? 2048,
      silenceThreshold: json['silenceThreshold'] ?? 0.05,
      showTutorialTips: json['showTutorialTips'] ?? true,
      saveRecentTunings: json['saveRecentTunings'] ?? true,
      maxSavedTunings: json['maxSavedTunings'] ?? 5,
    );
  }
  
  // Save settings to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('guitarType', guitarType);
    await prefs.setInt('sampleRate', sampleRate);
    await prefs.setInt('frameLength', frameLength);
    await prefs.setDouble('silenceThreshold', silenceThreshold);
    await prefs.setBool('showTutorialTips', showTutorialTips);
    await prefs.setBool('saveRecentTunings', saveRecentTunings);
    await prefs.setInt('maxSavedTunings', maxSavedTunings);
  }

  // Load settings from SharedPreferences
  static Future<Settings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      guitarType: prefs.getString('guitarType') ?? 'acoustic',
      sampleRate: prefs.getInt('sampleRate') ?? 44100,
      frameLength: prefs.getInt('frameLength') ?? 2048,
      silenceThreshold: prefs.getDouble('silenceThreshold') ?? 0.05,
      showTutorialTips: prefs.getBool('showTutorialTips') ?? true,
      saveRecentTunings: prefs.getBool('saveRecentTunings') ?? true,
      maxSavedTunings: prefs.getInt('maxSavedTunings') ?? 5,
    );
  }
}