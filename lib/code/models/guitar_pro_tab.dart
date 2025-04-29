import 'dart:typed_data';

/// Represents a Guitar Pro tab file with playable content
class GuitarProTab {
  /// The ID of the song this tab is for
  final int songId;
  
  /// The version of Guitar Pro this tab is compatible with
  final String version;
  
  /// The binary data of the Guitar Pro tab file
  final Uint8List? fileData;
  
  /// URL where the tab can be downloaded (if available)
  final String? downloadUrl;
  
  GuitarProTab({
    required this.songId,
    required this.version,
    this.fileData,
    this.downloadUrl,
  });
  
  /// Whether the tab has binary data available for playback
  bool get isPlayable => fileData != null;
  
  /// Whether the tab is available for download
  bool get isDownloadable => downloadUrl != null && downloadUrl!.isNotEmpty;
}