// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/app_drawer.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../models/category_model.dart';
import '../models/post_model.dart';
import '../routes/app_router.dart';

// --- Consolidated Modern UI Theme ---
class _AppTheme {
  // Palette
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF4C6FFF);
  static const Color accentRed = Color(0xFFE53935); // For specific highlights
  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF757575);
  static const Color tagBg = Color(0xFFFCE4EC);
  static const Color tagText = Color(0xFFC2185B);

  // Spacing & Radii
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
}

/// Screen for displaying posts in a specific category
class CategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsCubit>().filterByCategory(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<PostsCubit>().loadMorePostsIfShould(widget.categoryId);
    }
  }

  Future<void> _onRefresh() async {
    // FIX: Removed the undefined 'isRefresh' parameter.
    await context.read<PostsCubit>().filterByCategory(widget.categoryId);
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
        drawer: const AppDrawer(),
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: _AppTheme.primary,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                _ModernCategoryAppBar(categoryName: widget.categoryName),
                const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
                _PostsSection(
                  categoryId: widget.categoryId,
                  onRefresh: _onRefresh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Category Screen Widgets (Optimized with const) ---

class _PostsSection extends StatelessWidget {
  final int categoryId;
  final Future<void> Function() onRefresh;

  const _PostsSection({required this.categoryId, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SliverToBoxAdapter(child: _FeedSkeleton()),
          // FIX: Correctly handle the loading state, which has no parameters.
          loading: () => const SliverToBoxAdapter(child: _FeedSkeleton()),
          // FIX: Correctly match the signature of the 'loaded' state.
          loaded: (posts, hasMore, page, currentCategoryId, query) {
            // Guard against showing stale data from another category while loading.
            if (currentCategoryId != categoryId && posts.isNotEmpty) {
              return const SliverToBoxAdapter(child: _FeedSkeleton());
            }
            if (posts.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _ModernEmptyState(
                  icon: Icons.article_outlined,
                  message: 'No posts found in this category.',
                  onRetry: onRefresh,
                ),
              );
            }
            return _buildLoadedPosts(posts, hasMore);
          },
          error: (message) => SliverFillRemaining(
            hasScrollBody: false,
            child: _ModernErrorState(message: message, onRetry: onRefresh),
          ),
        );
      },
    );
  }

  Widget _buildLoadedPosts(List<PostModel> posts, bool hasMore) {
    return SliverList.builder(
      itemCount: posts.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < posts.length) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
                _AppTheme.spaceM, 0, _AppTheme.spaceM, _AppTheme.spaceM),
            child: _ModernFeedCard(post: posts[index]),
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

class _ModernCategoryAppBar extends StatelessWidget {
  final String categoryName;
  const _ModernCategoryAppBar({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
          _AppTheme.spaceM, _AppTheme.spaceL, _AppTheme.spaceM, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            _AppBarButton(
              icon: Icons.arrow_back,
              onPressed: () => AppNavigation.goBack(context),
            ),
            const SizedBox(width: _AppTheme.spaceM),
            Expanded(
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _AppBarButton(icon: Icons.notifications_none, onPressed: () {}),
            const SizedBox(width: _AppTheme.spaceS),
            _AppBarButton(
                icon: Icons.search,
                onPressed: () => AppNavigation.goToSearch(context)),
          ],
        ),
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _AppBarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _AppTheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: _AppTheme.textPrimary, size: 20),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }
}

class _ModernFeedCard extends StatelessWidget {
  final PostModel post;
  const _ModernFeedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.getFormattedDate()} • ${post.getEstimatedReadingTime()} min read',
                        style: const TextStyle(
                            fontSize: 12,
                            color: _AppTheme.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: _AppTheme.spaceS),
                      Text(
                        post.title.rendered,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: _AppTheme.spaceS),
                      if (post.excerpt.rendered.isNotEmpty)
                        Text(
                          post.excerpt.rendered.replaceAll(RegExp(r"<[^>]*>"), ''),
                          style: const TextStyle(
                            fontSize: 14,
                            color: _AppTheme.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: _AppTheme.spaceM),
                      _buildTags(post),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                _buildImage(post.featuredImageUrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTags(PostModel post) {
    final tags = post.getCategoryNames().take(2).toList();
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: _AppTheme.spaceS,
      runSpacing: _AppTheme.spaceS,
      children: tags
          .map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _AppTheme.tagBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                      color: _AppTheme.tagText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_AppTheme.radiusM),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: 90,
              height: 110,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const SizedBox(width: 90, height: 110, child: ColoredBox(color: _AppTheme.scaffoldBg)),
              errorWidget: (context, url, error) => const SizedBox(
                width: 90,
                height: 110,
                child: ColoredBox(
                  color: _AppTheme.scaffoldBg,
                  child: Icon(Icons.broken_image,
                      color: _AppTheme.textSecondary, size: 24),
                ),
              ),
            )
          : const SizedBox(width: 90, height: 110, child: ColoredBox(color: _AppTheme.scaffoldBg)),
    );
  }
}

