import 'package:freezed_annotation/freezed_annotation.dart';

part 'rendered_content.freezed.dart';
part 'rendered_content.g.dart';

/// Model for WordPress rendered content (title, content, excerpt)
@freezed
sealed class RenderedContent with _$RenderedContent {
  const factory RenderedContent({
    required String rendered,
  }) = _RenderedContent;
  
  factory RenderedContent.fromJson(Map<String, dynamic> json) =>
      _$RenderedContentFromJson(json);
}