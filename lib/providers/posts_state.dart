part of 'posts_cubit.dart';

/// State for posts management
@freezed
class PostsState with _$PostsState {
  /// Initial state
  const factory PostsState.initial() = _Initial;
  
  /// Loading state
  const factory PostsState.loading() = _Loading;
  
  /// Loaded state with posts data
  const factory PostsState.loaded({
    required List<PostModel> posts,
    required bool hasReachedMax,
    required int currentPage,
    int? categoryId,
    String? searchQuery,
  }) = _Loaded;
  
  /// Error state
  const factory PostsState.error(String message) = _Error;
}