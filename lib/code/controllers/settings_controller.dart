import 'dart:convert';

import 'package:get/get.dart';
import 'package:intune/code/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Observable settings model
  final Rx<SettingsModel> settings = SettingsModel().obs;
  final List<String> wavs = [
    'base',
    'claves',
    'hihat',
    'snare',
    'sticks',
    'woodblock_high'
  ];
  
  // Supported guitar types
  final List<String> supportedGuitarTypes = ['acoustic', 'electric'];
    
  @override
  void onInit() async{
    super.onInit();
    await _loadSettings();
  }
  
  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? settingsJson = prefs.getString('app_settings');
      
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
        settings.value = SettingsModel.fromJson(settingsMap);
      }
    } catch (e) {
      // print('Error loading settings: $e');
    }
  }
  
  // Save settings to shared preferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String settingsJson = jsonEncode(settings.value.toJson());
      await prefs.setString('app_settings', settingsJson);
    } catch (e) {
      // print('Error saving settings: $e');
    }
  }
  
  // Guitar type settings
  void setGuitarType(String type) {
    if (supportedGuitarTypes.contains(type)) {
      settings.value = settings.value.copyWith(guitarType: type);
      _saveSettings();
      update();
    }
  }
  
  // Toggle tutorial tips
  void toggleTutorialTips(bool value) {
    settings.value = settings.value.copyWith(showTutorialTips: value);
    _saveSettings();
    update();
  }
  
  // Set silence threshold
  void setSilenceThreshold(double value) {
    settings.value = settings.value.copyWith(silenceThreshold: value);
    _saveSettings();
    update();
  }

  // Set first beat sound
  void setFirstBeatSound(String sound) {
    if (wavs.contains(sound)) {
      settings.value = settings.value.copyWith(firstBeatSound: sound);
      _saveSettings();
      update();
    }
  }

  // Set other beats sound
  void setOtherBeatsSound(String sound) {
    if (wavs.contains(sound)) {
      settings.value = settings.value.copyWith(otherBeatsSound: sound);
      _saveSettings();
      update();
    }
  }
}