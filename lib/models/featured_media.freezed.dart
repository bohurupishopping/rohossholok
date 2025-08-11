// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturedMedia {

 int get id;@JsonKey(name: 'source_url') String get sourceUrl;@JsonKey(name: 'alt_text') String? get altText; RenderedContent? get title; RenderedContent? get caption;@JsonKey(name: 'media_details') MediaDetails? get mediaDetails;
/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturedMediaCopyWith<FeaturedMedia> get copyWith => _$FeaturedMediaCopyWithImpl<FeaturedMedia>(this as FeaturedMedia, _$identity);

  /// Serializes this FeaturedMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturedMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.title, title) || other.title == title)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.mediaDetails, mediaDetails) || other.mediaDetails == mediaDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceUrl,altText,title,caption,mediaDetails);

@override
String toString() {
  return 'FeaturedMedia(id: $id, sourceUrl: $sourceUrl, altText: $altText, title: $title, caption: $caption, mediaDetails: $mediaDetails)';
}


}

/// @nodoc
abstract mixin class $FeaturedMediaCopyWith<$Res>  {
  factory $FeaturedMediaCopyWith(FeaturedMedia value, $Res Function(FeaturedMedia) _then) = _$FeaturedMediaCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'source_url') String sourceUrl,@JsonKey(name: 'alt_text') String? altText, RenderedContent? title, RenderedContent? caption,@JsonKey(name: 'media_details') MediaDetails? mediaDetails
});


$RenderedContentCopyWith<$Res>? get title;$RenderedContentCopyWith<$Res>? get caption;$MediaDetailsCopyWith<$Res>? get mediaDetails;

}
/// @nodoc
class _$FeaturedMediaCopyWithImpl<$Res>
    implements $FeaturedMediaCopyWith<$Res> {
  _$FeaturedMediaCopyWithImpl(this._self, this._then);

  final FeaturedMedia _self;
  final $Res Function(FeaturedMedia) _then;

/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceUrl = null,Object? altText = freezed,Object? title = freezed,Object? caption = freezed,Object? mediaDetails = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RenderedContent?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as RenderedContent?,mediaDetails: freezed == mediaDetails ? _self.mediaDetails : mediaDetails // ignore: cast_nullable_to_non_nullable
as MediaDetails?,
  ));
}
/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $RenderedContentCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res>? get caption {
    if (_self.caption == null) {
    return null;
  }

  return $RenderedContentCopyWith<$Res>(_self.caption!, (value) {
    return _then(_self.copyWith(caption: value));
  });
}/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaDetailsCopyWith<$Res>? get mediaDetails {
    if (_self.mediaDetails == null) {
    return null;
  }

  return $MediaDetailsCopyWith<$Res>(_self.mediaDetails!, (value) {
    return _then(_self.copyWith(mediaDetails: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeaturedMedia].
extension FeaturedMediaPatterns on FeaturedMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturedMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturedMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturedMedia value)  $default,){
final _that = this;
switch (_that) {
case _FeaturedMedia():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturedMedia value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturedMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'alt_text')  String? altText,  RenderedContent? title,  RenderedContent? caption, @JsonKey(name: 'media_details')  MediaDetails? mediaDetails)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturedMedia() when $default != null:
return $default(_that.id,_that.sourceUrl,_that.altText,_that.title,_that.caption,_that.mediaDetails);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'alt_text')  String? altText,  RenderedContent? title,  RenderedContent? caption, @JsonKey(name: 'media_details')  MediaDetails? mediaDetails)  $default,) {final _that = this;
switch (_that) {
case _FeaturedMedia():
return $default(_that.id,_that.sourceUrl,_that.altText,_that.title,_that.caption,_that.mediaDetails);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'alt_text')  String? altText,  RenderedContent? title,  RenderedContent? caption, @JsonKey(name: 'media_details')  MediaDetails? mediaDetails)?  $default,) {final _that = this;
switch (_that) {
case _FeaturedMedia() when $default != null:
return $default(_that.id,_that.sourceUrl,_that.altText,_that.title,_that.caption,_that.mediaDetails);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeaturedMedia implements FeaturedMedia {
  const _FeaturedMedia({required this.id, @JsonKey(name: 'source_url') required this.sourceUrl, @JsonKey(name: 'alt_text') this.altText, this.title, this.caption, @JsonKey(name: 'media_details') this.mediaDetails});
  factory _FeaturedMedia.fromJson(Map<String, dynamic> json) => _$FeaturedMediaFromJson(json);

@override final  int id;
@override@JsonKey(name: 'source_url') final  String sourceUrl;
@override@JsonKey(name: 'alt_text') final  String? altText;
@override final  RenderedContent? title;
@override final  RenderedContent? caption;
@override@JsonKey(name: 'media_details') final  MediaDetails? mediaDetails;

/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturedMediaCopyWith<_FeaturedMedia> get copyWith => __$FeaturedMediaCopyWithImpl<_FeaturedMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeaturedMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturedMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.title, title) || other.title == title)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.mediaDetails, mediaDetails) || other.mediaDetails == mediaDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceUrl,altText,title,caption,mediaDetails);

