// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: (json['id'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      description: json['description'] as String,
      link: json['link'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      taxonomy: json['taxonomy'] as String,
      parent: (json['parent'] as num).toInt(),
      links: json['_links'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'description': instance.description,
      'link': instance.link,
      'name': instance.name,
      'slug': instance.slug,
      'taxonomy': instance.taxonomy,
      'parent': instance.parent,
      '_links': instance.links,
    };
