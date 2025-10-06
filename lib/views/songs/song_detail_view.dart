import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/song_controller.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/services/tab_service.dart';

class SongDetailView extends StatelessWidget {
  final SongController _songController = Get.find<SongController>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final TabService _tabService = TabService();

  SongDetailView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeController.isDarkMode;
    
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppThemes.getCardColor(isDarkMode),
        title: Obx(() => Text(
          _songController.selectedSong.value?.title ?? 'Song Details',
          style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
        )),
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppThemes.getTextColor(isDarkMode),
        ),
      ),
      body: Obx(() {
        if (_songController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppThemes.getMainColor(isDarkMode),
            ),
          );
        }
        
        if (_songController.selectedSong.value == null) {
          return Center(
            child: Text(
              'No song selected',
              style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
            ),
          );
        }
        
        final song = _songController.selectedSong.value!;
        
        return Column(
          children: [
            // Song header with info
            _buildSongHeader(song, isDarkMode),
            
            // Tab content area
            Expanded(
              child: _songController.currentTab.value != null
                  ? _buildTabContent(isDarkMode)
                  : Center(
                      child: Text(
                        'No tab content available',
                        style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                      ),
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        if (_songController.selectedSong.value?.hasTab != true) {
          return SizedBox.shrink();
        }
        
        return FloatingActionButton.extended(
          onPressed: () => _handleTabFileAction(context),
          backgroundColor: AppThemes.getMainColor(_themeController.isDarkMode),
          icon: Icon(Icons.play_arrow),
          label: Text(_songController.hasLocalTabFile() ? 'Play Tab File' : 'Download Tab File'),
        );
      }),
    );
  }
  
  Widget _buildSongHeader(dynamic song, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(isDarkMode),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Song thumbnail
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppThemes.getMainColor(isDarkMode).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: song.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Icon(
                            Icons.music_note,
                            size: 48,
                            color: AppThemes.getMainColor(isDarkMode),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.music_note,
                        size: 48,
                        color: AppThemes.getMainColor(isDarkMode),
                      ),
              ),
              SizedBox(width: 16),
              // Song details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: AppThemes.getTextColor(isDarkMode),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: TextStyle(
                        color: AppThemes.getTextColor(isDarkMode).withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Difficulty chip
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(song.difficulty, isDarkMode),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            song.difficulty,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Tab format chip if available
                        if (song.hasTab && song.tabFileFormat != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppThemes.getMainColor(isDarkMode).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  song.tabFileFormat!.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Genre chips
                        ...(song.genres.map((genre) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  color: AppThemes.getTextColor(isDarkMode),
                                  fontSize: 12,
                                ),
                              ),
                            ))).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabContent(bool isDarkMode) {
    final tab = _songController.currentTab.value!;
    
    if (tab.isFile) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _tabService.getTabFormatIcon(tab.format),
              size: 64,
              color: AppThemes.getMainColor(isDarkMode),
            ),
            SizedBox(height: 16),
            Text(
              'Tab file format: ${tab.format.toUpperCase()}',
              style: TextStyle(
                color: AppThemes.getTextColor(isDarkMode),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Use the button below to open or download the tab file',
              style: TextStyle(
                color: AppThemes.getTextColor(isDarkMode).withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Text-based tab
    return _tabService.renderTextTab(tab.content);
  }
  
  Future<void> _handleTabFileAction(BuildContext context) async {
    final isDarkMode = _themeController.isDarkMode;
    
    if (_songController.hasLocalTabFile()) {
      // Open tab file with external app
      final file = _songController.getLocalTabFile();
      if (file != null) {
        try {
          await _tabService.openTabFileWithExternalApp(file);
        } catch (e) {
          // Show error if can't open the file
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to open tab file: $e'),
              backgroundColor: AppThemes.getErrorColor(),
            ),
          );
        }
      }
    } else {
      // Show loading while downloading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppThemes.getCardColor(isDarkMode),
          title: Text(
            'Downloading Tab File',
            style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppThemes.getMainColor(isDarkMode),
              ),
              SizedBox(height: 16),
              Text(
                'Downloading ${_songController.selectedSong.value?.tabFileFormat?.toUpperCase()} file...',
                style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
              ),
            ],
          ),
        ),
      );
      
      try {
        // Download tab file
        final file = await _songController.downloadTabFile();
        
        // Close loading dialog
        Navigator.of(context).pop();
        
        if (file != null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tab file downloaded successfully'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OPEN',
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    await _tabService.openTabFileWithExternalApp(file);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to open tab file: $e'),
                        backgroundColor: AppThemes.getErrorColor(),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      } catch (e) {
        // Close loading dialog and show error
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download tab file: $e'),
            backgroundColor: AppThemes.getErrorColor(),
          ),
        );
      }
    }
  }
  
  Color _getDifficultyColor(String difficulty, bool isDarkMode) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return AppThemes.getMainColor(isDarkMode);
    }
  }
}