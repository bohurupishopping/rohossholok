import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/post_model.dart';
import '../services/wordpress_api_service.dart';
import 'dart:async';

part 'posts_cubit.freezed.dart';
part 'posts_state.dart';

/// Cubit for managing posts state
class PostsCubit extends Cubit<PostsState> {
  final WordPressApiService _apiService;
  
  // Request throttling
  Timer? _searchDebounceTimer;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  
  // Cache for preventing duplicate requests
  String? _lastRequestKey;
  
  PostsCubit(this._apiService) : super(const PostsState.initial());
  
  /// Load posts with optional category filter
  Future<void> loadPosts({
    int? categoryId,
    String? search,
    bool refresh = false,
    bool useCache = true,
  }) async {
    // Generate request key for deduplication
    final requestKey = 'load_${categoryId ?? 'all'}_${search ?? 'none'}_$refresh';
    
    // Prevent duplicate requests
    if (_lastRequestKey == requestKey && !refresh) {
      return;
    }
    
    // Prevent multiple refresh operations
    if (refresh && _isRefreshing) {
      return;
    }
    
    if (refresh) {
      _isRefreshing = true;
      // Clear cache on refresh
      if (useCache) {
        await _apiService.clearCache(type: 'posts');
      }
      emit(const PostsState.loading());
    } else {
      // Show loading only if no posts are loaded
      state.maybeWhen(
        initial: () => emit(const PostsState.loading()),
        orElse: () {},
      );
    }
    
    _lastRequestKey = requestKey;
    
    try {
      final posts = await _apiService.getPosts(
        page: 1,
        categoryId: categoryId,
        search: search,
        perPage: 10, // Consistent page size for initial load
        useCache: useCache,
      );
      
      emit(PostsState.loaded(
        posts: posts,
        hasReachedMax: posts.length < 10, // Updated to match perPage
        currentPage: 1,
        categoryId: categoryId,
        searchQuery: search,
      ));
    } catch (e) {
      emit(PostsState.error(e.toString()));
    } finally {
      _isRefreshing = false;
      _lastRequestKey = null;
    }
  }
  
  /// Load more posts for pagination
  Future<void> loadMorePosts() async {
    // Prevent multiple simultaneous load more requests
    if (_isLoadingMore) return;
    
    await state.maybeWhen(
      loaded: (posts, hasReachedMax, currentPage, categoryId, searchQuery) async {
        if (hasReachedMax || _isLoadingMore) return;
        
        _isLoadingMore = true;
        
        try {
          final newPosts = await _apiService.getPosts(
            page: currentPage + 1,
            categoryId: categoryId,
            search: searchQuery,
            perPage: 10, // Larger page size for pagination
            useCache: true,
          );
          
          final allPosts = [...posts, ...newPosts];
          
          emit(PostsState.loaded(
            posts: allPosts,
            hasReachedMax: newPosts.length < 10,
            currentPage: currentPage + 1,
            categoryId: categoryId,
            searchQuery: searchQuery,
          ));
        } catch (e) {
          // Keep current state but could show a snackbar for error
        } finally {
          _isLoadingMore = false;
        }
      },
      orElse: () async {},
    );
  }
  
  /// Refresh posts
  Future<void> refreshPosts() async {
    await state.maybeWhen(
      loaded: (posts, hasReachedMax, currentPage, categoryId, searchQuery) async {
        await loadPosts(
          categoryId: categoryId,
          search: searchQuery,
          refresh: true,
        );
      },
      orElse: () async {
        await loadPosts(refresh: true);
      },
    );
  }
  
  /// Search posts with debouncing
  Future<void> searchPosts(String query) async {
    // Cancel previous search timer
    _searchDebounceTimer?.cancel();
    
    // Debounce search requests
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        await loadPosts(refresh: true);
        return;
      }
      
      await loadPosts(
        search: query.trim(),
        refresh: true,
      );
    });
  }
  
  /// Immediate search without debouncing (for search button press)
  Future<void> searchPostsImmediate(String query) async {
    _searchDebounceTimer?.cancel();
    
    if (query.trim().isEmpty) {
      await loadPosts(refresh: true);
      return;
    }
    
    await loadPosts(
      search: query.trim(),
      refresh: true,
    );
  }
  
  /// Filter posts by category
  Future<void> filterByCategory(int? categoryId) async {
    await loadPosts(
      categoryId: categoryId,
      refresh: true,
    );
  }
  
  /// Clear search and filters
  Future<void> clearFilters() async {
    _searchDebounceTimer?.cancel();
    await loadPosts(refresh: true);
  }
  
  /// Lazy load posts only when needed
  Future<void> loadPostsLazy({
    int? categoryId,
    String? search,
  }) async {
    // Only load if no posts are currently loaded or if filters changed
    state.maybeWhen(
      initial: () => loadPosts(
        categoryId: categoryId,
        search: search,
        useCache: true,
      ),
      loaded: (posts, hasReachedMax, currentPage, currentCategoryId, currentSearchQuery) {
        // Only reload if filters actually changed
        if (categoryId != currentCategoryId || search != currentSearchQuery) {
          loadPosts(
            categoryId: categoryId,
            search: search,
            refresh: true,
          );
        }
      },
      orElse: () => loadPosts(
        categoryId: categoryId,
        search: search,
        useCache: true,
      ),
    );
  }
  
  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
