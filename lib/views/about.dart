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
              'about_intune'.tr,
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
                      'version'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppThemes.getTextColor(isDarkMode).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // App description
                    _buildSection(
                      title: 'about_intune'.tr,
                      content: 'about_description'.tr,
                      isDarkMode: isDarkMode,
                    ),

                    _buildSection(
                      title: 'features'.tr,
                      content: 'features_list'.tr,
                      isDarkMode: isDarkMode,
                    ),

                    _buildSection(
                      title: 'developer'.tr,
                      content: 'developer_credit'.tr,
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Contact and social links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white, size: 24),
                          url: 'https://github.com/dtomno',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 24),
                        _buildSocialButton(
                          icon: const Icon(Icons.email, color: Colors.white, size: 24),
                          url: 'apptests.tomno@gmail.com',
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 24),
                        _buildSocialButton(
                          icon: const FaIcon(FontAwesomeIcons.globe, color: Colors.white, size: 24),
                          url: 'https://dennis-tomno.onrender.com',
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),

                    // Privacy Policy
                    TextButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('https://github.com/dtomno/intune/blob/main/PRIVACY.md');
                        try {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          debugPrint('Could not open privacy policy: $e');
                        }
                      },
                      icon: Icon(Icons.privacy_tip_outlined,
                          size: 16,
                          color: AppThemes.getTextColor(isDarkMode).withOpacity(0.6)),
                      label: Text(
                        'privacy_policy'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppThemes.getTextColor(isDarkMode).withOpacity(0.6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Copyright and attribution
                    Text(
                      'copyright'.trParams({'year': '${DateTime.now().year}'}),
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
    required Widget icon,
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppThemes.getMainColor(isDarkMode),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
