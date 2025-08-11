// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../models/post_model.dart';
import '../routes/app_router.dart';

// --- Centralized Modern UI Theme ---
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // Note: Filter state is kept simple here. For a real app,
  // this might be managed in a separate Cubit.
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
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final cubit = context.read<PostsCubit>();
      final state = cubit.state;
      state.whenOrNull(
        loaded: (posts, hasMore, _, categoryId, searchQuery) {
          if (hasMore && searchQuery != null && searchQuery.isNotEmpty) {
            cubit.loadMorePosts();
          }
        },
      );
    }
  }


  
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<PostsCubit>().searchPosts(query, categoryId: _selectedCategory != null ? int.tryParse(_selectedCategory!) : null);
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
      backgroundColor: _AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_AppTheme.radiusL)),
      ),
      builder: (_) => _FilterSheetContent(
        categoriesCubit: context.read<CategoriesCubit>(),
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) {
          setState(() => _selectedCategory = category);
          if (_searchController.text.isNotEmpty) _performSearch(_searchController.text);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      appBar: _ModernSearchAppBar(
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onSubmitted: _performSearch,
        onClear: _clearSearch,
        onFilterTap: _showFilterSheet,
      ),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildInitialState(),
            loading: () => const _FeedSkeleton(),
            loaded: (posts, hasMore, _, _, searchQuery) {
              if (searchQuery == null || searchQuery.isEmpty) return _buildInitialState();
              if (posts.isEmpty) {
                return _SearchNoResults(query: searchQuery, onClear: _clearSearch);
              }
              return _buildResultsList(posts, hasMore);
            },
            error: (message) => _ModernErrorState(message: message, onRetry: () => _performSearch(_searchController.text)),
          );
        },
      ),
    );
  }

  Widget _buildInitialState() {
    final popularTopics = ['Technology', 'Sports', 'Philosophy', 'Science', 'Health', 'Education'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(_AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: _AppTheme.spaceL),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(_AppTheme.spaceL),
                  decoration: BoxDecoration(
                    color: _AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 48,
                    color: _AppTheme.primary,
                  ),
                ),
                const SizedBox(height: _AppTheme.spaceM),
                const Text(
                  'Discover Articles',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: _AppTheme.spaceS),
                const Text(
                  'Search for articles on topics you\'re interested in',
                  style: TextStyle(
                    fontSize: 16,
                    color: _AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: _AppTheme.spaceL),
          _ModernSectionHeader(title: 'Popular Topics'),
          const SizedBox(height: _AppTheme.spaceM),
          _ModernTopicsGrid(
            topics: popularTopics,
            onTopicTap: (topic) {
              _searchController.text = topic;
              _performSearch(topic);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultsList(List<PostModel> posts, bool hasMore) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      itemCount: posts.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < posts.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: _AppTheme.spaceM),
            child: _FeedPostCard(post: posts[index]),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator(color: _AppTheme.primary)),
          );
        }
      },
    );
  }
}

