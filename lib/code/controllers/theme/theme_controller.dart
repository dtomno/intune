import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

class ThemeController extends GetxController {
  static const String themeKey = 'THEME_MODE';
  
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;
  
  // Computed properties for UI to use
  bool get isDarkMode => 
      _themeMode.value == ThemeMode.dark || 
      (_themeMode.value == ThemeMode.system && 
       Get.mediaQuery.platformBrightness == Brightness.dark);

  // Initialize theme from saved preferences
  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }
  
  // Load theme settings from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(themeKey);
    
    if (savedTheme != null) {
      if (savedTheme == 'light') {
        setThemeMode(ThemeMode.light);
      } else if (savedTheme == 'dark') {
        setThemeMode(ThemeMode.dark);
      } else {
        setThemeMode(ThemeMode.system);
      }
    }
  }
  
  // Save theme settings to SharedPreferences
  Future<void> _saveThemeToPrefs(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (mode == ThemeMode.light) {
      await prefs.setString(themeKey, 'light');
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(themeKey, 'dark');
    } else {
      await prefs.setString(themeKey, 'system');
    }
  }
  
  // Change theme mode and save the setting
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _saveThemeToPrefs(mode);
  }
  
  // Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
    
    // Force update all GetX widgets
    update();
    
    // Force rebuild of views that might not be listening to theme changes
    Future.delayed(Duration(milliseconds: 10), () {
      Get.forceAppUpdate();
    });
  }
  
  // Set system theme mode with same update mechanism
  void useSystemTheme() {
    setThemeMode(ThemeMode.system);
    update();
    Future.delayed(Duration(milliseconds: 10), () {
      Get.forceAppUpdate();
    });
  }
  
  // Get the current theme data
  ThemeData get currentTheme => 
      isDarkMode ? AppThemes.getDarkTheme() : AppThemes.getLightTheme();
}