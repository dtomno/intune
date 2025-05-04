class SettingsModel {
  final String guitarType;
  final bool showTutorialTips;
  final double silenceThreshold;
  final String firstBeatSound;
  final String otherBeatsSound;

  SettingsModel({
    this.guitarType = 'acoustic',
    this.showTutorialTips = true,
    this.silenceThreshold = 0.05,
    this.firstBeatSound = 'claves',
    this.otherBeatsSound = 'woodblock_high',
  });

  SettingsModel copyWith({
    String? guitarType,
    bool? showTutorialTips,
    double? silenceThreshold,
    String? firstBeatSound,
    String? otherBeatsSound,
  }) {
    return SettingsModel(
      guitarType: guitarType ?? this.guitarType,
      showTutorialTips: showTutorialTips ?? this.showTutorialTips,
      silenceThreshold: silenceThreshold ?? this.silenceThreshold,
      firstBeatSound: firstBeatSound ?? this.firstBeatSound,
      otherBeatsSound: otherBeatsSound ?? this.otherBeatsSound,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guitarType': guitarType,
      'showTutorialTips': showTutorialTips,
      'silenceThreshold': silenceThreshold,
      'firstBeatSound': firstBeatSound,
      'otherBreatsSound': otherBeatsSound,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      guitarType: json['guitarType'] ?? 'acoustic',
      showTutorialTips: json['showTutorialTips'] ?? true,
      silenceThreshold: json['silenceThreshold'] ?? 0.05,
      firstBeatSound: json['firstBeatSound'] ?? 'claves',
      otherBeatsSound: json['otherBreatsSound'] ?? 'woodblock_high',
    );
  }
}