// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'rendered_content.dart';

part 'featured_media.freezed.dart';
part 'featured_media.g.dart';

/// Model for WordPress featured media
@freezed
abstract class FeaturedMedia with _$FeaturedMedia {
  const factory FeaturedMedia({
    required int id,
    @JsonKey(name: 'source_url') required String sourceUrl,
    @JsonKey(name: 'alt_text') String? altText,
    RenderedContent? title,
    RenderedContent? caption,
    @JsonKey(name: 'media_details') MediaDetails? mediaDetails,
  }) = _FeaturedMedia;
  
  factory FeaturedMedia.fromJson(Map<String, dynamic> json) =>
      _$FeaturedMediaFromJson(json);
}

/// Model for media details
@freezed
abstract class MediaDetails with _$MediaDetails {
  const factory MediaDetails({
    int? width,
    int? height,
    String? file,
    Map<String, MediaSize>? sizes,
  }) = _MediaDetails;
  
  factory MediaDetails.fromJson(Map<String, dynamic> json) =>
      _$MediaDetailsFromJson(json);
}

/// Model for media sizes
@freezed
abstract class MediaSize with _$MediaSize {
  const factory MediaSize({
    String? file,
    int? width,
    int? height,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'source_url') String? sourceUrl,
  }) = _MediaSize;
  
  factory MediaSize.fromJson(Map<String, dynamic> json) =>
      _$MediaSizeFromJson(json);
}