import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intune/code/bindings/dependencies.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/navigation_observer.dart';
import 'package:intune/views/home.dart';

import 'code/controllers/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    Get.put(HomeController());
    Get.put(ThemeController());
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetMaterialApp(
        initialBinding: DependenciesBinding(),
        debugShowCheckedModeBanner: false,
        title: 'InTune - Guitar Tuner',
        themeMode: themeController.themeMode,
        theme: AppThemes.getLightTheme(),
        darkTheme: AppThemes.getDarkTheme(),
        home: const Home(),
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
