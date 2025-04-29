import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/views/tools/chords.dart';
import 'package:intune/views/tools/metro.dart';

Widget tools() => GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tools',
                  style: TextStyle(
                    fontSize: 26, 
                    color: AppThemes.getMainColor(isDark),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Metronome',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppThemes.getTextColor(isDark),
                  ),
                ),
                Card(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: const AssetImage('images/tempo.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withAlpha(180), BlendMode.dstATop),
                          height: 220,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const Metro());
                            },
                          ),
                        ),
                        Icon(
                          CupertinoIcons.metronome,
                          size: 40,
                          color: AppThemes.getMainColor(isDark),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Chords',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppThemes.getTextColor(isDark),
                  ),
                ),
                Card(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: const AssetImage('images/chords.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withAlpha(180), BlendMode.dstATop),
                          height: 220,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => Chords());
                            },
                          ),
                        ),
                        Icon(
                          Icons.tune,
                          size: 40,
                          color: AppThemes.getMainColor(isDark),
                        )
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