@override
String toString() {
  return 'FeaturedMedia(id: $id, sourceUrl: $sourceUrl, altText: $altText, title: $title, caption: $caption, mediaDetails: $mediaDetails)';
}


}

/// @nodoc
abstract mixin class _$FeaturedMediaCopyWith<$Res> implements $FeaturedMediaCopyWith<$Res> {
  factory _$FeaturedMediaCopyWith(_FeaturedMedia value, $Res Function(_FeaturedMedia) _then) = __$FeaturedMediaCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'source_url') String sourceUrl,@JsonKey(name: 'alt_text') String? altText, RenderedContent? title, RenderedContent? caption,@JsonKey(name: 'media_details') MediaDetails? mediaDetails
});


@override $RenderedContentCopyWith<$Res>? get title;@override $RenderedContentCopyWith<$Res>? get caption;@override $MediaDetailsCopyWith<$Res>? get mediaDetails;

}
/// @nodoc
class __$FeaturedMediaCopyWithImpl<$Res>
    implements _$FeaturedMediaCopyWith<$Res> {
  __$FeaturedMediaCopyWithImpl(this._self, this._then);

  final _FeaturedMedia _self;
  final $Res Function(_FeaturedMedia) _then;

/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceUrl = null,Object? altText = freezed,Object? title = freezed,Object? caption = freezed,Object? mediaDetails = freezed,}) {
  return _then(_FeaturedMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RenderedContent?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as RenderedContent?,mediaDetails: freezed == mediaDetails ? _self.mediaDetails : mediaDetails // ignore: cast_nullable_to_non_nullable
as MediaDetails?,
  ));
}

/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $RenderedContentCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res>? get caption {
    if (_self.caption == null) {
    return null;
  }

  return $RenderedContentCopyWith<$Res>(_self.caption!, (value) {
    return _then(_self.copyWith(caption: value));
  });
}/// Create a copy of FeaturedMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaDetailsCopyWith<$Res>? get mediaDetails {
    if (_self.mediaDetails == null) {
    return null;
  }

  return $MediaDetailsCopyWith<$Res>(_self.mediaDetails!, (value) {
    return _then(_self.copyWith(mediaDetails: value));
  });
}
}


