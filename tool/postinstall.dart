// post_install_script.dart
import 'dart:io';

void main() async {
  try {
    // Determine the pub cache location based on platform
    final pubCache =
        Platform.environment['PUB_CACHE'] ??
        (Platform.isWindows
            ? '${Platform.environment['LOCALAPPDATA']}/Pub/Cache'
            : '${Platform.environment['HOME']}/.pub-cache');

    // Path to the pitch_handler.dart file
    final filePath =
        '$pubCache/hosted/pub.dev/pitchupdart-0.0.6/lib/pitch_handler.dart';

    // Check if file exists
    if (!await File(filePath).exists()) {
      print('Error: Cannot find pitch_handler.dart at $filePath');
      return;
    }

    // Read file content
    String content = await File(filePath).readAsString();

    // Replace the minimum pitch value
    final modifiedContent = content.replaceAll(
      'this._minimumPitch = 80.0;',
      'this._minimumPitch = 40.0;',
    );

    // Write updated content back to the file
    await File(filePath).writeAsString(modifiedContent);

    print('Successfully updated minimum pitch to 40.0');
  } catch (e) {
    print('Error: $e');
  }
}