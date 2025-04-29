
class Song {
  final String id;
  final String title;
  final String artist;
  final List<String> genres;
  final String difficulty;
  final bool hasTab;
  final String? tabUrl;
  final String? tabFileFormat; // Format like 'gp4', 'gp5', etc.
  final String? tabFilePath; // Local file path after download
  final String? thumbnailUrl;
  
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genres,
    required this.difficulty,
    required this.hasTab,
    this.tabUrl,
    this.tabFileFormat,
    this.tabFilePath,
    this.thumbnailUrl,
  });
  
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      difficulty: json['difficulty'] ?? 'Intermediate',
      hasTab: json['hasTab'] ?? false,
      tabUrl: json['tabUrl'],
      tabFileFormat: json['tabFileFormat'],
      tabFilePath: json['tabFilePath'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genres': genres,
      'difficulty': difficulty,
      'hasTab': hasTab,
      'tabUrl': tabUrl,
      'tabFileFormat': tabFileFormat,
      'tabFilePath': tabFilePath,
      'thumbnailUrl': thumbnailUrl,
    };
  }
  
  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artist}';
  }
}

class Tab {
  final String id;
  final String songId;
  final String format; // 'text', 'gp4', 'gp5', etc.
  final String content; // For text-based tabs, or file path for binary formats
  final bool isFile;
  final String? filePath;
  
  Tab({
    required this.id,
    required this.songId,
    required this.format,
    required this.content,
    required this.isFile,
    this.filePath,
  });
  
  factory Tab.fromJson(Map<String, dynamic> json) {
    return Tab(
      id: json['id'] ?? '',
      songId: json['songId'] ?? '',
      format: json['format'] ?? 'text',
      content: json['content'] ?? '',
      isFile: json['isFile'] ?? false,
      filePath: json['filePath'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'songId': songId,
      'format': format,
      'content': content,
      'isFile': isFile,
      'filePath': filePath,
    };
  }
}