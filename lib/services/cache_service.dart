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
  
  late SharedPreferences _prefs;
  
  /// Initialize cache service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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
      key.startsWith(_postsPrefix) || 
      key.startsWith(_categoriesPrefix) || 
      key.startsWith(_pagesPrefix)
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
}