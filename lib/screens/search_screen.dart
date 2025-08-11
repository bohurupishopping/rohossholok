import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_widget.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
import '../providers/posts_cubit.dart';

import '../providers/categories_cubit.dart';

import '../routes/app_router.dart';

/// Screen for searching posts
class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  
  const SearchScreen({
    super.key,
    this.initialQuery,
  });
  
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  
  bool _showFilters = false;
  String? _selectedCategory;
  DateTimeRange? _selectedDateRange;
  List<String> _searchHistory = [];
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
    
    // Load categories for filters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().loadCategories();
    });
    
    // Load search history (in a real app, this would come from local storage)
    _loadSearchHistory();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final postsState = context.read<PostsCubit>().state;
      postsState.whenOrNull(
        loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
          if (hasMore && searchQuery?.isNotEmpty == true) {
            context.read<PostsCubit>().loadMorePosts();
          }
        },
      );
    }
  }
  
  void _loadSearchHistory() {
    // In a real app, load from SharedPreferences or Hive
    setState(() {
      _searchHistory = [
        'বাংলাদেশ',
        'প্রযুক্তি',
        'খেলাধুলা',
        'রাজনীতি',
      ];
    });
  }
  
  void _saveToSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.take(10).toList();
      }
    });
    
    // In a real app, save to SharedPreferences or Hive
  }
  
  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }
  
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    _saveToSearchHistory(query);
    context.read<PostsCubit>().searchPosts(query);
    _searchFocusNode.unfocus();
  }
  
  void _clearSearch() {
    _searchController.clear();
    context.read<PostsCubit>().clearFilters();
    setState(() {
      _selectedCategory = null;
      _selectedDateRange = null;
    });
  }
  
  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }
  
  void _applyCategoryFilter(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }
  
  void _applyDateRangeFilter(DateTimeRange? dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
    });
    
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }
  
  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedDateRange = null;
    });
    
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        initialQuery: widget.initialQuery,
        onQueryChanged: (query) {
          // Optional: implement live search
        },
        onQuerySubmitted: _performSearch,
        onClear: _clearSearch,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_showFilters) _buildFiltersSection(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: SearchWidget(
              controller: _searchController,
              onSubmitted: _performSearch,
              onClear: _clearSearch,
              autofocus: widget.initialQuery == null,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          IconButton(
            onPressed: _toggleFilters,
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            tooltip: _showFilters ? 'ফিল্টার লুকান' : 'ফিল্টার দেখান',
          ),
        ],
      ),
    );
  }
  
  Widget _buildFiltersSection() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: LoadingSpinner(),
          ),
          loaded: (categories) => SearchFilters(
            categories: categories.map((cat) => cat.name).toList(),
            selectedCategory: _selectedCategory,
            onCategoryChanged: _applyCategoryFilter,
            dateRange: _selectedDateRange,
            onDateRangeChanged: _applyDateRangeFilter,
            onClearFilters: _clearFilters,
          ),
          error: (message) => const SizedBox.shrink(),
        );
      },
    );
  }
  
  Widget _buildSearchResults() {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildSearchSuggestions(),
          loading: () => const Center(child: LoadingSpinner()),
          loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
            if (searchQuery?.isEmpty ?? true) {
              return _buildSearchSuggestions();
            }
            
            return _buildSearchResultsList(
              posts,
              hasMore,
              searchQuery!,
            );
          },
          error: (message) => AppErrorWidget(
            message: message,
            onRetry: () {
              if (_searchController.text.isNotEmpty) {
                _performSearch(_searchController.text);
              }
            },
          ),
        );
      },
    );
  }
  
  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          if (_searchHistory.isNotEmpty)
            SearchSuggestions(
              suggestions: _searchHistory,
              onSuggestionTap: (suggestion) {
                _searchController.text = suggestion;
                _performSearch(suggestion);
              },
              onClearHistory: _clearSearchHistory,
            ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildPopularSearches(),
        ],
      ),
    );
  }
  
  Widget _buildPopularSearches() {
    final popularSearches = [
      'বাংলাদেশ',
      'প্রযুক্তি',
      'খেলাধুলা',
      'রাজনীতি',
      'অর্থনীতি',
      'শিক্ষা',
    ];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'জনপ্রিয় অনুসন্ধান',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Wrap(
              spacing: AppConstants.paddingSmall,
              runSpacing: AppConstants.paddingSmall,
              children: popularSearches.map(
                (search) => ActionChip(
                  label: Text(search),
                  onPressed: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchResultsList(
    List posts,
    bool hasMore,
    String searchQuery,
  ) {
    if (posts.isEmpty) {
      return SearchNoResultsWidget(
        searchQuery: searchQuery,
        onClearSearch: _clearSearch,
      );
    }
    
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: SearchResultsHeader(
              query: searchQuery,
              resultCount: posts.length,
              category: _selectedCategory,
              onClearSearch: _clearSearch,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < posts.length) {
                  final post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.paddingMedium,
                    ),
                    child: PostCard(
                      post: post,
                      onTap: () {
                        AppNavigation.goToPost(context, post.id);
                      },
                    ),
                  );
                } else if (hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                    child: Center(child: LoadingSpinner()),
                  );
                }
                return null;
              },
              childCount: posts.length + (hasMore ? 1 : 0),
            ),
          ),
        ),
      ],
    );
  }
}

/// Search suggestions widget for quick searches
class QuickSearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  
  const QuickSearchSuggestions({
    super.key,
    required this.suggestions,
    this.onSuggestionTap,
  });
  
  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'দ্রুত অনুসন্ধান',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            ...suggestions.map(
              (suggestion) => ListTile(
                leading: const Icon(Icons.trending_up),
                title: Text(suggestion),
                trailing: const Icon(Icons.north_west),
                onTap: () => onSuggestionTap?.call(suggestion),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}