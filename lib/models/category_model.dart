// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Model for WordPress category
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required int count,
    required String description,
    required String link,
    required String name,
    required String slug,
    required String taxonomy,
    required int parent,
    @JsonKey(name: '_links') Map<String, dynamic>? links,
  }) = _CategoryModel;
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

/// Extension for CategoryModel
extension CategoryModelExtension on CategoryModel {
  /// Check if category has posts
  bool get hasPosts => count > 0;
  
  /// Check if category is parent category
  bool get isParentCategory => parent == 0;
  
  /// Get display name with post count
  String get displayNameWithCount => '$name ($count)';
}