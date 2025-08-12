import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post_model.dart';
import '../models/category_model.dart';
import '../models/page_model.dart';

/// Cache service using SharedPreferences for local storage
class CacheService {
  static const String _postsPrefix = 'posts_';
  static const String _categoriesPrefix = 'categories_';
  static const String _pagesPrefix = 'pages_';
  static const String _relatedPostsPrefix = 'related_posts_';
  
  // Enhanced TTL constants
  static const Duration _relatedPostsTTL = Duration(minutes: 10);
  
  // Cache size management
  static const int _maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const int _cleanupThreshold = 40 * 1024 * 1024; // 40MB
  
  late SharedPreferences _prefs;
  
  /// Initialize cache service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Perform initial cleanup if cache is too large
    await _performCacheCleanupIfNeeded();
  }
  
  /// Cache posts data
  Future<void> cachePosts(String key, List<PostModel> posts) async {
    final jsonList = posts.map((post) => post.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString('$_postsPrefix$key', jsonString);
    await _prefs.setInt('$_postsPrefix${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get cached posts
  Future<List<PostModel>?> getCachedPosts(String key, {Duration? maxAge}) async {
    final jsonString = _prefs.getString('$_postsPrefix$key');
    if (jsonString == null) return null;
    
    if (maxAge != null) {
      final timestamp = _prefs.getInt('$_postsPrefix${key}_timestamp');
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > maxAge) {
        // Remove expired cache
        await _prefs.remove('$_postsPrefix$key');
        await _prefs.remove('$_postsPrefix${key}_timestamp');
        return null;
      }
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('$_postsPrefix$key');
      await _prefs.remove('$_postsPrefix${key}_timestamp');
      return null;
    }
  }
  
  /// Cache categories data
  Future<void> cacheCategories(String key, List<CategoryModel> categories) async {
    final jsonList = categories.map((category) => category.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString('$_categoriesPrefix$key', jsonString);
    await _prefs.setInt('$_categoriesPrefix${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get cached categories
  Future<List<CategoryModel>?> getCachedCategories(String key, {Duration? maxAge}) async {
    final jsonString = _prefs.getString('$_categoriesPrefix$key');
    if (jsonString == null) return null;
    
    if (maxAge != null) {
      final timestamp = _prefs.getInt('$_categoriesPrefix${key}_timestamp');
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > maxAge) {
        // Remove expired cache
        await _prefs.remove('$_categoriesPrefix$key');
        await _prefs.remove('$_categoriesPrefix${key}_timestamp');
        return null;
      }
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('$_categoriesPrefix$key');
      await _prefs.remove('$_categoriesPrefix${key}_timestamp');
      return null;
    }
  }
  
  /// Cache pages data
  Future<void> cachePages(String key, List<PageModel> pages) async {
    final jsonList = pages.map((page) => page.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString('$_pagesPrefix$key', jsonString);
    await _prefs.setInt('$_pagesPrefix${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get cached pages
  Future<List<PageModel>?> getCachedPages(String key, {Duration? maxAge}) async {
    final jsonString = _prefs.getString('$_pagesPrefix$key');
    if (jsonString == null) return null;
    
    if (maxAge != null) {
      final timestamp = _prefs.getInt('$_pagesPrefix${key}_timestamp');
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > maxAge) {
        // Remove expired cache
        await _prefs.remove('$_pagesPrefix$key');
        await _prefs.remove('$_pagesPrefix${key}_timestamp');
        return null;
      }
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((json) => PageModel.fromJson(json)).toList();
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('$_pagesPrefix$key');
      await _prefs.remove('$_pagesPrefix${key}_timestamp');
      return null;
    }
  }
  
  /// Cache single page data
  Future<void> cachePage(String slug, PageModel page) async {
    final jsonString = jsonEncode(page.toJson());
    await _prefs.setString('$_pagesPrefix$slug', jsonString);
    await _prefs.setInt('$_pagesPrefix${slug}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get cached single page
  Future<PageModel?> getCachedPage(String slug, {Duration? maxAge}) async {
    final jsonString = _prefs.getString('$_pagesPrefix$slug');
    if (jsonString == null) return null;
    
    if (maxAge != null) {
      final timestamp = _prefs.getInt('$_pagesPrefix${slug}_timestamp');
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > maxAge) {
        // Remove expired cache
        await _prefs.remove('$_pagesPrefix$slug');
        await _prefs.remove('$_pagesPrefix${slug}_timestamp');
        return null;
      }
    }
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return PageModel.fromJson(decoded);
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('$_pagesPrefix$slug');
      await _prefs.remove('$_pagesPrefix${slug}_timestamp');
      return null;
    }
  }
  
  /// Clear cache by type
  Future<void> clearCache(String type) async {
    final keys = _prefs.getKeys();
    String prefix;
    
    switch (type) {
      case 'posts':
        prefix = _postsPrefix;
        break;
      case 'categories':
        prefix = _categoriesPrefix;
        break;
      case 'pages':
        prefix = _pagesPrefix;
        break;
      default:
        return;
    }
    
    final cacheKeys = keys.where((key) => key.startsWith(prefix));
    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }
  
  /// Clear all cache
  Future<void> clearAllCache() async {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => 
      key.startsWith(_postsPrefix) || 
      key.startsWith(_categoriesPrefix) || 
      key.startsWith(_pagesPrefix)
    );
    
    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }
  
  /// Clear posts cache
  Future<void> clearPostsCache() async {
    await clearCache('posts');
  }
  
  /// Clear categories cache
  Future<void> clearCategoriesCache() async {
    await clearCache('categories');
  }
  
  /// Clear pages cache
  Future<void> clearPagesCache() async {
    await clearCache('pages');
  }
  
  /// Check if cache exists and is valid
  Future<bool> isCacheValid(String type, String key, Duration maxAge) async {
    String prefix;
    switch (type) {
      case 'posts':
        prefix = _postsPrefix;
        break;
      case 'categories':
        prefix = _categoriesPrefix;
        break;
      case 'pages':
        prefix = _pagesPrefix;
        break;
      default:
        return false;
    }
    
    final timestamp = _prefs.getInt('$prefix${key}_timestamp');
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cacheTime) <= maxAge;
  }
  
  /// Get cache size in bytes (approximate)
  int getCacheSize() {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => 
      (key.startsWith(_postsPrefix) || 
       key.startsWith(_categoriesPrefix) || 
       key.startsWith(_pagesPrefix) ||
       key.startsWith(_relatedPostsPrefix)) &&
      !key.endsWith('_timestamp')
    );
    
    int totalSize = 0;
    for (final key in cacheKeys) {
      final value = _prefs.getString(key);
      if (value != null) {
        totalSize += value.length * 2; // Approximate UTF-16 encoding
      }
    }
    
    return totalSize;
  }
  
  /// Cache related posts with specific TTL
  Future<void> cacheRelatedPosts(String key, List<PostModel> posts) async {
    final jsonList = posts.map((post) => post.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString('$_relatedPostsPrefix$key', jsonString);
    await _prefs.setInt('$_relatedPostsPrefix${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
    
    // Check if cleanup is needed after adding new data
    await _performCacheCleanupIfNeeded();
  }
  
  /// Get cached related posts
  Future<List<PostModel>?> getCachedRelatedPosts(String key, {Duration? maxAge}) async {
    maxAge ??= _relatedPostsTTL;
    
    final jsonString = _prefs.getString('$_relatedPostsPrefix$key');
    if (jsonString == null) return null;
    
    final timestamp = _prefs.getInt('$_relatedPostsPrefix${key}_timestamp');
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cacheTime) > maxAge) {
      // Remove expired cache
      await _prefs.remove('$_relatedPostsPrefix$key');
      await _prefs.remove('$_relatedPostsPrefix${key}_timestamp');
      return null;
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('$_relatedPostsPrefix$key');
      await _prefs.remove('$_relatedPostsPrefix${key}_timestamp');
      return null;
    }
  }
  

  
  /// Perform cache cleanup if size exceeds threshold
  Future<void> _performCacheCleanupIfNeeded() async {
    final currentSize = getCacheSize();
    if (currentSize > _cleanupThreshold) {
      await _performCacheCleanup();
    }
  }
  
  /// Perform intelligent cache cleanup
  Future<void> _performCacheCleanup() async {
    final keys = _prefs.getKeys();
    final cacheEntries = <_CacheEntry>[];
    
    // Collect all cache entries with their timestamps
    for (final key in keys) {
      if (_isCacheKey(key) && !key.endsWith('_timestamp')) {
        final timestampKey = '${key}_timestamp';
        final timestamp = _prefs.getInt(timestampKey);
        if (timestamp != null) {
          final size = _prefs.getString(key)?.length ?? 0;
          cacheEntries.add(_CacheEntry(
            key: key,
            timestamp: timestamp,
            size: size,
          ));
        }
      }
    }
    
    // Sort by timestamp (oldest first) and remove oldest entries
    cacheEntries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    int removedSize = 0;
    final targetSize = _maxCacheSize - _cleanupThreshold;
    
    for (final entry in cacheEntries) {
      if (removedSize >= targetSize) break;
      
      await _prefs.remove(entry.key);
      await _prefs.remove('${entry.key}_timestamp');
      removedSize += entry.size * 2; // UTF-16 encoding
    }
  }
  
  /// Check if a key is a cache key
  bool _isCacheKey(String key) {
    return key.startsWith(_postsPrefix) ||
           key.startsWith(_categoriesPrefix) ||
           key.startsWith(_pagesPrefix) ||
           key.startsWith(_relatedPostsPrefix);
  }
  
  /// Invalidate cache by pattern
  Future<void> invalidateCacheByPattern(String pattern) async {
    final keys = _prefs.getKeys();
    final keysToRemove = keys.where((key) => key.contains(pattern));
    
    for (final key in keysToRemove) {
      await _prefs.remove(key);
    }
  }
  
  /// Clear related posts cache
  Future<void> clearRelatedPostsCache() async {
    final keys = _prefs.getKeys();
    final relatedPostsKeys = keys.where((key) => key.startsWith(_relatedPostsPrefix));
    
    for (final key in relatedPostsKeys) {
      await _prefs.remove(key);
    }
  }
  

}

/// Helper class for cache cleanup
class _CacheEntry {
  final String key;
  final int timestamp;
  final int size;
  
  _CacheEntry({
    required this.key,
    required this.timestamp,
    required this.size,
  });
}