import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intune/code/models/song.dart';

class SongRepository {
  final String _baseUrl = 'https://api.example.com/v1'; // Replace with actual API
  final http.Client _client = http.Client();
  
  // In-memory cache
  final Map<String, Song> _songCache = {};
  
  // Search for songs
  Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/songs/search?q=${Uri.encodeComponent(query)}'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Song> songs = jsonData.map((item) => Song.fromJson(item)).toList();
        
        // Update cache
        for (var song in songs) {
          _songCache[song.id] = song;
        }
        
        // Save to recent searches
        _saveToRecentSearches(query);
        
        return songs;
      } else {
        throw Exception('Failed to search songs: ${response.statusCode}');
      }
    } catch (e) {
      // Return mocked data during development or if API is unavailable
      return _getMockedSongs(query);
    }
  }
  
  // Get song details by ID
  Future<Song> getSongById(String id) async {
    // Check cache first
    if (_songCache.containsKey(id)) {
      return _songCache[id]!;
    }
    
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/songs/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final Song song = Song.fromJson(json.decode(response.body));
        _songCache[id] = song;
        return song;
      } else {
        throw Exception('Failed to load song details: ${response.statusCode}');
      }
    } catch (e) {
      // Return mocked data if API is unavailable
      return _getMockedSong(id);
    }
  }
  
  // Download tab file
  Future<File> downloadTabFile(Song song) async {
    if (song.tabUrl == null || song.tabFileFormat == null) {
      throw Exception('Tab file information is missing');
    }
    
    try {
      final response = await _client.get(Uri.parse(song.tabUrl!));
      
      if (response.statusCode == 200) {
        // Save file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/tabs/${song.id}.${song.tabFileFormat}';
        
        // Create directory if it doesn't exist
        await Directory('${directory.path}/tabs').create(recursive: true);
        
        // Write to file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        // Update song in cache with local file path
        final updatedSong = Song(
          id: song.id,
          title: song.title,
          artist: song.artist,
          genres: song.genres,
          difficulty: song.difficulty,
          hasTab: song.hasTab,
          tabUrl: song.tabUrl,
          tabFileFormat: song.tabFileFormat,
          tabFilePath: filePath,
          thumbnailUrl: song.thumbnailUrl,
        );
        
        _songCache[song.id] = updatedSong;
        
        return file;
      } else {
        throw Exception('Failed to download tab file: ${response.statusCode}');
      }
    } catch (e) {
      // For demo, create a mock file
      return _createMockTabFile(song);
    }
  }
  
  // Get tab content for a song
  Future<Tab> getTabForSong(String songId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/songs/$songId/tab'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return Tab.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load tab: ${response.statusCode}');
      }
    } catch (e) {
      // Return mocked data during development
      return _getMockedTab(songId);
    }
  }
  
  // Save to recent searches
  Future<void> _saveToRecentSearches(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> recentSearches = prefs.getStringList('recentSearches') ?? [];
      
      // Add to beginning of list if not already present, otherwise move to top
      if (recentSearches.contains(query)) {
        recentSearches.remove(query);
      }
      recentSearches.insert(0, query);
      
      // Keep only last 10 searches
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
      
      await prefs.setStringList('recentSearches', recentSearches);
    } catch (e) {
      print('Failed to save recent search: $e');
    }
  }
  
  // Get recent searches
  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('recentSearches') ?? [];
    } catch (e) {
      print('Failed to get recent searches: $e');
      return [];
    }
  }
  
  // Clear recent searches
  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recentSearches');
    } catch (e) {
      print('Failed to clear recent searches: $e');
    }
  }
  
  // Mock methods for development
  List<Song> _getMockedSongs(String query) {
    final lowercaseQuery = query.toLowerCase();
    return [
      Song(
        id: '1',
        title: 'Smoke on the Water',
        artist: 'Deep Purple',
        genres: ['Rock', 'Hard Rock'],
        difficulty: 'Beginner',
        hasTab: true,
        tabUrl: 'https://example.com/tabs/smoke-on-the-water.gp4',
        tabFileFormat: 'gp4',
        thumbnailUrl: 'https://example.com/images/smoke-on-the-water.jpg',
      ),
      Song(
        id: '2',
        title: 'Sweet Child O\' Mine',
        artist: 'Guns N\' Roses',
        genres: ['Rock', 'Hard Rock'],
        difficulty: 'Intermediate',
        hasTab: true,
        tabUrl: 'https://example.com/tabs/sweet-child.gp5',
        tabFileFormat: 'gp5',
        thumbnailUrl: 'https://example.com/images/sweet-child.jpg',
      ),
      Song(
        id: '3',
        title: 'Nothing Else Matters',
        artist: 'Metallica',
        genres: ['Metal', 'Heavy Metal'],
        difficulty: 'Intermediate',
        hasTab: true,
        tabUrl: 'https://example.com/tabs/nothing-else-matters.gp4',
        tabFileFormat: 'gp4',
        thumbnailUrl: 'https://example.com/images/nothing-else-matters.jpg',
      ),
      Song(
        id: '4',
        title: 'Stairway to Heaven',
        artist: 'Led Zeppelin',
        genres: ['Rock', 'Classic Rock'],
        difficulty: 'Advanced',
        hasTab: true,
        tabUrl: 'https://example.com/tabs/stairway-to-heaven.gp5',
        tabFileFormat: 'gp5',
        thumbnailUrl: 'https://example.com/images/stairway-to-heaven.jpg',
      ),
      Song(
        id: '5',
        title: 'Wonderwall',
        artist: 'Oasis',
        genres: ['Rock', 'Pop Rock'],
        difficulty: 'Beginner',
        hasTab: true,
        tabUrl: 'https://example.com/tabs/wonderwall.gp4',
        tabFileFormat: 'gp4',
        thumbnailUrl: 'https://example.com/images/wonderwall.jpg',
      ),
    ].where((song) {
      return song.title.toLowerCase().contains(lowercaseQuery) ||
          song.artist.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  
  Song _getMockedSong(String id) {
    return Song(
      id: id,
      title: 'Mocked Song',
      artist: 'Mocked Artist',
      genres: ['Rock'],
      difficulty: 'Intermediate',
      hasTab: true,
      tabUrl: 'https://example.com/tabs/mocked-song.gp4',
      tabFileFormat: 'gp4',
      thumbnailUrl: 'https://example.com/images/mocked-song.jpg',
    );
  }
  
  Tab _getMockedTab(String songId) {
    return Tab(
      id: 'tab_$songId',
      songId: songId,
      format: 'text',
      content: '''
E|-------------------0---------------------0-----------0-----------0---------------|
B|-------------1-----------------------1-------------1-----------1-----------------|
G|-----0-2-----------------0-2---------------------------2-----------------------2-|
D|-3--------------3---3--------------3-----------3-----------------------3---------|
A|-------------------------------------------------------------------------------|
E|-------------------------------------------------------------------------------|
      ''',
      isFile: false,
    );
  }
  
  Future<File> _createMockTabFile(Song song) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/tabs/${song.id}.${song.tabFileFormat ?? 'gp4'}';
    
    // Create directory if it doesn't exist
    await Directory('${directory.path}/tabs').create(recursive: true);
    
    // Write mock data to file
    final file = File(filePath);
    await file.writeAsString('Mock tab file content for ${song.title} by ${song.artist}');
    
    return file;
  }
}