import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/post_detail_screen.dart';
import '../screens/search_screen.dart';
import '../screens/about_screen.dart';
import '../screens/contact_screen.dart';
import '../core/constants.dart';

/// GoRouter configuration for the Rohossholok app
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();
  
  /// Router configuration
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false, // Disabled for production
    routes: [
      // Shell route to maintain navigation stack
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // Category routes as sub-routes of home
              GoRoute(
                path: 'category/:categoryId',
                name: 'category',
                builder: (context, state) {
                  final categoryId = int.tryParse(state.pathParameters['categoryId'] ?? '') ?? 0;
                  final categoryName = state.uri.queryParameters['name'] ?? '';
                  return CategoryScreen(
                    categoryId: categoryId,
                    categoryName: categoryName,
                  );
                },
              ),
              
              // All categories route
              GoRoute(
                path: 'categories',
                name: 'categories',
                builder: (context, state) => const AllCategoriesScreen(),
              ),
              
              // Post detail route
              GoRoute(
                path: 'post/:postId',
                name: 'post',
                builder: (context, state) {
                  final postId = int.tryParse(state.pathParameters['postId'] ?? '') ?? 0;
                  return PostDetailScreen(postId: postId);
                },
              ),
              
              // Search route
              GoRoute(
                path: 'search',
                name: 'search',
                builder: (context, state) {
                  final query = state.uri.queryParameters['q'] ?? '';
                  return SearchScreen(initialQuery: query);
                },
              ),
              
              // About route
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
              
              // Contact route
              GoRoute(
                path: 'contact',
                name: 'contact',
                builder: (context, state) => const ContactScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('পৃষ্ঠা পাওয়া যায়নি'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'দুঃখিত, এই পৃষ্ঠাটি পাওয়া যায়নি',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('হোমে ফিরে যান'),
            ),
          ],
        ),
      ),
    ),
    
    // Redirect logic
    redirect: (context, state) {
      // Add any redirect logic here if needed
      return null;
    },
  );
  
  /// Get the router instance
  static GoRouter get router => _router;
}

/// Navigation helper methods
class AppNavigation {
  // Private constructor to prevent instantiation
  AppNavigation._();
  
  /// Navigate to home
  static void goHome(BuildContext context) {
    context.go(AppRoutes.home);
  }
  
  /// Navigate to category
  static void goToCategory(BuildContext context, int categoryId, String categoryName) {
    context.push('/category/$categoryId?name=${Uri.encodeComponent(categoryName)}');
  }
  
  /// Navigate to all categories
  static void goToAllCategories(BuildContext context) {
    context.push('/categories');
  }
  
  /// Navigate to post detail
  static void goToPost(BuildContext context, int postId) {
    context.push('/post/$postId');
  }
  
  /// Navigate to search
  static void goToSearch(BuildContext context, {String? query}) {
    if (query != null && query.isNotEmpty) {
      context.push('/search?q=${Uri.encodeComponent(query)}');
    } else {
      context.push('/search');
    }
  }
  
  /// Navigate to about
  static void goToAbout(BuildContext context) {
    context.push('/about');
  }
  
  /// Navigate to contact
  static void goToContact(BuildContext context) {
    context.push('/contact');
  }
  
  /// Push a route (for modal or overlay navigation)
  static void pushCategory(BuildContext context, int categoryId, String categoryName) {
    context.push('/category/$categoryId?name=${Uri.encodeComponent(categoryName)}');
  }
  
  /// Push post detail
  static void pushPost(BuildContext context, int postId) {
    context.push('/post/$postId');
  }
  
  /// Push search
  static void pushSearch(BuildContext context, {String? query}) {
    if (query != null && query.isNotEmpty) {
      context.push('/search?q=${Uri.encodeComponent(query)}');
    } else {
      context.push('/search');
    }
  }
  
  /// Go back
  static void goBack(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
    } else {
      // If we can't pop, it means we are at the root of the navigation stack.
      // In this case, navigate to the home screen to prevent popping the last page.
      context.go(AppRoutes.home);
    }
  }
  
  /// Replace current route
  static void replaceWithHome(BuildContext context) {
    context.pushReplacement(AppRoutes.home);
  }
  
  /// Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    final RouteMatch lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : GoRouter.of(context).routerDelegate.currentConfiguration;
    return matchList.last.route.name;
  }
  
  /// Check if current route is home
  static bool isCurrentRouteHome(BuildContext context) {
    return getCurrentRouteName(context) == 'home';
  }
  
  /// Check if current route is category
  static bool isCurrentRouteCategory(BuildContext context) {
    return getCurrentRouteName(context) == 'category';
  }
  
  /// Check if current route is post
  static bool isCurrentRoutePost(BuildContext context) {
    return getCurrentRouteName(context) == 'post';
  }
  
  /// Check if current route is search
  static bool isCurrentRouteSearch(BuildContext context) {
    return getCurrentRouteName(context) == 'search';
  }
  
  /// Check if current route is about
  static bool isCurrentRouteAbout(BuildContext context) {
    return getCurrentRouteName(context) == 'about';
  }
  
  /// Check if current route is contact
  static bool isCurrentRouteContact(BuildContext context) {
    return getCurrentRouteName(context) == 'contact';
  }
}

/// Route information class for navigation state
class RouteInfo {
  final String name;
  final String path;
  final Map<String, String> parameters;
  final Map<String, String> queryParameters;
  
  const RouteInfo({
    required this.name,
    required this.path,
    this.parameters = const {},
    this.queryParameters = const {},
  });
  
  /// Create RouteInfo from GoRouterState
  factory RouteInfo.fromState(GoRouterState state) {
    return RouteInfo(
      name: state.name ?? '',
      path: state.path ?? '',
      parameters: state.pathParameters,
      queryParameters: state.uri.queryParameters,
    );
  }
  
  @override
  String toString() {
    return 'RouteInfo(name: $name, path: $path, parameters: $parameters, queryParameters: $queryParameters)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteInfo &&
        other.name == name &&
        other.path == path;
  }
  
  @override
  int get hashCode {
    return name.hashCode ^ path.hashCode;
  }
}

/// Navigation observer for debugging and analytics
class AppNavigationObserver extends NavigatorObserver {
  
  
  
}
