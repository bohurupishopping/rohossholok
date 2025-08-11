// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'rendered_content.dart';


part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Model for WordPress post
@freezed
sealed class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required String date,
    @JsonKey(name: 'date_gmt') required String dateGmt,
    required RenderedContent title,
    required RenderedContent content,
    required RenderedContent excerpt,
    required int author,
    @JsonKey(name: 'featured_media') required int featuredMedia,
    @JsonKey(name: 'comment_status') required String commentStatus,
    @JsonKey(name: 'ping_status') required String pingStatus,
    required bool sticky,
    required String template,
    required String format,
    required List<int> categories,
    required List<int> tags,
    required String link,
    required String slug,
    required String status,
    required String type,
    @JsonKey(name: '_links') Map<String, dynamic>? links,
    @JsonKey(name: '_embedded') Map<String, dynamic>? embedded,
  }) = _PostModel;
  
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

/// Extension for PostModel
extension PostModelExtension on PostModel {
  /// Get parsed date
  DateTime? get parsedDate {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }
  
  /// Get featured image URL from embedded data
  String? get featuredImageUrl {
    if (embedded != null && embedded!.containsKey('wp:featuredmedia')) {
      final media = embedded!['wp:featuredmedia'] as List?;
      if (media != null && media.isNotEmpty) {
        final mediaItem = media.first as Map<String, dynamic>?;
        return mediaItem?['source_url'] as String?;
      }
    }
    return null;
  }
  
  /// Get category names from embedded data
  List<String> get categoryNames {
    if (embedded != null && embedded!.containsKey('wp:term')) {
      final terms = embedded!['wp:term'] as List?;
      if (terms != null && terms.isNotEmpty) {
        final categories = terms.first as List?;
        if (categories != null) {
          return categories
              .map((cat) => (cat as Map<String, dynamic>)['name'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        }
      }
    }
    return [];
  }
  
  /// Get author name from embedded data
  String? get authorName {
    if (embedded != null && embedded!.containsKey('author')) {
      final authors = embedded!['author'] as List?;
      if (authors != null && authors.isNotEmpty) {
        final author = authors.first as Map<String, dynamic>?;
        return author?['name'] as String?;
      }
    }
    return null;
  }
  
  /// Check if post has featured image
  bool get hasFeaturedImage => featuredMedia > 0 || featuredImageUrl != null;
  
  /// Get plain text excerpt
  String get plainExcerpt {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return excerpt.rendered.replaceAll(exp, '').trim();
  }
  
  /// Get reading time estimate (words per minute: 200)
  int get readingTimeMinutes {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    final plainText = content.rendered.replaceAll(exp, '');
    final wordCount = plainText.split(RegExp(r'\s+')).length;
    return (wordCount / 200).ceil();
  }
  
  /// Get formatted date string
  String getFormattedDate() {
    final parsedDate = this.parsedDate;
    if (parsedDate == null) return 'অজানা তারিখ';
    
    final now = DateTime.now();
    final difference = now.difference(parsedDate);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} মিনিট আগে';
      }
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inDays == 1) {
      return 'গতকাল';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    }
  }
  
  /// Get formatted modified date string
  String getFormattedModifiedDate() {
    // For now, return the same as formatted date
    // In a real app, you'd have a modified date field
    return getFormattedDate();
  }
  
  /// Get estimated reading time
  int getEstimatedReadingTime() {
    return readingTimeMinutes;
  }
  
  /// Get author name
  String getAuthorName() {
    return authorName ?? 'অজানা লেখক';
  }
  
  /// Get category names
  List<String> getCategoryNames() {
    return categoryNames;
  }
}