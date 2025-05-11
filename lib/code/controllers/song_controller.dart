import 'dart:io';
import 'package:get/get.dart';
import 'package:intune/code/models/song.dart';
import 'package:intune/code/repositories/song_repository.dart';

class SongController extends GetxController {
  final SongRepository _repository = SongRepository();
  
  // Observables
  RxList<Song> searchResults = <Song>[].obs;
  RxList<String> recentSearches = <String>[].obs;
  Rx<Song?> selectedSong = Rx<Song?>(null);
  Rx<Tab?> currentTab = Rx<Tab?>(null);
  RxBool isLoading = false.obs;
  RxBool isDownloading = false.obs;
  RxString error = ''.obs;
  RxString searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }
  
  // Load recent searches
  Future<void> _loadRecentSearches() async {
    try {
      final searches = await _repository.getRecentSearches();
      recentSearches.value = searches;
    } catch (e) {
      // print('Failed to load recent searches: $e');
    }
  }
  
  // Clear recent searches
  Future<void> clearRecentSearches() async {
    try {
      await _repository.clearRecentSearches();
      recentSearches.clear();
    } catch (e) {
      error.value = 'Failed to clear recent searches: $e';
    }
  }
  
  // Search for songs
  Future<void> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      return;
    }
    
    searchQuery.value = query;
    isLoading.value = true;
    error.value = '';
    
    try {
      final results = await _repository.searchSongs(query);
      searchResults.value = results;
      
      // Refresh recent searches
      _loadRecentSearches();
    } catch (e) {
      error.value = 'Failed to search songs: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Select a song
  Future<void> selectSong(String songId) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final song = await _repository.getSongById(songId);
      selectedSong.value = song;
      
      // Load tab if available
      if (song.hasTab) {
        await loadTabForSong(songId);
      }
    } catch (e) {
      error.value = 'Failed to load song details: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load tab for a song
  Future<void> loadTabForSong(String songId) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final tab = await _repository.getTabForSong(songId);
      currentTab.value = tab;
    } catch (e) {
      error.value = 'Failed to load tab: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Download tab file
  Future<File?> downloadTabFile() async {
    if (selectedSong.value == null || !selectedSong.value!.hasTab) {
      error.value = 'No song selected or song has no tab file';
      return null;
    }
    
    isDownloading.value = true;
    error.value = '';
    
    try {
      final file = await _repository.downloadTabFile(selectedSong.value!);
      return file;
    } catch (e) {
      error.value = 'Failed to download tab file: $e';
      return null;
    } finally {
      isDownloading.value = false;
    }
  }
  
  // Check if tab file exists locally
  bool hasLocalTabFile() {
    if (selectedSong.value?.tabFilePath == null) {
      return false;
    }
    
    final file = File(selectedSong.value!.tabFilePath!);
    return file.existsSync();
  }
  
  // Get local tab file
  File? getLocalTabFile() {
    if (selectedSong.value?.tabFilePath == null) {
      return null;
    }
    
    final file = File(selectedSong.value!.tabFilePath!);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }
  
  // Clear search results
  void clearSearchResults() {
    searchResults.clear();
    searchQuery.value = '';
  }
  
  // Clear selected song
  void clearSelectedSong() {
    selectedSong.value = null;
    currentTab.value = null;
  }
}