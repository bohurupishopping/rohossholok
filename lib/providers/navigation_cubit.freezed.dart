// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NavigationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NavigationState()';
}


}

/// @nodoc
class $NavigationStateCopyWith<$Res>  {
$NavigationStateCopyWith(NavigationState _, $Res Function(NavigationState) __);
}


/// Adds pattern-matching-related methods to [NavigationState].
extension NavigationStatePatterns on NavigationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NavigationHome value)?  home,TResult Function( NavigationCategory value)?  category,TResult Function( NavigationPost value)?  post,TResult Function( NavigationAbout value)?  about,TResult Function( NavigationContact value)?  contact,TResult Function( NavigationSearch value)?  search,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NavigationHome() when home != null:
return home(_that);case NavigationCategory() when category != null:
return category(_that);case NavigationPost() when post != null:
return post(_that);case NavigationAbout() when about != null:
return about(_that);case NavigationContact() when contact != null:
return contact(_that);case NavigationSearch() when search != null:
return search(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NavigationHome value)  home,required TResult Function( NavigationCategory value)  category,required TResult Function( NavigationPost value)  post,required TResult Function( NavigationAbout value)  about,required TResult Function( NavigationContact value)  contact,required TResult Function( NavigationSearch value)  search,}){
final _that = this;
switch (_that) {
case NavigationHome():
return home(_that);case NavigationCategory():
return category(_that);case NavigationPost():
return post(_that);case NavigationAbout():
return about(_that);case NavigationContact():
return contact(_that);case NavigationSearch():
return search(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NavigationHome value)?  home,TResult? Function( NavigationCategory value)?  category,TResult? Function( NavigationPost value)?  post,TResult? Function( NavigationAbout value)?  about,TResult? Function( NavigationContact value)?  contact,TResult? Function( NavigationSearch value)?  search,}){
final _that = this;
switch (_that) {
case NavigationHome() when home != null:
return home(_that);case NavigationCategory() when category != null:
return category(_that);case NavigationPost() when post != null:
return post(_that);case NavigationAbout() when about != null:
return about(_that);case NavigationContact() when contact != null:
return contact(_that);case NavigationSearch() when search != null:
return search(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  home,TResult Function( int categoryId,  String categoryName)?  category,TResult Function( int postId)?  post,TResult Function()?  about,TResult Function()?  contact,TResult Function( String query)?  search,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NavigationHome() when home != null:
return home();case NavigationCategory() when category != null:
return category(_that.categoryId,_that.categoryName);case NavigationPost() when post != null:
return post(_that.postId);case NavigationAbout() when about != null:
return about();case NavigationContact() when contact != null:
return contact();case NavigationSearch() when search != null:
return search(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  home,required TResult Function( int categoryId,  String categoryName)  category,required TResult Function( int postId)  post,required TResult Function()  about,required TResult Function()  contact,required TResult Function( String query)  search,}) {final _that = this;
switch (_that) {
case NavigationHome():
return home();case NavigationCategory():
return category(_that.categoryId,_that.categoryName);case NavigationPost():
return post(_that.postId);case NavigationAbout():
return about();case NavigationContact():
return contact();case NavigationSearch():
return search(_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  home,TResult? Function( int categoryId,  String categoryName)?  category,TResult? Function( int postId)?  post,TResult? Function()?  about,TResult? Function()?  contact,TResult? Function( String query)?  search,}) {final _that = this;
switch (_that) {
case NavigationHome() when home != null:
return home();case NavigationCategory() when category != null:
return category(_that.categoryId,_that.categoryName);case NavigationPost() when post != null:
return post(_that.postId);case NavigationAbout() when about != null:
return about();case NavigationContact() when contact != null:
return contact();case NavigationSearch() when search != null:
return search(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class NavigationHome implements NavigationState {
  const NavigationHome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationHome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NavigationState.home()';
}


}




/// @nodoc


class NavigationCategory implements NavigationState {
  const NavigationCategory(this.categoryId, this.categoryName);
  

 final  int categoryId;
 final  String categoryName;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationCategoryCopyWith<NavigationCategory> get copyWith => _$NavigationCategoryCopyWithImpl<NavigationCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName);

@override
String toString() {
  return 'NavigationState.category(categoryId: $categoryId, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $NavigationCategoryCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationCategoryCopyWith(NavigationCategory value, $Res Function(NavigationCategory) _then) = _$NavigationCategoryCopyWithImpl;
@useResult
$Res call({
 int categoryId, String categoryName
});




}
/// @nodoc
class _$NavigationCategoryCopyWithImpl<$Res>
    implements $NavigationCategoryCopyWith<$Res> {
  _$NavigationCategoryCopyWithImpl(this._self, this._then);

  final NavigationCategory _self;
  final $Res Function(NavigationCategory) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,}) {
  return _then(NavigationCategory(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NavigationPost implements NavigationState {
  const NavigationPost(this.postId);
  

 final  int postId;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationPostCopyWith<NavigationPost> get copyWith => _$NavigationPostCopyWithImpl<NavigationPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationPost&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,postId);

@override
String toString() {
  return 'NavigationState.post(postId: $postId)';
}


}

/// @nodoc
abstract mixin class $NavigationPostCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationPostCopyWith(NavigationPost value, $Res Function(NavigationPost) _then) = _$NavigationPostCopyWithImpl;
@useResult
$Res call({
 int postId
});




}
/// @nodoc
class _$NavigationPostCopyWithImpl<$Res>
    implements $NavigationPostCopyWith<$Res> {
  _$NavigationPostCopyWithImpl(this._self, this._then);

  final NavigationPost _self;
  final $Res Function(NavigationPost) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? postId = null,}) {
  return _then(NavigationPost(
null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class NavigationAbout implements NavigationState {
  const NavigationAbout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationAbout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NavigationState.about()';
}


}




/// @nodoc


class NavigationContact implements NavigationState {
  const NavigationContact();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationContact);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NavigationState.contact()';
}


}




/// @nodoc


class NavigationSearch implements NavigationState {
  const NavigationSearch(this.query);
  

 final  String query;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationSearchCopyWith<NavigationSearch> get copyWith => _$NavigationSearchCopyWithImpl<NavigationSearch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationSearch&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'NavigationState.search(query: $query)';
}


}

/// @nodoc
abstract mixin class $NavigationSearchCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationSearchCopyWith(NavigationSearch value, $Res Function(NavigationSearch) _then) = _$NavigationSearchCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$NavigationSearchCopyWithImpl<$Res>
    implements $NavigationSearchCopyWith<$Res> {
  _$NavigationSearchCopyWithImpl(this._self, this._then);

  final NavigationSearch _self;
  final $Res Function(NavigationSearch) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(NavigationSearch(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
