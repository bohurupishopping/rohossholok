import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/post_model.dart';
import '../models/category_model.dart';
import '../models/page_model.dart';
import '../models/featured_media.dart';
import 'cache_service.dart';

/// Service for WordPress REST API interactions
class WordPressApiService {
  final Dio _dio;
  final CacheService _cacheService;
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, DateTime> _lastRequestTimes = {};
  
  // Cache TTL constants
  static const Duration _postsCacheTTL = Duration(minutes: 5);
  static const Duration _categoriesCacheTTL = Duration(minutes: 30);
  static const Duration _pagesCacheTTL = Duration(hours: 1);
  
  // Request debounce delay
  static const Duration _debounceDelay = Duration(milliseconds: 300);
  
  WordPressApiService(this._dio, this._cacheService) {
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => {}, // Removed print statement for production
    ));
  }
  
  /// Get posts with pagination and optional category filter
  Future<List<PostModel>> getPosts({
    int page = 1,
    int perPage = 5, // Reduced from AppConstants.postsPerPage for initial loads
    int? categoryId,
    String? search,
    bool includeEmbedded = true,
    bool useCache = true,
  }) async {
    // Generate cache key
    final cacheKey = 'posts_${page}_${perPage}_${categoryId ?? 'all'}_${search ?? 'none'}';
    
    // Check cache first if enabled
    if (useCache) {
      final cachedPosts = await _cacheService.getCachedRelatedPosts(
        cacheKey,
        maxAge: _postsCacheTTL,
      );
      if (cachedPosts != null) {
        return cachedPosts;
      }
    }
    
    // Implement request debouncing for search
    if (search != null && search.isNotEmpty) {
      await _debounceRequest('search_$search');
    }
    
    // Cancel previous request if exists
    _cancelPreviousRequest(cacheKey);
    final cancelToken = CancelToken();
    _cancelTokens[cacheKey] = cancelToken;
    
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        'status': 'publish',
        'orderby': 'date',
        'order': 'desc',
      };
      
      if (categoryId != null) {
        queryParams['categories'] = categoryId;
      }
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        AppConstants.postsEndpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final posts = data.map((json) => PostModel.fromJson(json)).toList();
        
        // Cache the result if using cache
        if (useCache) {
          await _cacheService.cacheRelatedPosts(cacheKey, posts);
        }
        
        // Clean up cancel token
        _cancelTokens.remove(cacheKey);
        
        return posts;
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get single post by ID
  Future<PostModel> getPost(int id, {bool includeEmbedded = true}) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        '${AppConstants.postsEndpoint}/$id',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get related posts from the same category, excluding the current post
  Future<List<PostModel>> getRelatedPosts({
    required int currentPostId,
    required int categoryId,
    int perPage = 4,
    bool includeEmbedded = true,
    bool useCache = true,
  }) async {
    // Generate cache key
    final cacheKey = 'related_posts_${currentPostId}_${categoryId}_$perPage';
    
    // Check cache first if enabled
    if (useCache) {
      final cachedPosts = await _cacheService.getCachedPosts(
        cacheKey,
        maxAge: _postsCacheTTL,
      );
      if (cachedPosts != null) {
        return cachedPosts;
      }
    }
    
    // Cancel previous request if exists
    _cancelPreviousRequest(cacheKey);
    final cancelToken = CancelToken();
    _cancelTokens[cacheKey] = cancelToken;
    
    try {
      final queryParams = <String, dynamic>{
        'categories': categoryId,
        'exclude': currentPostId, // Exclude current post
        'per_page': perPage,
        'status': 'publish',
        'orderby': 'date',
        'order': 'desc',
      };
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        AppConstants.postsEndpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final posts = data.map((json) => PostModel.fromJson(json)).toList();
        
        // Cache the result if using cache
        if (useCache) {
          await _cacheService.cachePosts(cacheKey, posts);
        }
        
        // Clean up cancel token
        _cancelTokens.remove(cacheKey);
        
        return posts;
      } else {
        throw Exception('Failed to load related posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get all categories
  Future<List<CategoryModel>> getCategories({
    int page = 1,
    int perPage = 20, // Reduced from 100 for initial loads
    bool hideEmpty = true,
    bool useCache = true,
  }) async {
    // Generate cache key
    final cacheKey = 'categories_${page}_${perPage}_$hideEmpty';
    
    // Check cache first if enabled
    if (useCache) {
      final cachedCategories = await _cacheService.getCachedCategories(
        cacheKey,
        maxAge: _categoriesCacheTTL,
      );
      if (cachedCategories != null) {
        return cachedCategories;
      }
    }
    
    // Cancel previous request if exists
    _cancelPreviousRequest(cacheKey);
    final cancelToken = CancelToken();
    _cancelTokens[cacheKey] = cancelToken;
    
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        'orderby': 'name',
        'order': 'asc',
      };
      
      if (hideEmpty) {
        queryParams['hide_empty'] = true;
      }
      
      final response = await _dio.get(
        AppConstants.categoriesEndpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        
        // Cache the result if using cache
        if (useCache) {
          await _cacheService.cacheCategories(cacheKey, categories);
        }
        
        // Clean up cancel token
        _cancelTokens.remove(cacheKey);
        
        return categories;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get single category by ID
  Future<CategoryModel> getCategory(int id) async {
    try {
      final response = await _dio.get('${AppConstants.categoriesEndpoint}/$id');
      
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get pages
  Future<List<PageModel>> getPages({
    int page = 1,
    int perPage = 10, // Reduced from 20 for initial loads
    bool includeEmbedded = true,
    bool useCache = true,
  }) async {
    // Generate cache key
    final cacheKey = 'pages_${page}_${perPage}_$includeEmbedded';
    
    // Check cache first if enabled
    if (useCache) {
      final cachedPages = await _cacheService.getCachedPages(
        cacheKey,
        maxAge: _pagesCacheTTL,
      );
      if (cachedPages != null) {
        return cachedPages;
      }
    }
    
    // Cancel previous request if exists
    _cancelPreviousRequest(cacheKey);
    final cancelToken = CancelToken();
    _cancelTokens[cacheKey] = cancelToken;
    
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        'status': 'publish',
        'orderby': 'menu_order',
        'order': 'asc',
      };
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        AppConstants.pagesEndpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final pages = data.map((json) => PageModel.fromJson(json)).toList();
        
        // Cache the result if using cache
        if (useCache) {
          await _cacheService.cachePages(cacheKey, pages);
        }
        
        // Clean up cancel token
        _cancelTokens.remove(cacheKey);
        
        return pages;
      } else {
        throw Exception('Failed to load pages: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get single page by ID
  Future<PageModel> getPage(int id, {bool includeEmbedded = true}) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        '${AppConstants.pagesEndpoint}/$id',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        return PageModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get page by slug
  Future<PageModel?> getPageBySlug(String slug, {bool includeEmbedded = true}) async {
    try {
      final queryParams = <String, dynamic>{
        'slug': slug,
        'status': 'publish',
      };
      
      if (includeEmbedded) {
        queryParams['_embed'] = true;
      }
      
      final response = await _dio.get(
        AppConstants.pagesEndpoint,
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          return PageModel.fromJson(data.first);
        }
      }
      return null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Get featured media by ID
  Future<FeaturedMedia> getMedia(int id) async {
    try {
      final response = await _dio.get('${AppConstants.mediaEndpoint}/$id');
      
      if (response.statusCode == 200) {
        return FeaturedMedia.fromJson(response.data);
      } else {
        throw Exception('Failed to load media: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Handle Dio errors
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Content not found.');
        } else if (statusCode == 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception('HTTP Error: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
  
  /// Cancel previous request if exists
  void _cancelPreviousRequest(String key) {
    final existingToken = _cancelTokens[key];
    if (existingToken != null && !existingToken.isCancelled) {
      existingToken.cancel('New request initiated');
    }
  }
  
  /// Implement request debouncing
  Future<void> _debounceRequest(String key) async {
    final now = DateTime.now();
    final lastRequestTime = _lastRequestTimes[key];
    
    if (lastRequestTime != null) {
      final timeSinceLastRequest = now.difference(lastRequestTime);
      if (timeSinceLastRequest < _debounceDelay) {
        final remainingDelay = _debounceDelay - timeSinceLastRequest;
        await Future.delayed(remainingDelay);
      }
    }
    
    _lastRequestTimes[key] = DateTime.now();
  }
  
  /// Clear cache for specific type
  Future<void> clearCache({String? type}) async {
    if (type == null) {
      await _cacheService.clearAllCache();
    } else {
      switch (type) {
        case 'posts':
          await _cacheService.clearCache('posts');
          break;
        case 'categories':
          await _cacheService.clearCache('categories');
          break;
        case 'pages':
          await _cacheService.clearCache('pages');
          break;
      }
    }
  }
  
  /// Cancel all ongoing requests
  void cancelAllRequests() {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) {
        token.cancel('Service disposed');
      }
    }
    _cancelTokens.clear();
  }
  
  /// Dispose resources
  void dispose() {
    cancelAllRequests();
    _dio.close();
  }
}