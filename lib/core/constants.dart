/// Core constants for the Rohossholok app
class AppConstants {
  // App Information
  static const String appName = 'রহস্যলোক';
  static const String appVersion = '1.0.0';
  
  // WordPress API Configuration
  static const String baseUrl = 'https://rohossholok.in';
  static const String apiBaseUrl = '$baseUrl/wp-json/wp/v2';
  
  // API Endpoints
  static const String postsEndpoint = '$apiBaseUrl/posts';
  static const String categoriesEndpoint = '$apiBaseUrl/categories';
  static const String pagesEndpoint = '$apiBaseUrl/pages';
  static const String mediaEndpoint = '$apiBaseUrl/media';
  
  // Pagination
  static const int defaultPostsPerPage = 10;
  static const int maxPostsPerPage = 20;
  static const int postsPerPage = 10;
  
  // Cache Configuration
  static const String postsBoxName = 'posts_cache';
  static const String categoriesBoxName = 'categories_cache';
  static const String pagesBoxName = 'pages_cache';
  
  // UI Constants - Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  // UI Constants - Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;
  
  // UI Constants - Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // UI Constants - Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;
  
  // Image Configuration
  static const double postImageAspectRatio = 16 / 9;
  static const String placeholderImageUrl = '$baseUrl/wp-content/themes/default/images/placeholder.jpg';
}

/// Theme color constants based on design specifications
class AppColors {
  // Primary Colors - Mystery/Thriller Theme
  static const int primaryBlue = 0xFF1565C0; // Deep blue
  static const int primaryOrange = 0xFFFF8F00; // Warm orange
  
  // Secondary Colors
  static const int lightGrey = 0xFFF5F5F5; // Background
  static const int darkGrey = 0xFF424242; // Text
  static const int white = 0xFFFFFFFF;
  static const int black = 0xFF000000;
  
  // Status Colors
  static const int success = 0xFF4CAF50;
  static const int error = 0xFFF44336;
  static const int warning = 0xFFFF9800;
  static const int info = 0xFF2196F3;
}

/// Typography constants for Bengali and English text
class AppTypography {
  // Font Families
  static const String englishFont = 'Roboto';
  static const String bengaliFont = 'Noto Sans Bengali';
  
  // Font Sizes
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
}

/// Navigation route constants
class AppRoutes {
  static const String home = '/';
  static const String category = '/category';
  static const String post = '/post';
  static const String about = '/about';
  static const String contact = '/contact';
}

/// Error messages
class AppStrings {
  // Error Messages
  static const String networkError = 'ইন্টারনেট সংযোগ পরীক্ষা করুন';
  static const String serverError = 'সার্ভার সমস্যা হয়েছে';
  static const String noDataFound = 'কোনো তথ্য পাওয়া যায়নি';
  static const String loadingError = 'লোড করতে সমস্যা হয়েছে';
  
  // UI Labels
  static const String home = 'হোম';
  static const String categories = 'বিভাগসমূহ';
  static const String aboutUs = 'আমাদের সম্পর্কে';
  static const String contact = 'যোগাযোগ';
  static const String readMore = 'আরও পড়ুন';
  static const String refresh = 'রিফ্রেশ করুন';
  static const String loadMore = 'আরও লোড করুন';
  
  // Post Related
  static const String latestPosts = 'সর্বশেষ পোস্ট';
  static const String relatedPosts = 'সম্পর্কিত পোস্ট';
  static const String publishedOn = 'প্রকাশিত';
  static const String by = 'লেখক';
}