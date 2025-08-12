// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../models/post_model.dart';
import '../routes/app_router.dart';

// --- Centralized Modern UI Theme (Unchanged) ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF4C6FFF);

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;
}

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
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _searchFocusNode = FocusNode();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
    context.read<CategoriesCubit>().loadCategoriesIfNeeded();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<PostsCubit>().loadMorePosts();
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<PostsCubit>().searchPosts(query,
        categoryId: _selectedCategory != null ? int.tryParse(_selectedCategory!) : null);
    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<PostsCubit>().clearSearch();
    setState(() => _selectedCategory = null);
    _searchFocusNode.requestFocus();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoriesCubit>(),
        child: _FilterSheetContent(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() => _selectedCategory = category);
            if (_searchController.text.isNotEmpty) {
              _performSearch(_searchController.text);
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          AppNavigation.goBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: _AppTheme.scaffoldBg,
        appBar: _ModernSearchAppBar(
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
          onSubmitted: _performSearch,
          onClear: _clearSearch,
          onFilterTap: _showFilterSheet,
        ),
        body: SafeArea(
          top: false, // SafeArea for the top is handled by the AppBar
          child: BlocBuilder<PostsCubit, PostsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const _InitialSearchPrompt(),
                loading: () => const _FeedSkeleton(),
                loaded: (posts, hasMore, _, _, searchQuery) {
                  if (searchQuery == null || searchQuery.isEmpty) {
                    return const _InitialSearchPrompt();
                  }
                  if (posts.isEmpty) {
                    return _SearchNoResults(query: searchQuery, onClear: _clearSearch);
                  }
                  return _buildResultsList(posts, hasMore);
                },
                error: (message) =>
                    _ModernErrorState(message: message, onRetry: () => _performSearch(_searchController.text)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(List<PostModel> posts, bool hasMore) {
    final itemCount = posts.length + (hasMore ? 1 : 0);
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator(color: _AppTheme.primary)),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: _AppTheme.spaceM),
          child: _FeedPostCard(post: posts[index]),
        );
      },
    );
  }
}

// --- UI Components (Optimized with const and revamped AppBar) ---

class _ModernSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;

  const _ModernSearchAppBar({
    required this.searchController,
    required this.searchFocusNode,
    required this.onSubmitted,
    required this.onClear,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Makes the AppBar background invisible
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _AppTheme.textPrimary),
        onPressed: () => AppNavigation.goBack(context),
      ),
      // The title now contains the padded, rounded search field
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), // Adds top and bottom padding
        child: TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          autofocus: true,
          style: const TextStyle(color: _AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: _AppTheme.surface,
            hintText: 'Search articles...',
            hintStyle: const TextStyle(color: _AppTheme.textSecondary),
            prefixIcon: const Icon(Icons.search, color: _AppTheme.textSecondary),
            // Suffix icon to clear the text field
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: searchController,
              builder: (context, value, child) {
                return value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: _AppTheme.textSecondary),
                        onPressed: onClear,
                      )
                    : const SizedBox.shrink();
              },
            ),
            // This creates the "pure rounded" pill shape
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.0), // Adjusted for pure rounded
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: onSubmitted,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded, color: _AppTheme.textPrimary),
          onPressed: onFilterTap,
        ),
        const SizedBox(width: 8)
      ],
    );
  }

  @override
  // Increased height to accommodate the vertical padding
  Size get preferredSize => const Size.fromHeight(80.0); // Adjusted height
}

