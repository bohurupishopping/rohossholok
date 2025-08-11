// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageModel {

 int get id; String get date;@JsonKey(name: 'date_gmt') String get dateGmt; RenderedContent get title; RenderedContent get content; RenderedContent get excerpt; int get author;@JsonKey(name: 'featured_media') int get featuredMedia;@JsonKey(name: 'comment_status') String get commentStatus;@JsonKey(name: 'ping_status') String get pingStatus; String get template; int get parent;@JsonKey(name: 'menu_order') int get menuOrder; String get link; String get slug; String get status; String get type;@JsonKey(name: '_links') Map<String, dynamic>? get links;@JsonKey(name: '_embedded') Map<String, dynamic>? get embedded;
/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageModelCopyWith<PageModel> get copyWith => _$PageModelCopyWithImpl<PageModel>(this as PageModel, _$identity);

  /// Serializes this PageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.dateGmt, dateGmt) || other.dateGmt == dateGmt)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.author, author) || other.author == author)&&(identical(other.featuredMedia, featuredMedia) || other.featuredMedia == featuredMedia)&&(identical(other.commentStatus, commentStatus) || other.commentStatus == commentStatus)&&(identical(other.pingStatus, pingStatus) || other.pingStatus == pingStatus)&&(identical(other.template, template) || other.template == template)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.menuOrder, menuOrder) || other.menuOrder == menuOrder)&&(identical(other.link, link) || other.link == link)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.embedded, embedded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,date,dateGmt,title,content,excerpt,author,featuredMedia,commentStatus,pingStatus,template,parent,menuOrder,link,slug,status,type,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(embedded)]);

@override
String toString() {
  return 'PageModel(id: $id, date: $date, dateGmt: $dateGmt, title: $title, content: $content, excerpt: $excerpt, author: $author, featuredMedia: $featuredMedia, commentStatus: $commentStatus, pingStatus: $pingStatus, template: $template, parent: $parent, menuOrder: $menuOrder, link: $link, slug: $slug, status: $status, type: $type, links: $links, embedded: $embedded)';
}


}

