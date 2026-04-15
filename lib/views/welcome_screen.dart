import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_FeaturePage> _pages = [
    _FeaturePage(
      titleKey: 'welcome_feature_1_title',
      descKey: 'welcome_feature_1_desc',
      iconWidget: FaIcon(FontAwesomeIcons.guitar, size: 60, color: Colors.white),
      gradient: AppThemes.primaryGradient,
    ),
    _FeaturePage(
      titleKey: 'welcome_feature_2_title',
      descKey: 'welcome_feature_2_desc',
      iconWidget: Icon(Icons.av_timer, size: 60, color: Colors.white),
      gradient: AppThemes.secondaryGradient,
    ),
    _FeaturePage(
      titleKey: 'welcome_feature_3_title',
      descKey: 'welcome_feature_3_desc',
      iconWidget: Icon(Icons.library_music, size: 60, color: Colors.white),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppThemes.vibrantOrange, AppThemes.warmRed],
      ),
    ),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_seen', true);
    Get.off(() => const Home(), transition: Transition.fade);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'welcome_skip'.tr,
                  style: TextStyle(
                    color: AppThemes.getTextColor(isDark).withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                children: [
                  Text(
                    'welcome_title'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppThemes.getTextColor(isDark),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'welcome_subtitle'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppThemes.getTextColor(isDark).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _FeaturePageWidget(page: _pages[index], isDark: isDark);
                },
              ),
            ),

            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? AppThemes.primaryBlue
                        : AppThemes.primaryBlue.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'welcome_get_started'.tr
                        : 'welcome_next'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePage {
  final String titleKey;
  final String descKey;
  final Widget iconWidget;
  final LinearGradient gradient;

  const _FeaturePage({
    required this.titleKey,
    required this.descKey,
    required this.iconWidget,
    required this.gradient,
  });
}

class _FeaturePageWidget extends StatelessWidget {
  final _FeaturePage page;
  final bool isDark;

  const _FeaturePageWidget({required this.page, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: page.gradient,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: page.gradient.colors.first.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: page.iconWidget,
          ),
          const SizedBox(height: 36),
          Text(
            page.titleKey.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppThemes.getTextColor(isDark),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            page.descKey.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppThemes.getTextColor(isDark).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
