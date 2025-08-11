part of 'categories_cubit.dart';

/// State for categories management
@freezed
class CategoriesState with _$CategoriesState {
  /// Initial state
  const factory CategoriesState.initial() = CategoriesInitial;
  
  /// Loading state
  const factory CategoriesState.loading() = CategoriesLoading;
  
  /// Loaded state with categories data
  const factory CategoriesState.loaded(List<CategoryModel> categories) = CategoriesLoaded;
  
  /// Error state
  const factory CategoriesState.error(String message) = CategoriesError;
}