/// All categories screen
class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().loadCategories();
    });
  }

  Future<void> _onRefresh() async {
    // FIX: Removed the undefined 'isRefresh' parameter.
    await context.read<CategoriesCubit>().loadCategories();
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
        drawer: const AppDrawer(),
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: _AppTheme.primary,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                const _ModernCategoryAppBar(categoryName: 'All Categories'),
                const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const _CategoriesGridSkeleton(),
                      loading: () => const _CategoriesGridSkeleton(),
                      loaded: (categories) {
                        if (categories.isEmpty) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: _ModernEmptyState(
                              icon: Icons.category_outlined,
                              message: 'No categories available.',
                              onRetry: _onRefresh,
                            ),
                          );
                        }
                        // Use SliverGrid directly for performance.
                        return SliverPadding(
                          padding: const EdgeInsets.all(_AppTheme.spaceM),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 600 ? 3 : 2,
                              crossAxisSpacing: _AppTheme.spaceM,
                              mainAxisSpacing: _AppTheme.spaceM,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) =>
                                _ModernCategoryCard(category: categories[index]),
                          ),
                        );
                      },
                      error: (message) => SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ModernErrorState(
                          message: message,
                          onRetry: _onRefresh,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernCategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _ModernCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15)
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToCategory(context, category.id, category.name),
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _AppTheme.accentRed.withOpacity(0.1),
                  child: const Icon(Icons.folder_open,
                      color: _AppTheme.accentRed, size: 24),
                ),
                const Spacer(),
                Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _AppTheme.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.count} Articles',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Skeleton and State Widgets (Optimized with const) ---

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(_AppTheme.spaceM),
          margin: const EdgeInsets.only(bottom: _AppTheme.spaceM),
          decoration: BoxDecoration(
            color: _AppTheme.surface,
            borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10, width: 120, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 18, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 18, width: 100, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 14, color: Colors.white),
                ],
              )),
              const SizedBox(width: _AppTheme.spaceM),
              Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesGridSkeleton extends StatelessWidget {
  const _CategoriesGridSkeleton();

  @override
  Widget build(BuildContext context) {
    // FIX: This widget must return a Sliver. The correct pattern is to use
    // SliverToBoxAdapter to host the Shimmer widget, which in turn contains
    // a regular GridView.builder for the skeleton layout.
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: GridView.builder(
          padding: const EdgeInsets.all(_AppTheme.spaceM),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: _AppTheme.spaceM,
            mainAxisSpacing: _AppTheme.spaceM,
            childAspectRatio: 0.9,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: _AppTheme.surface,
              borderRadius: BorderRadius.circular(_AppTheme.radiusL),
            ),
          ),
        ),
      ),
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
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cloud_off, color: _AppTheme.textSecondary, size: 50),
          const SizedBox(height: _AppTheme.spaceM),
          const Text('An Error Occurred',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _AppTheme.textPrimary)),
          const SizedBox(height: _AppTheme.spaceS),
          Text(message,
              style: const TextStyle(color: _AppTheme.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _AppTheme.primary, foregroundColor: _AppTheme.surface),
              onPressed: onRetry,
              child: const Text('Try Again'))
        ]),
      ),
    );
  }
}

class _ModernEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onRetry;
  const _ModernEmptyState(
      {required this.icon, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: _AppTheme.textSecondary, size: 50),
            const SizedBox(height: _AppTheme.spaceM),
            Text(message,
                style:
                    const TextStyle(color: _AppTheme.textSecondary, fontSize: 16)),
            const SizedBox(height: _AppTheme.spaceS),
            const Text("Tap to refresh",
                style: TextStyle(color: _AppTheme.textSecondary, fontSize: 12))
          ]),
        ),
      ),
    );
  }
}

// Helper extension remains unchanged
extension on PostsCubit {
  void loadMorePostsIfShould(int categoryId) {
    final s = state;
    s.whenOrNull(loaded: (_, hasMore, _, currentCategoryId, _) {
      if (hasMore && currentCategoryId == categoryId) {
        loadMorePosts();
      }
    });
  }
}