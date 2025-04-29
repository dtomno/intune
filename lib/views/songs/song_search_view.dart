import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intune/code/controllers/song_controller.dart';
import 'package:intune/code/controllers/theme/app_themes.dart';
import 'package:intune/code/controllers/theme/theme_controller.dart';
import 'package:intune/code/models/song.dart';
import 'package:intune/views/songs/song_detail_view.dart';

class SongSearchView extends StatefulWidget {
  const SongSearchView({Key? key}) : super(key: key);

  @override
  _SongSearchViewState createState() => _SongSearchViewState();
}

class _SongSearchViewState extends State<SongSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final SongController _songController = Get.put(SongController());
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _songController.clearSearchResults();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _songController.searchSongs(query);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeController.isDarkMode;
    
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppThemes.getCardColor(isDarkMode),
        title: Text(
          'Song Search',
          style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppThemes.getTextColor(isDarkMode),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBox(isDarkMode),
          Expanded(
            child: Obx(() {
              if (_songController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppThemes.getMainColor(isDarkMode),
                  ),
                );
              }

              if (_songController.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppThemes.getErrorColor(),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _songController.error.value,
                        style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _handleSearch,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppThemes.getMainColor(isDarkMode),
                        ),
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (_songController.searchResults.isEmpty) {
                if (_searchController.text.isNotEmpty && _songController.searchQuery.value.isNotEmpty) {
                  // No results for search
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppThemes.getInactiveColor(isDarkMode),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No songs found for "${_songController.searchQuery.value}"',
                          style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  // Show recent searches
                  return _buildRecentSearches(isDarkMode);
                }
              }

              // Show results
              return _buildSearchResults(isDarkMode);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppThemes.getCardColor(isDarkMode),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                  decoration: InputDecoration(
                    hintText: 'Search for songs...',
                    hintStyle: TextStyle(color: AppThemes.getTextColor(isDarkMode).withOpacity(0.6)),
                    prefixIcon: Icon(Icons.search, color: AppThemes.getMainColor(isDarkMode)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: AppThemes.getTextColor(isDarkMode)),
                            onPressed: () {
                              _searchController.clear();
                              _songController.clearSearchResults();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _handleSearch(),
                  textInputAction: TextInputAction.search,
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.getMainColor(isDarkMode),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(bool isDarkMode) {
    return Obx(() {
      if (_songController.recentSearches.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 64,
                color: AppThemes.getInactiveColor(isDarkMode),
              ),
              SizedBox(height: 16),
              Text(
                'Search for songs by title or artist',
                style: TextStyle(
                  color: AppThemes.getTextColor(isDarkMode),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Find songs, view tabs, and play Guitar Pro files',
                  style: TextStyle(
                    color: AppThemes.getTextColor(isDarkMode).withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: AppThemes.getTextColor(isDarkMode),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    _songController.clearRecentSearches();
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: AppThemes.getMainColor(isDarkMode)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _songController.recentSearches.length,
              itemBuilder: (context, index) {
                final query = _songController.recentSearches[index];
                return ListTile(
                  leading: Icon(Icons.history, color: AppThemes.getInactiveColor(isDarkMode)),
                  title: Text(
                    query,
                    style: TextStyle(color: AppThemes.getTextColor(isDarkMode)),
                  ),
                  onTap: () {
                    _searchController.text = query;
                    _handleSearch();
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchResults(bool isDarkMode) {
    return ListView.builder(
      itemCount: _songController.searchResults.length,
      itemBuilder: (context, index) {
        final song = _songController.searchResults[index];
        return _buildSongListTile(song, isDarkMode);
      },
    );
  }

  Widget _buildSongListTile(Song song, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppThemes.getCardColor(isDarkMode),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _songController.selectSong(song.id);
          Get.to(() => SongDetailView());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppThemes.getMainColor(isDarkMode).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: song.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Icon(
                            Icons.music_note,
                            size: 32,
                            color: AppThemes.getMainColor(isDarkMode),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.music_note,
                        size: 32,
                        color: AppThemes.getMainColor(isDarkMode),
                      ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: AppThemes.getTextColor(isDarkMode),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: TextStyle(
                        color: AppThemes.getTextColor(isDarkMode).withOpacity(0.8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(song.difficulty, isDarkMode),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            song.difficulty,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (song.hasTab)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                  size: 10,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  song.tabFileFormat?.toUpperCase() ?? 'TAB',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppThemes.getInactiveColor(isDarkMode),
              ),
            ],
          ),
        ),
      ),
    );
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

Widget songSearch() => SongSearchView();