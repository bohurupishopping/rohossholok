// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeaturedMedia _$FeaturedMediaFromJson(Map<String, dynamic> json) =>
    _FeaturedMedia(
      id: (json['id'] as num).toInt(),
      sourceUrl: json['source_url'] as String,
      altText: json['alt_text'] as String?,
      title: json['title'] == null
          ? null
          : RenderedContent.fromJson(json['title'] as Map<String, dynamic>),
      caption: json['caption'] == null
          ? null
          : RenderedContent.fromJson(json['caption'] as Map<String, dynamic>),
      mediaDetails: json['media_details'] == null
          ? null
          : MediaDetails.fromJson(
              json['media_details'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$FeaturedMediaToJson(_FeaturedMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source_url': instance.sourceUrl,
      'alt_text': instance.altText,
      'title': instance.title,
      'caption': instance.caption,
      'media_details': instance.mediaDetails,
    };

_MediaDetails _$MediaDetailsFromJson(Map<String, dynamic> json) =>
    _MediaDetails(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      file: json['file'] as String?,
      sizes: (json['sizes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, MediaSize.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$MediaDetailsToJson(_MediaDetails instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'file': instance.file,
      'sizes': instance.sizes,
    };

_MediaSize _$MediaSizeFromJson(Map<String, dynamic> json) => _MediaSize(
  file: json['file'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  mimeType: json['mime_type'] as String?,
  sourceUrl: json['source_url'] as String?,
);

Map<String, dynamic> _$MediaSizeToJson(_MediaSize instance) =>
    <String, dynamic>{
      'file': instance.file,
      'width': instance.width,
      'height': instance.height,
      'mime_type': instance.mimeType,
      'source_url': instance.sourceUrl,
    };
