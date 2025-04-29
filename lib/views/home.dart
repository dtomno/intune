import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/home.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/controllers/tuner.dart';
import 'package:intune/views/about.dart';
import 'package:intune/views/songs/song_search_view.dart';
import 'package:intune/views/tools/tools_home.dart';
import 'package:intune/views/tuner/tuner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _homeController = Get.find<HomeController>();
  final _tunerController = Get.find<TunerController>();
  final _themeController = Get.find<ThemeController>();

  // Define a list of widget builder functions instead of direct widget instances
  final List<Widget Function()> _pageBuilders = [
    () => tuner(),
    () => songSearch(),
    () => tools()
  ];

  @override
  void initState() {
    super.initState();
    _tunerController.recordAudio();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'InTune',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppThemes.getTextColor(isDark),
              ),
            ),
            backgroundColor: AppThemes.getBackgroundColor(isDark),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => _themeController.toggleTheme(),
                tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                color: AppThemes.getTextColor(isDark),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppThemes.getTextColor(isDark),
                ),
                onSelected: (value) {
                  if (value == 0) {
                    Get.to(const About());
                  } else if (value == 1) {
                    _themeController.useSystemTheme(); // Use the new method
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Using system theme',
                          style: TextStyle(
                            color: AppThemes.getTextColor(isDark),
                          ),
                        ),
                        backgroundColor: AppThemes.getCardColor(isDark),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: AppThemes.getTextColor(isDark),
                          onPressed: () {},
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: AppThemes.getTextColor(isDark)),
                          const SizedBox(width: 8),
                          Text("About"),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.settings_brightness, color: AppThemes.getTextColor(isDark)),
                          const SizedBox(width: 8),
                          Text("Use system theme"),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Obx(
            () => Column(
              children: [
                Expanded(
                  // Call the builder function to get the actual widget when needed
                  child: _pageBuilders.elementAt(_homeController.selectedIndex.value)(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
                elevation: 8,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppThemes.getMainColor(isDark),
                iconSize: 22,
                selectedFontSize: 14,
                unselectedFontSize: 12,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedItemColor: isDark ? Colors.grey : Colors.grey.shade700,
                backgroundColor: AppThemes.getCardColor(isDark), // Using theme-consistent card color
                currentIndex: _homeController.selectedIndex.value,
                onTap: (index) => _homeController.selectedIndex.value = index,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(FontAwesomeIcons.guitar),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemes.getMainColor(isDark).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        FontAwesomeIcons.guitar,
                        color: AppThemes.getMainColor(isDark),
                      ),
                    ),
                    label: 'Tune',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.music_note),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemes.getMainColor(isDark).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.music_note,
                        color: AppThemes.getMainColor(isDark),
                      ),
                    ),
                    label: 'Songs',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.tune),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemes.getMainColor(isDark).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: AppThemes.getMainColor(isDark),
                      ),
                    ),
                    label: 'Tools',
                  ),
                ]),
          ),
        );
      },
    );
  }
}