class _InitialSearchPrompt extends StatelessWidget {
  const _InitialSearchPrompt();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(_AppTheme.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 64, color: _AppTheme.textSecondary),
            SizedBox(height: _AppTheme.spaceM),
            Text('Discover Articles',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
            SizedBox(height: _AppTheme.spaceS),
            Text('Find articles on any topic you are interested in',
                style: TextStyle(fontSize: 16, color: _AppTheme.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FilterSheetContent extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const _FilterSheetContent({this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_AppTheme.spaceL),
      decoration: const BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_AppTheme.radiusXL)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: _AppTheme.textSecondary.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: _AppTheme.spaceL),
          const Text('Filter by Category',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
          const SizedBox(height: _AppTheme.spaceL),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (categories) => Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _ModernCategoryTile(
                        title: 'All Categories',
                        icon: Icons.apps_rounded,
                        isSelected: selectedCategory == null,
                        onTap: () => onCategorySelected(null),
                      ),
                      const SizedBox(height: _AppTheme.spaceS),
                      ...categories.map((category) => Padding(
                            padding: const EdgeInsets.only(bottom: _AppTheme.spaceS),
                            child: _ModernCategoryTile(
                              title: category.name,
                              icon: Icons.category_rounded,
                              isSelected: selectedCategory == category.id.toString(),
                              onTap: () => onCategorySelected(category.id.toString()),
                            ),
                          )),
                    ],
                  ),
                ),
                orElse: () => const Center(child: CircularProgressIndicator(color: _AppTheme.primary)),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + _AppTheme.spaceM),
        ],
      ),
    );
  }
}

class _ModernCategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernCategoryTile(
      {required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? _AppTheme.primary.withOpacity(0.1) : _AppTheme.scaffoldBg,
      borderRadius: BorderRadius.circular(_AppTheme.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        child: Container(
          padding: const EdgeInsets.all(_AppTheme.spaceL),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_AppTheme.radiusL),
              border: Border.all(
                  color: isSelected ? _AppTheme.primary : Colors.transparent, width: 1.5)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_AppTheme.spaceS),
                decoration: BoxDecoration(
                    color: isSelected ? _AppTheme.primary : _AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle),
                child:
                    Icon(icon, size: 20, color: isSelected ? Colors.white : _AppTheme.primary),
              ),
              const SizedBox(width: _AppTheme.spaceM),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? _AppTheme.primary : _AppTheme.textPrimary)),
              ),
              if (isSelected) const Icon(Icons.check_circle_rounded, color: _AppTheme.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchNoResults extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  const _SearchNoResults({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_AppTheme.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: _AppTheme.textSecondary),
            const SizedBox(height: _AppTheme.spaceL),
            const Text('No results found',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: _AppTheme.spaceS),
            Text('We couldn\'t find any articles for "$query"',
                style: const TextStyle(fontSize: 16, color: _AppTheme.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: _AppTheme.spaceL, vertical: _AppTheme.spaceM),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
                    elevation: 0)),
          ],
        ),
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final PostModel post;
  const _FeedPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final categoryName = post.getCategoryNames().firstOrNull ?? 'General';
    return Container(
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$categoryName • ${post.getFormattedDate()}',
                          style: const TextStyle(
                              color: _AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: _AppTheme.spaceS),
                      Text(post.title.rendered,
                          style: const TextStyle(
                              color: _AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.4),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                  child: CachedNetworkImage(
                      imageUrl: post.featuredImageUrl ?? 'https://via.placeholder.com/100x100',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: _AppTheme.scaffoldBg),
                      errorWidget: (context, url, error) => Container(
                          color: _AppTheme.scaffoldBg,
                          child: const Icon(Icons.broken_image_rounded,
                              color: _AppTheme.textSecondary))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: _AppTheme.shimmerBase,
          highlightColor: _AppTheme.shimmerHighlight,
          child: Container(
            margin: const EdgeInsets.only(bottom: _AppTheme.spaceM),
            decoration: BoxDecoration(
                color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 150, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(height: 16, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(height: 16, width: 180, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModernErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ModernErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_AppTheme.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: _AppTheme.textSecondary),
            const SizedBox(height: _AppTheme.spaceL),
            const Text('Something went wrong',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: _AppTheme.spaceS),
            Text(message,
                style: const TextStyle(fontSize: 16, color: _AppTheme.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: _AppTheme.spaceL, vertical: _AppTheme.spaceM),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
                    elevation: 0)),
          ],
        ),
      ),
    );
  }
}
