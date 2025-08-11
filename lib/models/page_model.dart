// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'rendered_content.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

/// Model for WordPress page
@freezed
sealed class PageModel with _$PageModel {
  const factory PageModel({
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
    required String template,
    required int parent,
    @JsonKey(name: 'menu_order') required int menuOrder,
    required String link,
    required String slug,
    required String status,
    required String type,
    @JsonKey(name: '_links') Map<String, dynamic>? links,
    @JsonKey(name: '_embedded') Map<String, dynamic>? embedded,
  }) = _PageModel;
  
  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);
}

/// Extension for PageModel
extension PageModelExtension on PageModel {
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
  
  /// Check if page has featured image
  bool get hasFeaturedImage => featuredMedia > 0 || featuredImageUrl != null;
  
  /// Check if page is parent page
  bool get isParentPage => parent == 0;
  
  /// Get plain text content
  String get plainContent {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return content.rendered.replaceAll(exp, '').trim();
  }
  
  /// Get plain text excerpt
  String get plainExcerpt {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return excerpt.rendered.replaceAll(exp, '').trim();
  }
}