/// @nodoc
abstract mixin class $PageModelCopyWith<$Res>  {
  factory $PageModelCopyWith(PageModel value, $Res Function(PageModel) _then) = _$PageModelCopyWithImpl;
@useResult
$Res call({
 int id, String date,@JsonKey(name: 'date_gmt') String dateGmt, RenderedContent title, RenderedContent content, RenderedContent excerpt, int author,@JsonKey(name: 'featured_media') int featuredMedia,@JsonKey(name: 'comment_status') String commentStatus,@JsonKey(name: 'ping_status') String pingStatus, String template, int parent,@JsonKey(name: 'menu_order') int menuOrder, String link, String slug, String status, String type,@JsonKey(name: '_links') Map<String, dynamic>? links,@JsonKey(name: '_embedded') Map<String, dynamic>? embedded
});


$RenderedContentCopyWith<$Res> get title;$RenderedContentCopyWith<$Res> get content;$RenderedContentCopyWith<$Res> get excerpt;

}
/// @nodoc
class _$PageModelCopyWithImpl<$Res>
    implements $PageModelCopyWith<$Res> {
  _$PageModelCopyWithImpl(this._self, this._then);

  final PageModel _self;
  final $Res Function(PageModel) _then;

/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? dateGmt = null,Object? title = null,Object? content = null,Object? excerpt = null,Object? author = null,Object? featuredMedia = null,Object? commentStatus = null,Object? pingStatus = null,Object? template = null,Object? parent = null,Object? menuOrder = null,Object? link = null,Object? slug = null,Object? status = null,Object? type = null,Object? links = freezed,Object? embedded = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,dateGmt: null == dateGmt ? _self.dateGmt : dateGmt // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RenderedContent,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RenderedContent,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as RenderedContent,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as int,featuredMedia: null == featuredMedia ? _self.featuredMedia : featuredMedia // ignore: cast_nullable_to_non_nullable
as int,commentStatus: null == commentStatus ? _self.commentStatus : commentStatus // ignore: cast_nullable_to_non_nullable
as String,pingStatus: null == pingStatus ? _self.pingStatus : pingStatus // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int,menuOrder: null == menuOrder ? _self.menuOrder : menuOrder // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,links: freezed == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,embedded: freezed == embedded ? _self.embedded : embedded // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get title {
  
  return $RenderedContentCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get content {
  
  return $RenderedContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get excerpt {
  
  return $RenderedContentCopyWith<$Res>(_self.excerpt, (value) {
    return _then(_self.copyWith(excerpt: value));
  });
}
}


/// Adds pattern-matching-related methods to [PageModel].
extension PageModelPatterns on PageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageModel value)  $default,){
final _that = this;
switch (_that) {
case _PageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageModel value)?  $default,){
final _that = this;
switch (_that) {
case _PageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String date, @JsonKey(name: 'date_gmt')  String dateGmt,  RenderedContent title,  RenderedContent content,  RenderedContent excerpt,  int author, @JsonKey(name: 'featured_media')  int featuredMedia, @JsonKey(name: 'comment_status')  String commentStatus, @JsonKey(name: 'ping_status')  String pingStatus,  String template,  int parent, @JsonKey(name: 'menu_order')  int menuOrder,  String link,  String slug,  String status,  String type, @JsonKey(name: '_links')  Map<String, dynamic>? links, @JsonKey(name: '_embedded')  Map<String, dynamic>? embedded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageModel() when $default != null:
return $default(_that.id,_that.date,_that.dateGmt,_that.title,_that.content,_that.excerpt,_that.author,_that.featuredMedia,_that.commentStatus,_that.pingStatus,_that.template,_that.parent,_that.menuOrder,_that.link,_that.slug,_that.status,_that.type,_that.links,_that.embedded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String date, @JsonKey(name: 'date_gmt')  String dateGmt,  RenderedContent title,  RenderedContent content,  RenderedContent excerpt,  int author, @JsonKey(name: 'featured_media')  int featuredMedia, @JsonKey(name: 'comment_status')  String commentStatus, @JsonKey(name: 'ping_status')  String pingStatus,  String template,  int parent, @JsonKey(name: 'menu_order')  int menuOrder,  String link,  String slug,  String status,  String type, @JsonKey(name: '_links')  Map<String, dynamic>? links, @JsonKey(name: '_embedded')  Map<String, dynamic>? embedded)  $default,) {final _that = this;
switch (_that) {
case _PageModel():
return $default(_that.id,_that.date,_that.dateGmt,_that.title,_that.content,_that.excerpt,_that.author,_that.featuredMedia,_that.commentStatus,_that.pingStatus,_that.template,_that.parent,_that.menuOrder,_that.link,_that.slug,_that.status,_that.type,_that.links,_that.embedded);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String date, @JsonKey(name: 'date_gmt')  String dateGmt,  RenderedContent title,  RenderedContent content,  RenderedContent excerpt,  int author, @JsonKey(name: 'featured_media')  int featuredMedia, @JsonKey(name: 'comment_status')  String commentStatus, @JsonKey(name: 'ping_status')  String pingStatus,  String template,  int parent, @JsonKey(name: 'menu_order')  int menuOrder,  String link,  String slug,  String status,  String type, @JsonKey(name: '_links')  Map<String, dynamic>? links, @JsonKey(name: '_embedded')  Map<String, dynamic>? embedded)?  $default,) {final _that = this;
switch (_that) {
case _PageModel() when $default != null:
return $default(_that.id,_that.date,_that.dateGmt,_that.title,_that.content,_that.excerpt,_that.author,_that.featuredMedia,_that.commentStatus,_that.pingStatus,_that.template,_that.parent,_that.menuOrder,_that.link,_that.slug,_that.status,_that.type,_that.links,_that.embedded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageModel implements PageModel {
  const _PageModel({required this.id, required this.date, @JsonKey(name: 'date_gmt') required this.dateGmt, required this.title, required this.content, required this.excerpt, required this.author, @JsonKey(name: 'featured_media') required this.featuredMedia, @JsonKey(name: 'comment_status') required this.commentStatus, @JsonKey(name: 'ping_status') required this.pingStatus, required this.template, required this.parent, @JsonKey(name: 'menu_order') required this.menuOrder, required this.link, required this.slug, required this.status, required this.type, @JsonKey(name: '_links') final  Map<String, dynamic>? links, @JsonKey(name: '_embedded') final  Map<String, dynamic>? embedded}): _links = links,_embedded = embedded;
  factory _PageModel.fromJson(Map<String, dynamic> json) => _$PageModelFromJson(json);

@override final  int id;
@override final  String date;
@override@JsonKey(name: 'date_gmt') final  String dateGmt;
@override final  RenderedContent title;
@override final  RenderedContent content;
@override final  RenderedContent excerpt;
@override final  int author;
@override@JsonKey(name: 'featured_media') final  int featuredMedia;
@override@JsonKey(name: 'comment_status') final  String commentStatus;
@override@JsonKey(name: 'ping_status') final  String pingStatus;
@override final  String template;
@override final  int parent;
@override@JsonKey(name: 'menu_order') final  int menuOrder;
@override final  String link;
@override final  String slug;
@override final  String status;
@override final  String type;
 final  Map<String, dynamic>? _links;
@override@JsonKey(name: '_links') Map<String, dynamic>? get links {
  final value = _links;
  if (value == null) return null;
  if (_links is EqualUnmodifiableMapView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _embedded;
@override@JsonKey(name: '_embedded') Map<String, dynamic>? get embedded {
  final value = _embedded;
  if (value == null) return null;
  if (_embedded is EqualUnmodifiableMapView) return _embedded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageModelCopyWith<_PageModel> get copyWith => __$PageModelCopyWithImpl<_PageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.dateGmt, dateGmt) || other.dateGmt == dateGmt)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.author, author) || other.author == author)&&(identical(other.featuredMedia, featuredMedia) || other.featuredMedia == featuredMedia)&&(identical(other.commentStatus, commentStatus) || other.commentStatus == commentStatus)&&(identical(other.pingStatus, pingStatus) || other.pingStatus == pingStatus)&&(identical(other.template, template) || other.template == template)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.menuOrder, menuOrder) || other.menuOrder == menuOrder)&&(identical(other.link, link) || other.link == link)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._links, _links)&&const DeepCollectionEquality().equals(other._embedded, _embedded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,date,dateGmt,title,content,excerpt,author,featuredMedia,commentStatus,pingStatus,template,parent,menuOrder,link,slug,status,type,const DeepCollectionEquality().hash(_links),const DeepCollectionEquality().hash(_embedded)]);

