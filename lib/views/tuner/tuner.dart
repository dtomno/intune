import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/controllers/tuner.dart';

final _tunerController = Get.find<TunerController>();
final imageScaleFactor = 1.3;
GlobalKey imageKey = GlobalKey();

class TunerView extends StatelessWidget {
  const TunerView({super.key});

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
                _buildHeader(isDarkMode),
                _buildTuningArea(isDarkMode),
                Expanded(child: _buildHeadstockSection(isDarkMode)),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget tuner() => TunerView();

Widget _buildHeader(bool isDarkMode) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Obx(() => Text(_tunerController.isRecording.value ? 'ON' :'OFF', style: TextStyle(color: _tunerController.isRecording.value ? AppThemes.getMainColor(isDarkMode) : AppThemes.getTextColor(isDarkMode), fontSize: 16))
              ),
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
          Expanded(child: _buildInstrumentSelector(isDarkMode)),
        ],
      ),
    );

Widget _buildInstrumentSelector(bool isDarkMode) => Padding(
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
    );

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

Widget _buildTuningArea(bool isDarkMode) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Container(
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
                  final deviation = _tunerController.diff.value;
                  
                  // Calculate horizontal offset based on pitch deviation
                  // Map the deviation range to pixel offset (-30 to 30 pixels)
                  // Limit the maximum movement to keep it visible
                  double maxOffset = 160.0;
                  double offsetX = deviation * 10.0; // Scale factor to control sensitivity
                  offsetX = offsetX.clamp(-maxOffset, maxOffset);

                  Color noteColorAny = AppThemes.getTextColor(isDarkMode);
                  if(note.isEmpty){
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
                      offset: _tunerController.isRecording.value ? Offset(offsetX, 0)
                      : Offset(0, 0),
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
                                color: _tunerController.isRecording.value ? noteColor
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
          Obx(() => !_tunerController.isDetectingPitch.value && _tunerController.tuningNotes.isEmpty
              ? Container(
                  child: AnimatedOpacity(
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
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tunerController.tuningNotes.isNotEmpty
                        ? '${_tunerController.status.value} ${_tunerController.diff.value.round()}'
                        : '',
                    style: TextStyle(color: AppThemes.getTextColor(isDarkMode), fontSize: 12),
                  ),
                )),
        ],
      ),
    );

Offset getStringPositionOnHeadstock(int index) {
  // Return more accurate positions for each string based on the string index (0-5)
  switch (index) {
    case 0:
      return Offset(1700,600); // Low E string (lowest)
    case 1:
      return Offset(1700,940); // A string (second lowest)
    case 2:
      return Offset(1700,1290); // D string (middle-lower)
    case 3:
      return Offset(1710,1290); // G string (middle-upper)
    case 4:
      return Offset(1710,940); // B string (second highest)
    case 5:
      return Offset(1710, 600); // High E string (highest)
    default:
      return Offset(0, 0);
  }
}

Widget _buildHeadstockSection(bool isDarkMode) => Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Center the headstock image
                    Center(
                      child: Transform.scale(
                        scale: imageScaleFactor,
                        child: Image.asset(
                          'images/tuner/headstock.png',
                          fit: BoxFit.contain,
                          key: imageKey,
                        ),
                      ),
                    ),
                    
                    // Position string buttons
                    Obx(() {
                      
                      return Stack(
                        children: _tunerController.tuningNotes.asMap().entries.map((entry) {
                          int index = entry.key;
                          String note = entry.value;
                          
                          RenderBox? box = imageKey.currentContext?.findRenderObject() as RenderBox?;
                          if (box != null && box.hasSize) {
                            final Offset position = box.localToGlobal(Offset.zero);
                            final Size size = box.size;

                            final Rect imageRect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

                            // Now compare with screen size
                            final Size screenSize = MediaQuery.of(context).size;
                            final Rect screenRect = Offset.zero & screenSize;

                            final Rect visibleRect = imageRect.intersect(screenRect);

                            //print('Visible Rect: $visibleRect');
                            // print('Image Rect: $imageRect');
                            // print('Screen Rect: $screenRect');

                            double relativeX = (imageScaleFactor) * ((getStringPositionOnHeadstock(index).dx * visibleRect.width)/2304);
                            double relativeY = (imageScaleFactor) * ((getStringPositionOnHeadstock(index).dy * visibleRect.height)/1792);
                          
                            // Left side strings (0-2)
                            if(index <= 2) {
                              return Positioned(
                                right: relativeX.roundToDouble(),
                                bottom: relativeY.roundToDouble(),
                                child: _buildNoteCircle(note, 
                                  isActive: _tunerController.isRecording.value && note == _tunerController.note.value, 
                                  isDarkMode: isDarkMode),
                              );
                            } 
                            // Right side strings (3-5)
                            else {
                              return Positioned(
                                left: relativeX.roundToDouble(),
                                bottom: relativeY.roundToDouble(),
                                child: _buildNoteCircle(note, 
                                  isActive: _tunerController.isRecording.value && note == _tunerController.note.value, 
                                  isDarkMode: isDarkMode),
                              );
                            }
                          }
                          return Container(); // Fallback in case of null box
                          
                          
                        }).toList()
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );

Widget _buildNoteCircle(String note, {bool isActive = false, required bool isDarkMode}) {
  return Container(
    width: 40,
    height: 40,
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
    for (int i = -8; i <= 8; i++) {
      if (i == 0) continue; // Skip center line as we've already drawn it
      
      final x = centerX + (i * 20.0); // 20px spacing between grid lines
      
      // Draw vertical grid lines
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, height),
        gridPaint,
      );
      
      // Add small tick marks at the top
      final tickHeight = i % 2 == 0 ? 15.0 : 10.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, tickHeight),
        gridPaint..strokeWidth = i % 2 == 0 ? 1.5 : 1.0,
      );
    }
    
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}