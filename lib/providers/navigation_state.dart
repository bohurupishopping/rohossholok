part of 'navigation_cubit.dart';

/// State for navigation management
@freezed
class NavigationState with _$NavigationState {
  /// Home state
  const factory NavigationState.home() = NavigationHome;
  
  /// Category state
  const factory NavigationState.category(int categoryId, String categoryName) = NavigationCategory;
  
  /// Post detail state
  const factory NavigationState.post(int postId) = NavigationPost;
  
  /// About page state
  const factory NavigationState.about() = NavigationAbout;
  
  /// Contact page state
  const factory NavigationState.contact() = NavigationContact;
  
  /// Search state
  const factory NavigationState.search(String query) = NavigationSearch;
}