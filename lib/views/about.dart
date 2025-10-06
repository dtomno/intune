import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;
        
        return Scaffold(
          backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
          appBar: AppBar(
            title: Text(
              'About InTune',
              style: TextStyle(
                color: AppThemes.getTextColor(isDarkMode),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
            iconTheme: IconThemeData(
              color: AppThemes.getTextColor(isDarkMode),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo and app name section
                    CircleAvatar(
                      backgroundColor: AppThemes.getCardColor(isDarkMode),
                      foregroundImage: const AssetImage('images/logos.png'),
                      radius: 75.0,
                    ),
                    const SizedBox(height: 24),
                    
                    // App name and version
                    Text(
                      'InTune',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.getMainColor(isDarkMode),
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppThemes.getTextColor(isDarkMode).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // App description
                    _buildSection(
                      title: 'About InTune',
                      content: 'InTune is a professional guitar tuning and music tool app designed for musicians of all levels. '
                              'It features a precision guitar tuner with multiple tuning options, a metronome, and chord library to enhance your playing experience.',
                      isDarkMode: isDarkMode,
                    ),
                    
                    _buildSection(
                      title: 'Features',
                      content: '• Guitar tuner with multiple tuning options\n'
                              '• Metronome with custom BPM settings\n'
                              '• Comprehensive chord library\n'
                              '• Dark and light theme support\n'
                              '• Simple and intuitive interface',
                      isDarkMode: isDarkMode,
                    ),
                    
                    _buildSection(
                      title: 'Developer',
                      content: 'Created with ♥ by DAKTARI DEV',
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Contact and social links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: FontAwesomeIcons.github,
                          url: 'https://github.com/dtomno',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 24),
                        _buildSocialButton(
                          icon: Icons.email,
                          url: 'apptests.tomno@gmail.com',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 24),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.globe,
                          url: 'https://dennis-tomno.onrender.com',
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Copyright and attribution
                    Text(
                      '© ${DateTime.now().year} InTune - All Rights Reserved',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemes.getTextColor(isDarkMode).withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Text(
                    //   'Made with Flutter',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: AppThemes.getTextColor(isDarkMode).withOpacity(0.6),
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  
  Widget _buildSection({required String title, required String content, required bool isDarkMode}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemes.getMainColor(isDarkMode),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppThemes.getTextColor(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () async {
        try {
          // Handle email addresses differently from web URLs
          if (url.contains('@')) {
            // This is an email address
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: url,
            );
            await launchUrl(emailUri);
          } else {
            // This is a web URL
            final Uri uri = Uri.parse(url);
            // Use inAppWebView for Flutter web URLs
            final LaunchMode mode = url.contains('flutter.dev') 
                ? LaunchMode.inAppWebView 
                : LaunchMode.externalApplication;
                
            await launchUrl(uri, mode: mode);
          }
        } catch (e) {
          // Handle errors gracefully
          debugPrint('Could not launch $url: $e');
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppThemes.getMainColor(isDarkMode),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
