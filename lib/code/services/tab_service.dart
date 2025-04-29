import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intune/code/models/song.dart';

class TabService {
  final Dio _dio = Dio();
  
  /// Download tab file from URL
  Future<File> downloadTabFile(Song song) async {
    if (song.tabUrl == null || song.tabFileFormat == null) {
      throw Exception('Tab file information is missing');
    }
    
    try {
      // Create tabs directory if it doesn't exist
      final appDir = await getApplicationDocumentsDirectory();
      final tabsDir = Directory('${appDir.path}/tabs');
      if (!tabsDir.existsSync()) {
        tabsDir.createSync(recursive: true);
      }
      
      // Define the file path
      final filePath = '${tabsDir.path}/${song.id}.${song.tabFileFormat}';
      final file = File(filePath);
      
      // Download the file
      final response = await _dio.download(
        song.tabUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          // You could expose this progress via a callback or stream
          if (total != -1) {
            print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      
      return file;
    } catch (e) {
      throw Exception('Failed to download tab file: $e');
    }
  }
  
  /// Open tab file with an external app
  Future<bool> openTabFileWithExternalApp(File file) async {
    try {
      final uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri);
      } else {
        throw Exception('Could not launch file: ${file.path}');
      }
    } catch (e) {
      throw Exception('Error opening tab file: $e');
    }
  }
  
  /// Check if a tab file exists locally
  bool tabFileExists(Song song) {
    if (song.tabFilePath == null) return false;
    
    final file = File(song.tabFilePath!);
    return file.existsSync();
  }
  
  /// Render text tab in a widget (for ASCII tablature)
  Widget renderTextTab(String tabContent) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            tabContent,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Get file size in readable format
  String getFileSizeString(int bytes) {
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
  
  /// Get suitable tab file format icon
  IconData getTabFormatIcon(String format) {
    switch (format.toLowerCase()) {
      case 'gp3':
      case 'gp4':
      case 'gp5':
      case 'gpx':
        return Icons.music_note;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }
}