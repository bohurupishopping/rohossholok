// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageModel _$PageModelFromJson(Map<String, dynamic> json) => _PageModel(
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
  template: json['template'] as String,
  parent: (json['parent'] as num).toInt(),
  menuOrder: (json['menu_order'] as num).toInt(),
  link: json['link'] as String,
  slug: json['slug'] as String,
  status: json['status'] as String,
  type: json['type'] as String,
  links: json['_links'] as Map<String, dynamic>?,
  embedded: json['_embedded'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PageModelToJson(_PageModel instance) =>
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
      'template': instance.template,
      'parent': instance.parent,
      'menu_order': instance.menuOrder,
      'link': instance.link,
      'slug': instance.slug,
      'status': instance.status,
      'type': instance.type,
      '_links': instance.links,
      '_embedded': instance.embedded,
    };