// --- New UI Components ---

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
      backgroundColor: _AppTheme.scaffoldBg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _AppTheme.textPrimary),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: Container(
        height: 52,
        margin: const EdgeInsets.only(right: _AppTheme.spaceM),
        decoration: BoxDecoration(
          color: _AppTheme.surface,
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          autofocus: true,
          style: const TextStyle(color: _AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search articles...',
            hintStyle: const TextStyle(color: _AppTheme.textSecondary),
            prefixIcon: const Icon(Icons.search, color: _AppTheme.textSecondary),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: searchController,
              builder: (context, value, child) {
                return value.text.isNotEmpty ? IconButton(
                  icon: const Icon(Icons.close, color: _AppTheme.textSecondary),
                  onPressed: onClear,
                ) : const SizedBox.shrink();
              },
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ModernSectionHeader extends StatelessWidget {
  final String title;

  const _ModernSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _AppTheme.spaceM,
        vertical: _AppTheme.spaceS,
      ),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        border: Border.all(
          color: _AppTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: _AppTheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: _AppTheme.spaceM),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}



class _ModernTopicsGrid extends StatelessWidget {
  final List<String> topics;
  final Function(String) onTopicTap;

  const _ModernTopicsGrid({
    required this.topics,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _AppTheme.spaceM,
      runSpacing: _AppTheme.spaceM,
      children: topics.map((topic) => _ModernTopicChip(
        label: topic,
        onTap: () => onTopicTap(topic),
      )).toList(),
    );
  }
}

class _ModernTopicChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ModernTopicChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _AppTheme.surface,
      borderRadius: BorderRadius.circular(_AppTheme.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: _AppTheme.spaceL,
            vertical: _AppTheme.spaceM,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_AppTheme.radiusL),
            border: Border.all(
              color: _AppTheme.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tag,
                  size: 16,
                  color: _AppTheme.primary,
                ),
              ),
              const SizedBox(width: _AppTheme.spaceS),
              Text(
                label,
                style: const TextStyle(
                  color: _AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheetContent extends StatelessWidget {
  final CategoriesCubit categoriesCubit;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  
  const _FilterSheetContent({required this.categoriesCubit, this.selectedCategory, required this.onCategorySelected});

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
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: _AppTheme.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _AppTheme.textPrimary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _AppTheme.scaffoldBg,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: _AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: _AppTheme.spaceL),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            bloc: categoriesCubit,
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (categories) => Column(
                  children: [
                    _ModernCategoryTile(
                      title: 'All Categories',
                      icon: Icons.apps,
                      isSelected: selectedCategory == null,
                      onTap: () => onCategorySelected(null),
                    ),
                    const SizedBox(height: _AppTheme.spaceS),
                    ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(bottom: _AppTheme.spaceS),
                      child: _ModernCategoryTile(
                        title: category.name,
                        icon: Icons.category,
                        isSelected: selectedCategory == category.id.toString(),
                        onTap: () => onCategorySelected(category.id.toString()),
                      ),
                    )),
                  ],
                ),
                orElse: () => const Center(child: CircularProgressIndicator(color: _AppTheme.primary)),
              );
            },
          ),
          const SizedBox(height: _AppTheme.spaceL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: _AppTheme.spaceL),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
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

  const _ModernCategoryTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? _AppTheme.primary.withValues(alpha: 0.1) : _AppTheme.scaffoldBg,
      borderRadius: BorderRadius.circular(_AppTheme.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        child: Container(
          padding: const EdgeInsets.all(_AppTheme.spaceL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_AppTheme.radiusL),
            border: Border.all(
              color: isSelected ? _AppTheme.primary : _AppTheme.primary.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_AppTheme.spaceS),
                decoration: BoxDecoration(
                  color: isSelected ? _AppTheme.primary : _AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : _AppTheme.primary,
                ),
              ),
              const SizedBox(width: _AppTheme.spaceM),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? _AppTheme.primary : _AppTheme.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: _AppTheme.primary,
                  size: 20,
                ),
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
            Container(
              padding: const EdgeInsets.all(_AppTheme.spaceL),
              decoration: BoxDecoration(
                color: _AppTheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: _AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: _AppTheme.spaceL),
            const Text(
              'No results found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _AppTheme.spaceS),
            Text(
              'We couldn\'t find any articles for "$query"',
              style: const TextStyle(
                fontSize: 16,
                color: _AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _AppTheme.spaceM),
            Container(
              padding: const EdgeInsets.all(_AppTheme.spaceL),
              decoration: BoxDecoration(
                color: _AppTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                border: Border.all(
                  color: _AppTheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: const Text(
                'Try adjusting your search terms or browse popular topics above',
                style: TextStyle(
                  fontSize: 14,
                  color: _AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton(
              onPressed: onClear,
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: _AppTheme.spaceL,
                  vertical: _AppTheme.spaceL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Clear Search',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Widgets (can be moved to a common file) ---

class _FeedPostCard extends StatelessWidget {
  final PostModel post;
  const _FeedPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final categoryName = post.getCategoryNames().firstOrNull ?? 'General';
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _AppTheme.spaceS,
        vertical: _AppTheme.spaceS,
      ),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        border: Border.all(
          color: _AppTheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceL),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _AppTheme.spaceM,
                          vertical: _AppTheme.spaceS,
                        ),
                        decoration: BoxDecoration(
                          color: _AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                        ),
                        child: Text(
                          '$categoryName • ${post.getFormattedDate()}',
                          style: TextStyle(
                            color: _AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: _AppTheme.spaceM),
                      Text(
                        post.title.rendered,
                        style: const TextStyle(
                          color: _AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: _AppTheme.spaceM),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: _AppTheme.scaffoldBg,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                            ),
                          ),
                          const SizedBox(width: _AppTheme.spaceM),
                          Expanded(
                            child: Text(
                              post.getAuthorName(),
                              style: const TextStyle(
                                color: _AppTheme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceL),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                    child: CachedNetworkImage(
                      imageUrl: post.featuredImageUrl ?? 'https://via.placeholder.com/100x100',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: _AppTheme.scaffoldBg,
                        child: Icon(
                          Icons.image_rounded,
                          color: _AppTheme.textSecondary,
                          size: 32,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: _AppTheme.scaffoldBg,
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: _AppTheme.textSecondary,
                          size: 32,
                        ),
                      ),
                    ),
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
            padding: const EdgeInsets.all(_AppTheme.spaceS),
            decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM)),
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
                Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
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
            Container(
              padding: const EdgeInsets.all(_AppTheme.radiusXL),
              decoration: BoxDecoration(
                color: _AppTheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: _AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: _AppTheme.spaceL),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _AppTheme.spaceS),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: _AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _AppTheme.spaceM),
            Container(
              padding: const EdgeInsets.all(_AppTheme.spaceL),
              decoration: BoxDecoration(
                color: _AppTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                border: Border.all(
                  color: _AppTheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: const Text(
                'Please check your connection and try again',
                style: TextStyle(
                  fontSize: 14,
                  color: _AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: _AppTheme.radiusXL,
                  vertical: _AppTheme.spaceL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
