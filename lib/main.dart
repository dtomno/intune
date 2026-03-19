import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intune/code/bindings/dependencies.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/translations/app_translations.dart';
import 'package:intune/navigation_observer.dart';
import 'package:intune/views/home.dart';
import 'package:intune/views/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'code/controllers/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final welcomeSeen = prefs.getBool('welcome_seen') ?? false;
  Get.put(HomeController());
  Get.put(ThemeController());
  runApp(MyApp(showWelcome: !welcomeSeen));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.showWelcome});
  final bool showWelcome;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called by Flutter when the device/per-app locale changes (Android 13+).
  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      Get.updateLocale(locales.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetMaterialApp(
        initialBinding: DependenciesBinding(),
        debugShowCheckedModeBanner: false,
        title: 'InTune - Guitar Tuner',
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        themeMode: themeController.themeMode,
        theme: AppThemes.getLightTheme(),
        darkTheme: AppThemes.getDarkTheme(),
        home: widget.showWelcome ? const WelcomeScreen() : const Home(),
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
