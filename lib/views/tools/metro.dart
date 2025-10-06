import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/metro.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';

class Metro extends StatefulWidget {
  const Metro({super.key});

  @override
  State<Metro> createState() => _MetroState();
}

class _MetroState extends State<Metro> with WidgetsBindingObserver {
  final _metroController = Get.find<MetroController>();
  final _themeController = Get.find<ThemeController>();

  final List<DropdownMenuItem<int>> times = const [
    DropdownMenuItem(
      value: 1,
      child: Text('1/4'),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('2/4'),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('3/4'),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('4/4'),
    ),
    DropdownMenuItem(
      value: 6,
      child: Text('6/8'),
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    
    // Reset the starting tempo to 100 BPM if not already set
    if (_metroController.tempo.value == 30.0) {
      _metroController.tempo.value = 100.0;
    }
  }

  @override
  void dispose() {
    if (_metroController.play.value) {
      _metroController.stop();
    }
    // _tunerController.recordAudio();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Stop metronome if app goes to background
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.inactive) {
      if (_metroController.play.value) {
        _metroController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeController.isDarkMode;
    final mainColor = AppThemes.getMainColor(isDark);
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Text(
          'Metronome',
          style: TextStyle(
            color: AppThemes.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppThemes.getCardColor(isDark),
        iconTheme: IconThemeData(color: AppThemes.getTextColor(isDark)),
        // elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Tempo display section
            _buildTempoDisplay(isDark, mainColor),
            
            // Beat visualization
            _buildBeatVisualizer(isDark, mainColor, screenSize),
            
            // Time signature section
            _buildTimeSignatureSection(isDark, mainColor),
            
            // Bottom control section
            _buildControlSection(isDark, mainColor),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTempoDisplay(bool isDark, Color mainColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BPM display
          Obx(
            () => Text(
              '${_metroController.tempo.round()} BPM',
              style: TextStyle(
                fontSize: 28,
                color: AppThemes.getTextColor(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Add tempo name indicator
          Obx(() => Text(
            _getTempoName(_metroController.tempo.value),
            style: TextStyle(
              fontSize: 14,
              color: AppThemes.getTextColor(isDark),
              fontStyle: FontStyle.italic,
            ),
          )),
          
          const SizedBox(height: 20),
          
          // Tempo controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Faster decrease button
              _buildTempoButton(
                icon: Icons.fast_rewind,
                onPressed: () => _adjustTempo(-10),
                isDark: isDark,
                mainColor: mainColor,
                tooltip: 'Decrease by 10',
              ),
              
              // Decrease button
              _buildTempoButton(
                icon: Icons.remove,
                onPressed: () => _adjustTempo(-1),
                isDark: isDark,
                mainColor: mainColor,
                tooltip: 'Decrease by 1',
              ),
              
              // Slider control
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Obx(
                    () => Slider(
                      value: _metroController.tempo.value,
                      onChanged: (value) {
                        _metroController.tempo.value = value.round().toDouble();
                      },
                      onChangeEnd: (value) => 
                          _metroController.updateTempo(value.round().toDouble()),
                      max: 240.0,
                      min: 40.0,
                      activeColor: mainColor,
                      inactiveColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              
              // Increase button
              _buildTempoButton(
                icon: Icons.add,
                onPressed: () => _adjustTempo(1),
                isDark: isDark,
                mainColor: mainColor,
                tooltip: 'Increase by 1',
              ),
              
              // Faster increase button
              _buildTempoButton(
                icon: Icons.fast_forward,
                onPressed: () => _adjustTempo(10),
                isDark: isDark,
                mainColor: mainColor,
                tooltip: 'Increase by 10',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeatVisualizer(bool isDark, Color mainColor, Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(
            _metroController.beats.value,
            (i) => Obx(
              () {
                final isCurrentBeat = i == _metroController.count.value;
                final isFirstBeat = i == 0;
                final isActive = isCurrentBeat && _metroController.play.value;
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.easeInOut,
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppThemes.getSuccessColor(isDark)
                        : AppThemes.getInactiveColor(isDark),
                    borderRadius: BorderRadius.circular(
                      isActive ? 25 : 16
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: (isFirstBeat 
                                ? AppThemes.getSuccessColor(isDark) 
                                : mainColor),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSignatureSection(bool isDark, Color mainColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'Time Signature',
            style: TextStyle(
              fontSize: 18,
              color: AppThemes.getTextColor(isDark),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppThemes.getCardColor(isDark),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mainColor.withOpacity(0.5)),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _metroController.beats.value,
                  items: times,
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: AppThemes.getCardColor(isDark),
                  style: TextStyle(
                    color: AppThemes.getTextColor(isDark),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: mainColor),
                  onChanged: (int? value) {
                    if (value != null) {
                      final wasPlaying = _metroController.play.value;
                      if (wasPlaying) {
                        _metroController.stop();
                      }
                      _metroController.beats.value = value;
                      if (wasPlaying) {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _metroController.start();
                        });
                      }
                    }
                  }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection(bool isDark, Color mainColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          // Play/Pause button
          Obx(
            () => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _metroController.play.value = !_metroController.play.value;
                  if (_metroController.play.value) {
                    _metroController.start();
                  } else {
                    _metroController.stop();
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _metroController.play.value
                        ? AppThemes.getErrorColor()
                        : AppThemes.getSuccessColor(isDark),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _metroController.play.value 
                          ? Icons.pause 
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Status text
          Obx(
            () => Text(
                _metroController.play.value 
                    ? 'Tap to stop' 
                    : 'Tap to start',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _metroController.play.value 
                      ? AppThemes.getErrorColor()
                      : AppThemes.getSuccessColor(isDark),
                )),
          ),          
        ],
      ),
    );
  }
  
  Widget _buildTempoButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    required Color mainColor,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 28,
              color: mainColor,
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper method to adjust tempo with bounds checking
  void _adjustTempo(int delta) {
    final newTempo = _metroController.tempo.value + delta;
    if (newTempo >= 40 && newTempo <= 240) {
      _metroController.tempo.value = newTempo;
      _metroController.updateTempo(_metroController.tempo.value);
    }
  }
  
  // Helper to get the tempo name based on BPM
  String _getTempoName(double bpm) {
    if (bpm < 60) return 'Largo';
    if (bpm < 76) return 'Adagio';
    if (bpm < 108) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 168) return 'Allegro';
    if (bpm < 200) return 'Presto';
    return 'Prestissimo';
  }
}
