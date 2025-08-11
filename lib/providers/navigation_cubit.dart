import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_cubit.freezed.dart';
part 'navigation_state.dart';

/// Cubit for managing navigation state
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState.home());
  
  /// Navigate to home
  void navigateToHome() {
    emit(const NavigationState.home());
  }
  
  /// Navigate to category
  void navigateToCategory(int categoryId, String categoryName) {
    emit(NavigationState.category(categoryId, categoryName));
  }
  
  /// Navigate to post detail
  void navigateToPost(int postId) {
    emit(NavigationState.post(postId));
  }
  
  /// Navigate to about page
  void navigateToAbout() {
    emit(const NavigationState.about());
  }
  
  /// Navigate to contact page
  void navigateToContact() {
    emit(const NavigationState.contact());
  }
  
  /// Navigate to search
  void navigateToSearch(String query) {
    emit(NavigationState.search(query));
  }
  
  /// Get current route name
  String getCurrentRoute() {
    return state.when(
      home: () => '/home',
      category: (id, name) => '/category/$id',
      post: (id) => '/post/$id',
      about: () => '/about',
      contact: () => '/contact',
      search: (query) => '/search?q=$query',
    );
  }
  
  /// Check if current route is home
  bool get isHome => state is NavigationHome;
  
  /// Check if current route is category
  bool get isCategory => state is NavigationCategory;
  
  /// Check if current route is post
  bool get isPost => state is NavigationPost;
  
  /// Check if current route is about
  bool get isAbout => state is NavigationAbout;
  
  /// Check if current route is contact
  bool get isContact => state is NavigationContact;
  
  /// Check if current route is search
  bool get isSearch => state is NavigationSearch;
}