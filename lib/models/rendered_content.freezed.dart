// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rendered_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenderedContent {

 String get rendered;
/// Create a copy of RenderedContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<RenderedContent> get copyWith => _$RenderedContentCopyWithImpl<RenderedContent>(this as RenderedContent, _$identity);

  /// Serializes this RenderedContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedContent&&(identical(other.rendered, rendered) || other.rendered == rendered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rendered);

@override
String toString() {
  return 'RenderedContent(rendered: $rendered)';
}


}

/// @nodoc
abstract mixin class $RenderedContentCopyWith<$Res>  {
  factory $RenderedContentCopyWith(RenderedContent value, $Res Function(RenderedContent) _then) = _$RenderedContentCopyWithImpl;
@useResult
$Res call({
 String rendered
});




}
/// @nodoc
class _$RenderedContentCopyWithImpl<$Res>
    implements $RenderedContentCopyWith<$Res> {
  _$RenderedContentCopyWithImpl(this._self, this._then);

  final RenderedContent _self;
  final $Res Function(RenderedContent) _then;

/// Create a copy of RenderedContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rendered = null,}) {
  return _then(_self.copyWith(
rendered: null == rendered ? _self.rendered : rendered // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderedContent].
extension RenderedContentPatterns on RenderedContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderedContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderedContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderedContent value)  $default,){
final _that = this;
switch (_that) {
case _RenderedContent():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderedContent value)?  $default,){
final _that = this;
switch (_that) {
case _RenderedContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rendered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedContent() when $default != null:
return $default(_that.rendered);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rendered)  $default,) {final _that = this;
switch (_that) {
case _RenderedContent():
return $default(_that.rendered);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rendered)?  $default,) {final _that = this;
switch (_that) {
case _RenderedContent() when $default != null:
return $default(_that.rendered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedContent implements RenderedContent {
  const _RenderedContent({required this.rendered});
  factory _RenderedContent.fromJson(Map<String, dynamic> json) => _$RenderedContentFromJson(json);

@override final  String rendered;

/// Create a copy of RenderedContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderedContentCopyWith<_RenderedContent> get copyWith => __$RenderedContentCopyWithImpl<_RenderedContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderedContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedContent&&(identical(other.rendered, rendered) || other.rendered == rendered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rendered);

@override
String toString() {
  return 'RenderedContent(rendered: $rendered)';
}


}

/// @nodoc
abstract mixin class _$RenderedContentCopyWith<$Res> implements $RenderedContentCopyWith<$Res> {
  factory _$RenderedContentCopyWith(_RenderedContent value, $Res Function(_RenderedContent) _then) = __$RenderedContentCopyWithImpl;
@override @useResult
$Res call({
 String rendered
});




}
/// @nodoc
class __$RenderedContentCopyWithImpl<$Res>
    implements _$RenderedContentCopyWith<$Res> {
  __$RenderedContentCopyWithImpl(this._self, this._then);

  final _RenderedContent _self;
  final $Res Function(_RenderedContent) _then;

/// Create a copy of RenderedContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rendered = null,}) {
  return _then(_RenderedContent(
rendered: null == rendered ? _self.rendered : rendered // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
