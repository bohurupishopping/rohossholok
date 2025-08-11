import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/category_model.dart';
import '../services/wordpress_api_service.dart';
import 'dart:async';

part 'categories_cubit.freezed.dart';
part 'categories_state.dart';

/// Cubit for managing categories state
class CategoriesCubit extends Cubit<CategoriesState> {
  final WordPressApiService _apiService;
  
  // Request throttling and caching
  bool _isLoading = false;
  bool _isRefreshing = false;
  DateTime? _lastLoadTime;
  
  // Cache duration for categories (30 minutes)
  static const Duration _cacheDuration = Duration(minutes: 30);
  
  CategoriesCubit(this._apiService) : super(const CategoriesState.initial());
  
  /// Load all categories with smart caching
  Future<void> loadCategories({
    bool refresh = false,
    bool useCache = true,
    bool forceLoad = false,
  }) async {
    // Prevent multiple simultaneous requests
    if (_isLoading && !refresh) return;
    
    // Prevent multiple refresh operations
    if (refresh && _isRefreshing) return;
    
    // Check if we have recent cached data (unless forcing refresh)
    if (!forceLoad && !refresh && _lastLoadTime != null && useCache) {
      final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
      if (timeSinceLastLoad < _cacheDuration) {
        // Data is still fresh, don't reload
        return;
      }
    }
    
    if (refresh) {
      _isRefreshing = true;
      // Clear cache on refresh
      if (useCache) {
        await _apiService.clearCache(type: 'categories');
      }
      emit(const CategoriesState.loading());
    } else if (state is CategoriesInitial) {
      emit(const CategoriesState.loading());
    }
    
    _isLoading = true;
    
    try {
      final categories = await _apiService.getCategories(
        hideEmpty: true,
        perPage: 20, // Reduced from 100 for initial load
        useCache: useCache,
      );
      
      _lastLoadTime = DateTime.now();
      emit(CategoriesState.loaded(categories));
    } catch (e) {
      emit(CategoriesState.error(e.toString()));
    } finally {
      _isLoading = false;
      _isRefreshing = false;
    }
  }
  
  /// Get category by ID
  CategoryModel? getCategoryById(int id) {
    return state.maybeWhen(
      loaded: (categories) {
        try {
          return categories.firstWhere((cat) => cat.id == id);
        } catch (e) {
          return null;
        }
      },
      orElse: () => null,
    );
  }
  
  /// Get category by slug
  CategoryModel? getCategoryBySlug(String slug) {
    return state.maybeWhen(
      loaded: (categories) {
        try {
          return categories.firstWhere((cat) => cat.slug == slug);
        } catch (e) {
          return null;
        }
      },
      orElse: () => null,
    );
  }
  
  /// Get categories with posts only
  List<CategoryModel> getCategoriesWithPosts() {
    return state.maybeWhen(
      loaded: (categories) {
        return categories.where((cat) => cat.hasPosts).toList();
      },
      orElse: () => [],
    );
  }
  
  /// Get parent categories only
  List<CategoryModel> getParentCategories() {
    return state.maybeWhen(
      loaded: (categories) {
        return categories.where((cat) => cat.isParentCategory).toList();
      },
      orElse: () => [],
    );
  }
  
  /// Lazy load categories only when needed
  Future<void> loadCategoriesLazy() async {
    // Only load if no categories are loaded or cache is expired
    state.maybeWhen(
      initial: () => loadCategories(useCache: true),
      loaded: (categories) {
        // Check if cache is expired
        if (_lastLoadTime != null) {
          final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
          if (timeSinceLastLoad >= _cacheDuration) {
            loadCategories(useCache: true);
          }
        }
      },
      error: (_) => loadCategories(useCache: true),
      orElse: () {},
    );
  }
  
  /// Load categories only if not already loaded (for drawer/navigation)
  Future<void> loadCategoriesIfNeeded() async {
    state.maybeWhen(
      initial: () => loadCategories(useCache: true),
      error: (_) => loadCategories(useCache: true),
      orElse: () {}, // Already loaded, do nothing
    );
  }
  
  /// Refresh categories with cache clearing
  Future<void> refreshCategories() async {
    await loadCategories(refresh: true, forceLoad: true);
  }
  
  /// Check if categories are loaded and fresh
  bool get areCategoriesLoaded {
    return state.maybeWhen(
      loaded: (_) => true,
      orElse: () => false,
    );
  }
  
  /// Check if cache is still valid
  bool get isCacheValid {
    if (_lastLoadTime == null) return false;
    final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
    return timeSinceLastLoad < _cacheDuration;
  }
  
  /// Get categories count
  int get categoriesCount {
    return state.maybeWhen(
      loaded: (categories) => categories.length,
      orElse: () => 0,
    );
  }
}