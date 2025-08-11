import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// Utility functions for the Rohossholok app
class AppUtils {
  /// Format date to Bengali readable format
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'bn_BD');
    return formatter.format(date);
  }
  
  /// Format date to relative time (e.g., "2 days ago")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} দিন আগে';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} মিনিট আগে';
    } else {
      return 'এখনই';
    }
  }
  
  /// Clean HTML content and extract plain text
  static String stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }
  
  /// Extract excerpt from HTML content
  static String extractExcerpt(String htmlContent, {int maxLength = 150}) {
    final plainText = stripHtmlTags(htmlContent);
    if (plainText.length <= maxLength) {
      return plainText;
    }
    return '${plainText.substring(0, maxLength)}...';
  }
  
  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  /// Get image URL with fallback
  static String getImageUrl(String? imageUrl, {String? fallback}) {
    if (imageUrl != null && imageUrl.isNotEmpty && isValidUrl(imageUrl)) {
      return imageUrl;
    }
    return fallback ?? 'https://via.placeholder.com/400x225/1565C0/FFFFFF?text=রহস্যলোক';
  }
  
  /// Convert WordPress date string to DateTime
  static DateTime? parseWordPressDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Format number to Bengali numerals
  static String toBengaliNumber(int number) {
    const englishToBengali = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };
    
    String numberString = number.toString();
    for (String english in englishToBengali.keys) {
      numberString = numberString.replaceAll(english, englishToBengali[english]!);
    }
    
    return numberString;
  }
  
  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Check if device is tablet based on screen width
  static bool isTablet(double screenWidth) {
    return screenWidth >= 768;
  }
  
  /// Get responsive column count for grid
  static int getGridColumnCount(double screenWidth) {
    if (screenWidth >= 1200) return 3;
    if (screenWidth >= 768) return 2;
    return 1;
  }
  
  /// Debounce function for search
  static Timer? _debounceTimer;
  
  static void debounce(
    Function() action, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, action);
  }
  
  /// Launch URL in browser
  static Future<void> launchURL(String url) async {
    // TODO: Implement URL launcher with url_launcher package
    // For now, just a placeholder
    debugPrint('Opening URL: $url');
  }

  /// Validates if the given string is a valid email address
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(email);
  }
}

/// Extension methods for common operations
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Check if string is Bengali
  bool get isBengali {
    final bengaliRegex = RegExp(r'[\u0980-\u09FF]');
    return bengaliRegex.hasMatch(this);
  }
}

extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}