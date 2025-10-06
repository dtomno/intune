import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/settings_controller.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/controllers/tuner.dart';
import 'package:intune/code/models/settings_model.dart';
import 'package:intune/navigation_observer.dart';

class TunerView extends StatefulWidget {
  const TunerView({super.key});

  @override
  State<TunerView> createState() => _TunerState();
}

class _TunerState extends State<TunerView> with RouteAware {
  final _tunerController = Get.find<TunerController>();
  final _settingsController = Get.find<SettingsController>();
  double imageScaleFactor = 1.2;
  GlobalKey imageKey = GlobalKey();
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentImage = getHeadstockImagePath();
    });
    _worker = ever(_settingsController.settings, (SettingsModel updatedSettings) {
      if(!mounted) return;
      setState(() {
        _currentImage = getHeadstockImagePath();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _worker.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when another route above this one is popped (i.e., we are now on top).
    setState(() {
      _currentImage = getHeadstockImagePath();
    });
  }

  Map<String,String> guitarImages = {
      'acoustic': 'images/tuner/headstock.png',
      'electric': 'images/tuner/headstock_electric.png',
      'bass4': 'images/tuner/headstock_bass4.png',
      'bass5': 'images/tuner/headstock_bass5.png',
      'bass6': 'images/tuner/headstock_bass6.png'
  };
  
  String getHeadstockImagePath() {
    String tuning = _tunerController.tuning.value;
    if (tuning == 'Standard') {
      return _settingsController.settings.value.guitarType != 'electric' ? guitarImages['acoustic']! : guitarImages['electric']!;
    } else if (tuning == 'Bass (4 string)') {
      return guitarImages['bass4']!;
    } else if (tuning == 'Bass (5 string)') {
      return guitarImages['bass5']!;
    } else if (tuning == 'Bass (6 string)') {
      return guitarImages['bass6']!;
    } else {
      return _settingsController.settings.value.guitarType != 'electric' ? guitarImages['acoustic']! : guitarImages['electric']!;
    }
  }

  String _currentImage = '';

  Offset getStringPositionOnHeadstock(int index) {
    String tuning = _tunerController.tuning.value;

    if (tuning == 'Bass (4 string)') {
        return getStringPositionOnHeadstockBass4(index);
    } else if (tuning == 'Bass (5 string)') {
        return getStringPositionOnHeadstockBass5(index);
    } else if (tuning == 'Bass (6 string)') {
        return getStringPositionOnHeadstockBass6(index);
    } else {
        if(_settingsController.settings.value.guitarType == 'electric') {
          return getStringPositionOnHeadstockElectric(index);
        } else {
          return getStringPositionOnHeadstockNormal(index);
        }
    }
  }

  Future<ui.Image> getImageDimensions() async {
    ImageProvider imageProvider = AssetImage(_currentImage);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });

    stream.addListener(listener);
    final ui.Image image = await completer.future;
    stream.removeListener(listener);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;
        return Scaffold(
          backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Obx(() => Text(
                                _tunerController.isRecording.value ? 'ON' : 'OFF',
                                style: TextStyle(
                                    color: _tunerController.isRecording.value
                                        ? AppThemes.getMainColor(isDarkMode)
                                        : AppThemes.getTextColor(isDarkMode),
                                    fontSize: 16),
                              )),
                          const SizedBox(width: 8),
                          Obx(() => Switch(
                                value: _tunerController.isRecording.value,
                                onChanged: (value) {
                                  if (value) {
                                    _tunerController.recordAudio();
                                  } else {
                                    // Show confirmation dialog when trying to stop
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Stop Tuning?'),
                                        content: Text('Would you like to continue tuning?'),
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
                                            child: Text(
                                              'Stop',
                                              style: TextStyle(color: AppThemes.getErrorColor()),
                                            ),
                                            onPressed: () {
                                              _tunerController.stopAudio();
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Continue Tuning',
                                              style: TextStyle(color: AppThemes.getMainColor(isDarkMode)),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                activeColor: AppThemes.getSuccessColor(isDarkMode),
                                inactiveTrackColor: AppThemes.getInactiveColor(isDarkMode),
                              )),
                        ],
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppThemes.getInactiveColor(isDarkMode), width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton<String>(
                                value: _tunerController.tuning.value,
                                isDense: true,
                                isExpanded: true,
                                dropdownColor: AppThemes.getCardColor(isDarkMode),
                                icon: Icon(Icons.arrow_drop_down, color: AppThemes.getTextColor(isDarkMode)),
                                style: TextStyle(color: AppThemes.getTextColor(isDarkMode), fontSize: 18),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    _tunerController.tuning.value = newValue;
                                    _tunerController.updateTuningNotes();
                                    setState(() {
                                      _currentImage = getHeadstockImagePath();
                                    });
                                  }
                                },
                                items: _tunerController.tunings
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.value,
                                          child: Text(item.value.toString()),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              painter: _GridBackgroundPainter(isDarkMode),
                              size: Size(double.infinity, 80),
                            ),
                            Obx(() {
                              final note = _tunerController.note.value.isEmpty ? '' : _tunerController.note.value;
                              final isDetectingPitch = _tunerController.isDetectingPitch.value;
                              final accuracy = _tunerController.tuningAccuracy.value;
                              final isInTune = accuracy.abs() < 0.2;

                              // Calculate horizontal offset based on tuning accuracy (in cents)
                              // tuningAccuracy ranges from -1.0 to 1.0 (±50 cents)
                              // Map this to pixel offset for visual feedback
                              double maxOffset = 100.0;
                              double offsetX = accuracy * maxOffset; // Direct mapping since accuracy is already normalized
                              // No need to clamp since accuracy is already clamped to -1.0 to 1.0

                              Color noteColorAny = AppThemes.getTextColor(isDarkMode);
                              if (note.isEmpty) {
                                noteColorAny = AppThemes.getTextColor(isDarkMode);
                              } else if (_tunerController.isRecording.value && isDetectingPitch && isInTune) {
                                noteColorAny = AppThemes.getSuccessColor(isDarkMode);
                              } else if (_tunerController.isRecording.value && isDetectingPitch && !isInTune) {
                                noteColorAny = AppThemes.getWarningColor(isDarkMode);
                              }

                              Color noteColor = _tunerController.tuning.value != 'Any (Detects all notes)'
                                  ? getColorBasedOnTuningStatus(_tunerController.status.value, isDarkMode)
                                  : noteColorAny;

                              return Obx(
                                () => Transform.translate(
                                  offset: _tunerController.isRecording.value ? Offset(offsetX, 0) : Offset(0, 0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Main note circle
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _tunerController.isRecording.value
                                                ? noteColor
                                                : AppThemes.getInactiveColor(isDarkMode),
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _tunerController.isRecording.value ? note : '',
                                            style: TextStyle(
                                              color: noteColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Deviation indicator circle
                                      if (_tunerController.isRecording.value && isDetectingPitch && note.isNotEmpty)
                                        Positioned(
                                          top: -2,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: noteColor.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => _tunerController.isDetectingPitch.value && _tunerController.tuningNotes.isEmpty
                          ? AnimatedOpacity(
                            opacity: _tunerController.isDetectingPitch.value ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Start tuning by playing any string',
                                style: TextStyle(color: AppThemes.getTextColor(isDarkMode), fontSize: 12),
                              ),
                            ),
                          )
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                !_tunerController.tuningNotes.isNotEmpty
                                    ? '${_tunerController.status.value} ${_tunerController.diff.value.round()}'
                                    : '',
                                style: TextStyle(color: AppThemes.getTextColor(isDarkMode), fontSize: 12),
                              ),
                            )),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                // Center the headstock image, using settings for guitar type
                                Center(
                                      child: Transform.scale(
                                        scale: imageScaleFactor,
                                        child: Image.asset(
                                          _currentImage,
                                          fit: BoxFit.contain,
                                          key: imageKey,
                                        ),
                                      ),
                                    ),

                                // Position string buttons
                                FutureBuilder<ui.Image>(
                                  future: getImageDimensions(), // fetch only once
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox(); // or CircularProgressIndicator()
                                    }

                                    final ui.Image image = snapshot.data!;
                                    final imageWidth = image.width.toDouble();
                                    final imageHeight = image.height.toDouble();

                                    return Obx(() {
                                      return Stack(
                                        children: _tunerController.tuningNotes.asMap().entries.map((entry) {
                                          int index = entry.key;
                                          String note = entry.value;

                                          RenderBox? box = imageKey.currentContext?.findRenderObject() as RenderBox?;
                                          if (box != null && box.hasSize) {
                                            final Size imageDisplaySize = box.size;
                                            
                                            // Get the relative position from the headstock function (0-1 range)
                                            final Offset relativePosition = getStringPositionOnHeadstock(index);
                                            
                                            // Convert relative position to actual pixel position on the displayed image
                                            double actualX = (relativePosition.dx / imageWidth) * imageDisplaySize.width;
                                            double actualY = (relativePosition.dy / imageHeight) * imageDisplaySize.height;
                                            
                                            // Center the circle on the calculated position
                                            double centerX = actualX - 20; // Half of circle width (40/2)
                                            double centerY = imageDisplaySize.height - actualY - 20; // Half of circle height (40/2), flip Y coordinate

                                            return Positioned(
                                              left: centerX,
                                              top: centerY,
                                              child: _buildNoteCircle(
                                                note,
                                                isActive: _tunerController.isRecording.value && note == _tunerController.note.value,
                                                isDarkMode: isDarkMode,
                                              ),
                                            );
                                          }

                                          return const SizedBox(); // Fallback if box is null
                                        }).toList(),
                                      );
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget tuner() => TunerView();

Color getColorBasedOnTuningStatus(String status, bool isDarkMode) {
  switch (status) {
    case 'tuned':
      return AppThemes.getSuccessColor(isDarkMode);
    case 'too low':
    case 'too high':
      return AppThemes.getErrorColor();
    case 'low':
    case 'high':
      return AppThemes.getWarningColor(isDarkMode);
    default:
      return AppThemes.getTextColor(isDarkMode);
  }
}

Offset getStringPositionOnHeadstockBass4(int index) {
  // Return relative positions (0.0 to 1.0) based on original image dimensions
  // Assuming original image width: ~2000px, height: ~2000px (adjust as needed)
  switch (index) {
    case 0:
      return Offset(200, 900); // Low E string (lowest)
    case 1:
      return Offset(200, 1350); // A string (second lowest)
    case 2:
      return Offset(2050, 1350); // D string (middle-lower)
    case 3:
      return Offset(2050, 900); // G string (middle-upper)
    default:
      return Offset(0, 0);
  }
}

Offset getStringPositionOnHeadstockBass5(int index) {
  // Return relative positions (0.0 to 1.0) based on original image dimensions
  switch (index) {
    case 0:
      return Offset(300, 470); // Low B string (lowest)
    case 1:
      return Offset(350, 750); // E string (second lowest)
    case 2:
      return Offset(400, 1030); // A string (middle-lower)
    case 3:
      return Offset(480, 1340); // D string (middle-upper)
    case 4:
      return Offset(1600, 650); // G string (second highest)
    default:
      return Offset(0, 0);
  }
}

Offset getStringPositionOnHeadstockBass6(int index) {
  // Return relative positions (0.0 to 1.0) based on original image dimensions
  switch (index) {
    case 0:
      return Offset(120, 400); // Low B string (lowest)
    case 1:
      return Offset(170, 620); // E string (second lowest)
    case 2:
      return Offset(200, 840); // A string (middle-lower)
    case 3:
      return Offset(1150, 800); // D string (middle-upper)
    case 4:
      return Offset(1200, 540); // G string (second highest)
    case 5:
      return Offset(1250, 320); // C string (highest)
    default:
      return Offset(0, 0);
  }
}

Offset getStringPositionOnHeadstockElectric(int index) {
  // Return relative positions (0.0 to 1.0) for electric guitar headstock
  switch (index) {
    case 0:
      return Offset(350, 530); // Low E string (lowest)
    case 1:
      return Offset(400, 730); // A string (second lowest)
    case 2:
      return Offset(450, 900); // D string (middle-lower)
    case 3:
      return Offset(500, 1080); // G string (middle-upper)
    case 4:
      return Offset(550, 1260); // B string (second highest)
    case 5:
      return Offset(600, 1430); // High E string (highest)
    default:
      return Offset(0, 0);
  }
}

Offset getStringPositionOnHeadstockNormal(int index) {
  // Return relative positions (0.0 to 1.0) for acoustic guitar headstock
  switch (index) {
    case 0:
      return Offset(350, 450); // Low E string (lowest)
    case 1:
      return Offset(350, 850); // A string (second lowest)
    case 2:
      return Offset(350, 1250); // D string (middle-lower)
    case 3:
      return Offset(1950, 1250); // G string (middle-upper)
    case 4:
      return Offset(1950, 850); // B string (second highest)
    case 5:
      return Offset(1950, 450); // High E string (highest)
    default:
      return Offset(0, 0);
  }
}

Widget _buildNoteCircle(String note, {bool isActive = false, required bool isDarkMode}) {
  final SettingsController settingsController = Get.find<SettingsController>();
  final TunerController tunerController = Get.find<TunerController>();
  final String guitarType = settingsController.settings.value.guitarType;
  final String tuning = tunerController.tuning.value;
  double radius = 40.0;

  if(tuning == 'Bass (4 string)') {
    radius = 40.0;
  } else if(tuning == 'Bass (5 string)') {
    radius = 30.0;
  } else if(tuning == 'Bass (6 string)') {
    radius = 30.0;
  }else {
    if(guitarType == 'electric') {
      radius = 30.0;
    } else {
      radius = 40.0;
    }
  }

  return Container(
    width:  radius,
    height: radius,
    decoration: BoxDecoration(
      color: isDarkMode ? Color(0xFF303030) : Color(0xFFE0E0E0),
      shape: BoxShape.circle,
      border: Border.all(
        color: isActive ? AppThemes.getMainColor(isDarkMode) : AppThemes.getInactiveColor(isDarkMode),
        width: isActive ? 2.0 : 1.0,
      ),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: AppThemes.getMainColor(isDarkMode).withOpacity(0.7),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]
          : [],
    ),
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            note,
            style: TextStyle(
              color: isActive ? AppThemes.getMainColor(isDarkMode) : AppThemes.getTextColor(isDarkMode),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

class _GridBackgroundPainter extends CustomPainter {
  final bool isDarkMode;

  _GridBackgroundPainter(this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final height = size.height;

    // Background grid line paint
    final gridPaint = Paint()
      ..color = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!
      ..strokeWidth = 1.0;

    // Center line paint (for perfect tune reference)
    final centerLinePaint = Paint()
      ..color = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!
      ..strokeWidth = 2.0;

    // Draw center line
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, height),
      centerLinePaint,
    );

    // Draw grid lines
    for (int i = -5; i <= 5; i++) {
      if (i == 0) continue; // Skip center line as we've already drawn it

      final x = centerX + (i * 40.0); // 40px spacing between grid lines

      // Draw vertical grid lines
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, height),
        gridPaint,
      );

      // Add small tick marks at the top
      final tickHeight = i % 2 == 0 ? 20.0 : 15.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, tickHeight),
        gridPaint..strokeWidth = i % 2 == 0 ? 2.0 : 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}