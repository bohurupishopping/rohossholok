import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/page_model.dart';
import '../services/wordpress_api_service.dart';

part 'pages_cubit.freezed.dart';
part 'pages_state.dart';

/// Cubit for managing pages state
class PagesCubit extends Cubit<PagesState> {
  final WordPressApiService _apiService;
  
  PagesCubit(this._apiService) : super(const PagesState.initial());
  
  /// Load page by ID
  Future<void> loadPage(int id) async {
    emit(const PagesState.loading());
    
    try {
      final page = await _apiService.getPage(id);
      emit(PagesState.loaded(page));
    } catch (e) {
      emit(PagesState.error(e.toString()));
    }
  }
  
  /// Load page by slug
  Future<void> loadPageBySlug(String slug) async {
    emit(const PagesState.loading());
    
    try {
      final page = await _apiService.getPageBySlug(slug);
      if (page != null) {
        emit(PagesState.loaded(page));
      } else {
        emit(const PagesState.error('Page not found'));
      }
    } catch (e) {
      emit(PagesState.error(e.toString()));
    }
  }
  
  /// Load all pages
  Future<void> loadAllPages() async {
    emit(const PagesState.loading());
    
    try {
      final pages = await _apiService.getPages();
      emit(PagesState.allLoaded(pages));
    } catch (e) {
      emit(PagesState.error(e.toString()));
    }
  }
  
  /// Refresh current page
  Future<void> refreshPage() async {
    await state.maybeWhen(
      loaded: (page) async {
        await loadPage(page.id);
      },
      orElse: () async {},
    );
  }
}