/// @nodoc
mixin _$MediaDetails {

 int? get width; int? get height; String? get file; Map<String, MediaSize>? get sizes;
/// Create a copy of MediaDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaDetailsCopyWith<MediaDetails> get copyWith => _$MediaDetailsCopyWithImpl<MediaDetails>(this as MediaDetails, _$identity);

  /// Serializes this MediaDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaDetails&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.file, file) || other.file == file)&&const DeepCollectionEquality().equals(other.sizes, sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,file,const DeepCollectionEquality().hash(sizes));

@override
String toString() {
  return 'MediaDetails(width: $width, height: $height, file: $file, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class $MediaDetailsCopyWith<$Res>  {
  factory $MediaDetailsCopyWith(MediaDetails value, $Res Function(MediaDetails) _then) = _$MediaDetailsCopyWithImpl;
@useResult
$Res call({
 int? width, int? height, String? file, Map<String, MediaSize>? sizes
});




}
/// @nodoc
class _$MediaDetailsCopyWithImpl<$Res>
    implements $MediaDetailsCopyWith<$Res> {
  _$MediaDetailsCopyWithImpl(this._self, this._then);

  final MediaDetails _self;
  final $Res Function(MediaDetails) _then;

/// Create a copy of MediaDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = freezed,Object? height = freezed,Object? file = freezed,Object? sizes = freezed,}) {
  return _then(_self.copyWith(
width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,sizes: freezed == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as Map<String, MediaSize>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaDetails].
extension MediaDetailsPatterns on MediaDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaDetails value)  $default,){
final _that = this;
switch (_that) {
case _MediaDetails():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaDetails value)?  $default,){
final _that = this;
switch (_that) {
case _MediaDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? width,  int? height,  String? file,  Map<String, MediaSize>? sizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaDetails() when $default != null:
return $default(_that.width,_that.height,_that.file,_that.sizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? width,  int? height,  String? file,  Map<String, MediaSize>? sizes)  $default,) {final _that = this;
switch (_that) {
case _MediaDetails():
return $default(_that.width,_that.height,_that.file,_that.sizes);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? width,  int? height,  String? file,  Map<String, MediaSize>? sizes)?  $default,) {final _that = this;
switch (_that) {
case _MediaDetails() when $default != null:
return $default(_that.width,_that.height,_that.file,_that.sizes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaDetails implements MediaDetails {
  const _MediaDetails({this.width, this.height, this.file, final  Map<String, MediaSize>? sizes}): _sizes = sizes;
  factory _MediaDetails.fromJson(Map<String, dynamic> json) => _$MediaDetailsFromJson(json);

@override final  int? width;
@override final  int? height;
@override final  String? file;
 final  Map<String, MediaSize>? _sizes;
@override Map<String, MediaSize>? get sizes {
  final value = _sizes;
  if (value == null) return null;
  if (_sizes is EqualUnmodifiableMapView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of MediaDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaDetailsCopyWith<_MediaDetails> get copyWith => __$MediaDetailsCopyWithImpl<_MediaDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaDetails&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.file, file) || other.file == file)&&const DeepCollectionEquality().equals(other._sizes, _sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,file,const DeepCollectionEquality().hash(_sizes));

@override
String toString() {
  return 'MediaDetails(width: $width, height: $height, file: $file, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class _$MediaDetailsCopyWith<$Res> implements $MediaDetailsCopyWith<$Res> {
  factory _$MediaDetailsCopyWith(_MediaDetails value, $Res Function(_MediaDetails) _then) = __$MediaDetailsCopyWithImpl;
@override @useResult
$Res call({
 int? width, int? height, String? file, Map<String, MediaSize>? sizes
});




}
/// @nodoc
class __$MediaDetailsCopyWithImpl<$Res>
    implements _$MediaDetailsCopyWith<$Res> {
  __$MediaDetailsCopyWithImpl(this._self, this._then);

  final _MediaDetails _self;
  final $Res Function(_MediaDetails) _then;

/// Create a copy of MediaDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = freezed,Object? height = freezed,Object? file = freezed,Object? sizes = freezed,}) {
  return _then(_MediaDetails(
width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,sizes: freezed == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as Map<String, MediaSize>?,
  ));
}


}


/// @nodoc
mixin _$MediaSize {

 String? get file; int? get width; int? get height;@JsonKey(name: 'mime_type') String? get mimeType;@JsonKey(name: 'source_url') String? get sourceUrl;
/// Create a copy of MediaSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSizeCopyWith<MediaSize> get copyWith => _$MediaSizeCopyWithImpl<MediaSize>(this as MediaSize, _$identity);

  /// Serializes this MediaSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSize&&(identical(other.file, file) || other.file == file)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,width,height,mimeType,sourceUrl);

@override
String toString() {
  return 'MediaSize(file: $file, width: $width, height: $height, mimeType: $mimeType, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class $MediaSizeCopyWith<$Res>  {
  factory $MediaSizeCopyWith(MediaSize value, $Res Function(MediaSize) _then) = _$MediaSizeCopyWithImpl;
@useResult
$Res call({
 String? file, int? width, int? height,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'source_url') String? sourceUrl
});




}
/// @nodoc
class _$MediaSizeCopyWithImpl<$Res>
    implements $MediaSizeCopyWith<$Res> {
  _$MediaSizeCopyWithImpl(this._self, this._then);

  final MediaSize _self;
  final $Res Function(MediaSize) _then;

/// Create a copy of MediaSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? file = freezed,Object? width = freezed,Object? height = freezed,Object? mimeType = freezed,Object? sourceUrl = freezed,}) {
  return _then(_self.copyWith(
file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaSize].
extension MediaSizePatterns on MediaSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaSize value)  $default,){
final _that = this;
switch (_that) {
case _MediaSize():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaSize value)?  $default,){
final _that = this;
switch (_that) {
case _MediaSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? file,  int? width,  int? height, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'source_url')  String? sourceUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaSize() when $default != null:
return $default(_that.file,_that.width,_that.height,_that.mimeType,_that.sourceUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? file,  int? width,  int? height, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'source_url')  String? sourceUrl)  $default,) {final _that = this;
switch (_that) {
case _MediaSize():
return $default(_that.file,_that.width,_that.height,_that.mimeType,_that.sourceUrl);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? file,  int? width,  int? height, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'source_url')  String? sourceUrl)?  $default,) {final _that = this;
switch (_that) {
case _MediaSize() when $default != null:
return $default(_that.file,_that.width,_that.height,_that.mimeType,_that.sourceUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaSize implements MediaSize {
  const _MediaSize({this.file, this.width, this.height, @JsonKey(name: 'mime_type') this.mimeType, @JsonKey(name: 'source_url') this.sourceUrl});
  factory _MediaSize.fromJson(Map<String, dynamic> json) => _$MediaSizeFromJson(json);

@override final  String? file;
@override final  int? width;
@override final  int? height;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
@override@JsonKey(name: 'source_url') final  String? sourceUrl;

/// Create a copy of MediaSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaSizeCopyWith<_MediaSize> get copyWith => __$MediaSizeCopyWithImpl<_MediaSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaSizeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaSize&&(identical(other.file, file) || other.file == file)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,width,height,mimeType,sourceUrl);

@override
String toString() {
  return 'MediaSize(file: $file, width: $width, height: $height, mimeType: $mimeType, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class _$MediaSizeCopyWith<$Res> implements $MediaSizeCopyWith<$Res> {
  factory _$MediaSizeCopyWith(_MediaSize value, $Res Function(_MediaSize) _then) = __$MediaSizeCopyWithImpl;
@override @useResult
$Res call({
 String? file, int? width, int? height,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'source_url') String? sourceUrl
});




}
/// @nodoc
class __$MediaSizeCopyWithImpl<$Res>
    implements _$MediaSizeCopyWith<$Res> {
  __$MediaSizeCopyWithImpl(this._self, this._then);

  final _MediaSize _self;
  final $Res Function(_MediaSize) _then;

/// Create a copy of MediaSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? file = freezed,Object? width = freezed,Object? height = freezed,Object? mimeType = freezed,Object? sourceUrl = freezed,}) {
  return _then(_MediaSize(
file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
