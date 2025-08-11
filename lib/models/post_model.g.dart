// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  dateGmt: json['date_gmt'] as String,
  title: RenderedContent.fromJson(json['title'] as Map<String, dynamic>),
  content: RenderedContent.fromJson(json['content'] as Map<String, dynamic>),
  excerpt: RenderedContent.fromJson(json['excerpt'] as Map<String, dynamic>),
  author: (json['author'] as num).toInt(),
  featuredMedia: (json['featured_media'] as num).toInt(),
  commentStatus: json['comment_status'] as String,
  pingStatus: json['ping_status'] as String,
  sticky: json['sticky'] as bool,
  template: json['template'] as String,
  format: json['format'] as String,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  tags: (json['tags'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  link: json['link'] as String,
  slug: json['slug'] as String,
  status: json['status'] as String,
  type: json['type'] as String,
  links: json['_links'] as Map<String, dynamic>?,
  embedded: json['_embedded'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'date_gmt': instance.dateGmt,
      'title': instance.title,
      'content': instance.content,
      'excerpt': instance.excerpt,
      'author': instance.author,
      'featured_media': instance.featuredMedia,
      'comment_status': instance.commentStatus,
      'ping_status': instance.pingStatus,
      'sticky': instance.sticky,
      'template': instance.template,
      'format': instance.format,
      'categories': instance.categories,
      'tags': instance.tags,
      'link': instance.link,
      'slug': instance.slug,
      'status': instance.status,
      'type': instance.type,
      '_links': instance.links,
      '_embedded': instance.embedded,
    };
