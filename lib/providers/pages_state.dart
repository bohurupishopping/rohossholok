part of 'pages_cubit.dart';

/// State for pages management
@freezed
class PagesState with _$PagesState {
  /// Initial state
  const factory PagesState.initial() = PagesInitial;
  
  /// Loading state
  const factory PagesState.loading() = PagesLoading;
  
  /// Loaded state with single page data
  const factory PagesState.loaded(PageModel page) = PagesLoaded;
  
  /// Loaded state with all pages data
  const factory PagesState.allLoaded(List<PageModel> pages) = PagesAllLoaded;
  
  /// Error state
  const factory PagesState.error(String message) = PagesError;
}