@override
String toString() {
  return 'PageModel(id: $id, date: $date, dateGmt: $dateGmt, title: $title, content: $content, excerpt: $excerpt, author: $author, featuredMedia: $featuredMedia, commentStatus: $commentStatus, pingStatus: $pingStatus, template: $template, parent: $parent, menuOrder: $menuOrder, link: $link, slug: $slug, status: $status, type: $type, links: $links, embedded: $embedded)';
}


}

/// @nodoc
abstract mixin class _$PageModelCopyWith<$Res> implements $PageModelCopyWith<$Res> {
  factory _$PageModelCopyWith(_PageModel value, $Res Function(_PageModel) _then) = __$PageModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String date,@JsonKey(name: 'date_gmt') String dateGmt, RenderedContent title, RenderedContent content, RenderedContent excerpt, int author,@JsonKey(name: 'featured_media') int featuredMedia,@JsonKey(name: 'comment_status') String commentStatus,@JsonKey(name: 'ping_status') String pingStatus, String template, int parent,@JsonKey(name: 'menu_order') int menuOrder, String link, String slug, String status, String type,@JsonKey(name: '_links') Map<String, dynamic>? links,@JsonKey(name: '_embedded') Map<String, dynamic>? embedded
});


@override $RenderedContentCopyWith<$Res> get title;@override $RenderedContentCopyWith<$Res> get content;@override $RenderedContentCopyWith<$Res> get excerpt;

}
/// @nodoc
class __$PageModelCopyWithImpl<$Res>
    implements _$PageModelCopyWith<$Res> {
  __$PageModelCopyWithImpl(this._self, this._then);

  final _PageModel _self;
  final $Res Function(_PageModel) _then;

/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? dateGmt = null,Object? title = null,Object? content = null,Object? excerpt = null,Object? author = null,Object? featuredMedia = null,Object? commentStatus = null,Object? pingStatus = null,Object? template = null,Object? parent = null,Object? menuOrder = null,Object? link = null,Object? slug = null,Object? status = null,Object? type = null,Object? links = freezed,Object? embedded = freezed,}) {
  return _then(_PageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,dateGmt: null == dateGmt ? _self.dateGmt : dateGmt // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as RenderedContent,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RenderedContent,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as RenderedContent,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as int,featuredMedia: null == featuredMedia ? _self.featuredMedia : featuredMedia // ignore: cast_nullable_to_non_nullable
as int,commentStatus: null == commentStatus ? _self.commentStatus : commentStatus // ignore: cast_nullable_to_non_nullable
as String,pingStatus: null == pingStatus ? _self.pingStatus : pingStatus // ignore: cast_nullable_to_non_nullable
as String,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int,menuOrder: null == menuOrder ? _self.menuOrder : menuOrder // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,links: freezed == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,embedded: freezed == embedded ? _self._embedded : embedded // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get title {
  
  return $RenderedContentCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get content {
  
  return $RenderedContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of PageModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedContentCopyWith<$Res> get excerpt {
  
  return $RenderedContentCopyWith<$Res>(_self.excerpt, (value) {
    return _then(_self.copyWith(excerpt: value));
  });
}
}

// dart format on
