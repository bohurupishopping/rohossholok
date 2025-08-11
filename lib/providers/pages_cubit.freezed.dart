// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pages_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PagesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PagesState()';
}


}

/// @nodoc
class $PagesStateCopyWith<$Res>  {
$PagesStateCopyWith(PagesState _, $Res Function(PagesState) __);
}


/// Adds pattern-matching-related methods to [PagesState].
extension PagesStatePatterns on PagesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PagesInitial value)?  initial,TResult Function( PagesLoading value)?  loading,TResult Function( PagesLoaded value)?  loaded,TResult Function( PagesAllLoaded value)?  allLoaded,TResult Function( PagesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PagesInitial() when initial != null:
return initial(_that);case PagesLoading() when loading != null:
return loading(_that);case PagesLoaded() when loaded != null:
return loaded(_that);case PagesAllLoaded() when allLoaded != null:
return allLoaded(_that);case PagesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PagesInitial value)  initial,required TResult Function( PagesLoading value)  loading,required TResult Function( PagesLoaded value)  loaded,required TResult Function( PagesAllLoaded value)  allLoaded,required TResult Function( PagesError value)  error,}){
final _that = this;
switch (_that) {
case PagesInitial():
return initial(_that);case PagesLoading():
return loading(_that);case PagesLoaded():
return loaded(_that);case PagesAllLoaded():
return allLoaded(_that);case PagesError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PagesInitial value)?  initial,TResult? Function( PagesLoading value)?  loading,TResult? Function( PagesLoaded value)?  loaded,TResult? Function( PagesAllLoaded value)?  allLoaded,TResult? Function( PagesError value)?  error,}){
final _that = this;
switch (_that) {
case PagesInitial() when initial != null:
return initial(_that);case PagesLoading() when loading != null:
return loading(_that);case PagesLoaded() when loaded != null:
return loaded(_that);case PagesAllLoaded() when allLoaded != null:
return allLoaded(_that);case PagesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PageModel page)?  loaded,TResult Function( List<PageModel> pages)?  allLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PagesInitial() when initial != null:
return initial();case PagesLoading() when loading != null:
return loading();case PagesLoaded() when loaded != null:
return loaded(_that.page);case PagesAllLoaded() when allLoaded != null:
return allLoaded(_that.pages);case PagesError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PageModel page)  loaded,required TResult Function( List<PageModel> pages)  allLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PagesInitial():
return initial();case PagesLoading():
return loading();case PagesLoaded():
return loaded(_that.page);case PagesAllLoaded():
return allLoaded(_that.pages);case PagesError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PageModel page)?  loaded,TResult? Function( List<PageModel> pages)?  allLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PagesInitial() when initial != null:
return initial();case PagesLoading() when loading != null:
return loading();case PagesLoaded() when loaded != null:
return loaded(_that.page);case PagesAllLoaded() when allLoaded != null:
return allLoaded(_that.pages);case PagesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PagesInitial implements PagesState {
  const PagesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PagesState.initial()';
}


}




/// @nodoc


class PagesLoading implements PagesState {
  const PagesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PagesState.loading()';
}


}




/// @nodoc


class PagesLoaded implements PagesState {
  const PagesLoaded(this.page);
  

 final  PageModel page;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagesLoadedCopyWith<PagesLoaded> get copyWith => _$PagesLoadedCopyWithImpl<PagesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesLoaded&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,page);

@override
String toString() {
  return 'PagesState.loaded(page: $page)';
}


}

/// @nodoc
abstract mixin class $PagesLoadedCopyWith<$Res> implements $PagesStateCopyWith<$Res> {
  factory $PagesLoadedCopyWith(PagesLoaded value, $Res Function(PagesLoaded) _then) = _$PagesLoadedCopyWithImpl;
@useResult
$Res call({
 PageModel page
});


$PageModelCopyWith<$Res> get page;

}
/// @nodoc
class _$PagesLoadedCopyWithImpl<$Res>
    implements $PagesLoadedCopyWith<$Res> {
  _$PagesLoadedCopyWithImpl(this._self, this._then);

  final PagesLoaded _self;
  final $Res Function(PagesLoaded) _then;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? page = null,}) {
  return _then(PagesLoaded(
null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as PageModel,
  ));
}

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageModelCopyWith<$Res> get page {
  
  return $PageModelCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

/// @nodoc


class PagesAllLoaded implements PagesState {
  const PagesAllLoaded(final  List<PageModel> pages): _pages = pages;
  

 final  List<PageModel> _pages;
 List<PageModel> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}


/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagesAllLoadedCopyWith<PagesAllLoaded> get copyWith => _$PagesAllLoadedCopyWithImpl<PagesAllLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesAllLoaded&&const DeepCollectionEquality().equals(other._pages, _pages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pages));

@override
String toString() {
  return 'PagesState.allLoaded(pages: $pages)';
}


}

/// @nodoc
abstract mixin class $PagesAllLoadedCopyWith<$Res> implements $PagesStateCopyWith<$Res> {
  factory $PagesAllLoadedCopyWith(PagesAllLoaded value, $Res Function(PagesAllLoaded) _then) = _$PagesAllLoadedCopyWithImpl;
@useResult
$Res call({
 List<PageModel> pages
});




}
/// @nodoc
class _$PagesAllLoadedCopyWithImpl<$Res>
    implements $PagesAllLoadedCopyWith<$Res> {
  _$PagesAllLoadedCopyWithImpl(this._self, this._then);

  final PagesAllLoaded _self;
  final $Res Function(PagesAllLoaded) _then;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pages = null,}) {
  return _then(PagesAllLoaded(
null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<PageModel>,
  ));
}


}

/// @nodoc


class PagesError implements PagesState {
  const PagesError(this.message);
  

 final  String message;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagesErrorCopyWith<PagesError> get copyWith => _$PagesErrorCopyWithImpl<PagesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PagesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PagesErrorCopyWith<$Res> implements $PagesStateCopyWith<$Res> {
  factory $PagesErrorCopyWith(PagesError value, $Res Function(PagesError) _then) = _$PagesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PagesErrorCopyWithImpl<$Res>
    implements $PagesErrorCopyWith<$Res> {
  _$PagesErrorCopyWithImpl(this._self, this._then);

  final PagesError _self;
  final $Res Function(PagesError) _then;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PagesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
