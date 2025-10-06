import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/settings_controller.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/models/settings_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _settingsController = Get.find<SettingsController>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(
                color: AppThemes.getTextColor(isDarkMode),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
            iconTheme: IconThemeData(color: AppThemes.getTextColor(isDarkMode)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
          body: SafeArea(
            child: Obx(() => ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    // Guitar Type Section
                    _buildSectionHeader('Guitar Visualization', isDarkMode),
                    _buildSettingCard(
                      title: 'Guitar Type',
                      description: 'Choose which guitar type to display in the tuner',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _settingsController.settings.value.guitarType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            items: _settingsController.supportedGuitarTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type.capitalizeFirst!),
                              );
                            }).toList(),
                            onChanged: (value) {
                                    if (value != null) {
                                      _settingsController.setGuitarType(value);
                                    }
                                  },
                            dropdownColor: AppThemes.getCardColor(isDarkMode),
                            style: TextStyle(
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    ),
            
                    // _buildSectionHeader('Application Settings', isDarkMode),
                    // _buildSettingCard(
                    //   title: 'Tutorial Tips',
                    //   description: 'Show helpful tips when using the app',
                    //   content: Switch(
                    //     value: _settingsController.settings.value.showTutorialTips,
                    //     onChanged: (value) {
                    //       _settingsController.toggleTutorialTips(value);
                    //     },
                    //     activeColor: AppThemes.getMainColor(isDarkMode),
                    //   ),
                    //   isDarkMode: isDarkMode,
                    // ),
            
                    _buildSettingCard(
                      title: 'Metrnome Sounds',
                      description: 'Choose metrnome sounds for the first and other beats respectively',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _settingsController.settings.value.firstBeatSound,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            items: _settingsController.wavs.map((sound) {
                              return DropdownMenuItem<String>(
                                value: sound,
                                child: Text(sound.capitalizeFirst!),
                              );
                            }).toList(),
                            onChanged: (value) {
                                    if (value != null) {
                                      _settingsController.setFirstBeatSound(value);
                                    }
                                  },
                            dropdownColor: AppThemes.getCardColor(isDarkMode),
                            style: TextStyle(
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _settingsController.settings.value.otherBeatsSound,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            items: _settingsController.wavs.map((sound) {
                              return DropdownMenuItem<String>(
                                value: sound,
                                child: Text(sound.capitalizeFirst!),
                              );
                            }).toList(),
                            onChanged: (value) {
                                    if (value != null) {
                                      _settingsController.setOtherBeatsSound(value);
                                    }
                                  },
                            dropdownColor: AppThemes.getCardColor(isDarkMode),
                            style: TextStyle(
                              color: AppThemes.getTextColor(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    ),
            
                    _buildSectionHeader('Audio Settings', isDarkMode),
                    _buildSettingCard(
                      title: 'Silence Threshold',
                      description: 'Adjust the sensitivity of note detection',
                      content: Column(
                        children: [
                          Slider(
                            value: _settingsController.settings.value.silenceThreshold,
                            min: 0.01,
                            max: 0.2,
                            divisions: 19,
                            label: _settingsController.settings.value.silenceThreshold.toStringAsFixed(2),
                            onChanged: (value) {
                              _settingsController.setSilenceThreshold(value);
                            },
                            activeColor: AppThemes.getMainColor(isDarkMode),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'More sensitive',
                                style: TextStyle(
                                  color: AppThemes.getTextColor(isDarkMode),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Less sensitive',
                                style: TextStyle(
                                  color: AppThemes.getTextColor(isDarkMode),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    ),
                    
                    ElevatedButton(
                      onPressed: () {
                        _showResetConfirmationDialog(context, isDarkMode);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.getErrorColor(),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Reset All Settings'),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppThemes.getMainColor(isDarkMode),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String description,
    required Widget content,
    required bool isDarkMode,
  }) {
    return Card(
      color: AppThemes.getCardColor(isDarkMode),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppThemes.getTextColor(isDarkMode),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Settings'),
        content: Text('Are you sure you want to reset all settings to default values?'),
        backgroundColor: AppThemes.getCardColor(isDarkMode),
        titleTextStyle: TextStyle(
          color: AppThemes.getTextColor(isDarkMode),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(
          color: AppThemes.getTextColor(isDarkMode),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
            ),
          ),
          TextButton(
            onPressed: () {
              _settingsController.settings.value = SettingsModel(); // Reset to defaults
              _settingsController.update();
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings reset to defaults',style: TextStyle(
                            color: AppThemes.getTextColor(isDarkMode),
                          ),),
                  backgroundColor: AppThemes.getCardColor(isDarkMode),
                ),
              );
            },
            child: Text(
              'Reset',
              style: TextStyle(color: AppThemes.getErrorColor()),
            ),
          ),
        ],
      ),
    );
  }
}

Widget settingsView() => SettingsView();