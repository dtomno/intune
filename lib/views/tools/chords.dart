import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/chords.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';

class Chords extends StatefulWidget {
  const Chords({super.key});

  @override
  State<Chords> createState() => _ChordsState();
}

class _ChordsState extends State<Chords> with SingleTickerProviderStateMixin {
  final _chordController = Get.find<ChordController>();
  final _themeController = Get.find<ThemeController>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeController.isDarkMode;
    final mainColor = AppThemes.getMainColor(isDark);
    final textColor = AppThemes.getTextColor(isDark);
    final cardColor = AppThemes.getCardColor(isDark);
    final backgroundColor = AppThemes.getBackgroundColor(isDark);
    final size = MediaQuery.of(context).size;
    CarouselSliderController resetController = CarouselSliderController();
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Chord Library',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        // elevation: 4,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                ? [backgroundColor, Color(0xFF1A1A1A)]
                : [backgroundColor, Color(0xFFEEEEEE)],
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 70,
                        height: 4,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Chord selector card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 6,
                  shadowColor: isDark ? Colors.black : Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Select Your Chord',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Root note dropdown
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: mainColor.withOpacity(0.5), width: 1.5),
                                ),
                                child: Obx(
                                  () => DropdownButton<String>(
                                    value: _chordController.chordName.value,
                                    items: _chordController.notes,
                                    isExpanded: true,
                                    underline: Container(),
                                    dropdownColor: cardColor,
                                    icon: Icon(Icons.keyboard_arrow_down, color: mainColor),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        _animationController.reset();
                                        _animationController.forward();
                                        _chordController.chordName.value = value;
                                        _chordController.chordList(
                                          _chordController.chordName.value,
                                          _chordController.chordType.value,
                                        );
                                        _chordController.currentIndex.value = 0; // Reset index to first image
                                        resetController.jumpToPage(0); // Reset carousel to first image
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Chord type dropdown
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: mainColor.withOpacity(0.5), width: 1.5),
                                ),
                                child: Obx(
                                  () => DropdownButton<String>(
                                    value: _chordController.chordType.value,
                                    items: _chordController.chordTypes,
                                    isExpanded: true,
                                    underline: Container(),
                                    dropdownColor: cardColor,
                                    icon: Icon(Icons.keyboard_arrow_down, color: mainColor),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _animationController.reset();
                                        _animationController.forward();
                                        _chordController.chordType.value = value.toString();
                                        _chordController.chordList(
                                          _chordController.chordName.value,
                                          _chordController.chordType.value,
                                        );
                                        _chordController.currentIndex.value = 0;
                                        resetController.jumpToPage(0); // Reset carousel to first image
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Info label
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe_rounded, 
                      color: mainColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        'Chord shape ${_chordController.currentIndex.value + 1} of ${_chordController.changingChords.length}',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Chord diagram carousel
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Selected chord name
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            '${_chordController.chordName.value}${_chordController.chordType.value}',
                            key: ValueKey('${_chordController.chordName.value}${_chordController.chordType.value}'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Chord diagram
                        Expanded(
                          child: CarouselSlider(
                            items: _chordController.changingChords.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark ? Colors.black38 : Colors.black12,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SvgPicture.asset(
                                        i,
                                        colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            carouselController: resetController,
                            options: CarouselOptions(
                              initialPage: _chordController.currentIndex.value,
                              onPageChanged: (index, reason) {
                                _chordController.currentIndex.value = index;
                              },
                              height: size.height * 0.4,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                            ),
                          ),
                        ),
                        
                        // Indicator dots
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.black38 : Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List<Widget>.generate(
                                _chordController.changingChords.length,
                                (i) => Obx(
                                  () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: i == _chordController.currentIndex.value ? 10 : 8,
                                    width: i == _chordController.currentIndex.value ? 25 : 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: i == _chordController.currentIndex.value 
                                          ? mainColor 
                                          : Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
