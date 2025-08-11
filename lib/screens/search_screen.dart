// ignore_for_file: deprecated_member_use

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
    
    // Add listener for search text changes
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    
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
    _scrollController.removeListener(_onScroll);
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
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'খবর খুঁজুন...',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    onPressed: _clearSearch,
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        size: 16,
                      ),
                    ),
                    tooltip: 'পরিষ্কার করুন',
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: _toggleFilters,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _showFilters
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _showFilters ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
                      color: _showFilters
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ),
                  tooltip: _showFilters ? 'ফিল্টার লুকান' : 'ফিল্টার দেখান',
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _performSearch(value.trim());
          }
        },
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
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      child: Column(
        children: [
          if (_searchHistory.isNotEmpty) ...[
            SearchSuggestions(
              suggestions: _searchHistory,
              onSuggestionTap: (suggestion) {
                _searchController.text = suggestion;
                _performSearch(suggestion);
              },
              onClearHistory: _clearSearchHistory,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
          ],
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
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'জনপ্রিয় অনুসন্ধান',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: popularSearches.map(
                (search) => _buildPopularSearchChip(search),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearchChip(String search) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _searchController.text = search;
          _performSearch(search);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                search,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
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
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          sliver: SliverList.builder(
            itemCount: posts.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                final post = posts[index];
                return Container(
                  margin: const EdgeInsets.only(
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
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingLarge,
                  ),
                  child: const Center(child: LoadingSpinner()),
                );
              }
              return const SizedBox.shrink();
            },
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
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'দ্রুত অনুসন্ধান',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ...suggestions.map(
              (suggestion) => _buildSuggestionItem(context, suggestion),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSuggestionTap?.call(suggestion),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.north_west_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}