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

// --- Modern UI Theme matching home_screen.dart ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF1B1D28);
  
  static const Color primary = Color(0xFF4C6FFF);
  
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
}

// Legacy constants for existing components
const Color _primaryColor = Color(0xFFE53935);
const Color _scaffoldBgColor = Color(0xFFF7F8FA);
const Color _cardBgColor = Colors.white;
const Color _primaryTextColor = Color(0xFF212121);
const Color _secondaryTextColor = Color(0xFF757575);
const Color _tagBgColor = Color(0xFFFCE4EC);
const Color _tagTextColor = Color(0xFFC2185B);

class _UI {
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<PostsCubit>().loadMorePostsIfShould(widget.categoryId);
    }
  }

  Future<void> _onRefresh() async {
    // FIX 1: Removed the undefined 'isRefresh' parameter.
    await context.read<PostsCubit>().filterByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: _AppTheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _ModernCategoryAppBar(categoryName: widget.categoryName),
            const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsSection() {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SliverToBoxAdapter(child: _FeedSkeleton()),
          // FIX 2: Correctly handle the loading state.
          // It now always shows a skeleton, which is clean and avoids state complexity.
          loading: () => const SliverToBoxAdapter(child: _FeedSkeleton()),
          loaded: (posts, hasMore, _, categoryId, _) {
            if (categoryId != widget.categoryId && posts.isNotEmpty) {
              return const SliverToBoxAdapter(child: _FeedSkeleton());
            }
            if (posts.isEmpty) {
              return SliverFillRemaining(
                  child: _ModernEmptyState(
                      icon: Icons.article_outlined,
                      message: 'No posts found in this category.',
                      onRetry: _onRefresh));
            }
            return _buildLoadedPosts(posts, hasMore);
          },
          error: (message) => SliverFillRemaining(
            child: _ModernErrorState(message: message, onRetry: _onRefresh),
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
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(_UI.paddingM, 0, _UI.paddingM, _UI.paddingM),
            child: _ModernFeedCard(post: post),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

// --- Modern App Bar for Category Screen ---

class _ModernCategoryAppBar extends StatelessWidget {
  final String categoryName;
  const _ModernCategoryAppBar({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(_AppTheme.spaceM, _AppTheme.spaceL, _AppTheme.spaceM, 0),
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
            _AppBarButton(icon: Icons.search, onPressed: () => AppNavigation.goToSearch(context)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
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
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(_UI.radiusL),
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
          borderRadius: BorderRadius.circular(_UI.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_UI.paddingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetaInfo(post),
                      const SizedBox(height: _UI.paddingS),
                      Text(
                        post.title.rendered,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _primaryTextColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: _UI.paddingS),
                      // FIX 4: Corrected the null-aware operator and added a robust check.
                      if (post.excerpt.rendered.isNotEmpty)
                        Text(
                          post.excerpt.rendered.replaceAll(RegExp(r"<[^>]*>"), ''),
                          style: const TextStyle(
                            fontSize: 14,
                            color: _secondaryTextColor,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: _UI.paddingM),
                      _buildTags(post),
                    ],
                  ),
                ),
                const SizedBox(width: _UI.paddingM),
                _buildImage(post.featuredImageUrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaInfo(PostModel post) {
    return Text(
      '${post.getFormattedDate()} • ${post.getEstimatedReadingTime()} min read',
      style: const TextStyle(fontSize: 12, color: _secondaryTextColor, fontWeight: FontWeight.w500),
    );
  }
  
  Widget _buildTags(PostModel post) {
    final tags = post.getCategoryNames().take(2).toList();
    if(tags.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: _UI.paddingS,
      runSpacing: _UI.paddingS,
      children: tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _tagBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag,
          style: const TextStyle(color: _tagTextColor, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      )).toList(),
    );
  }
  
  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_UI.radiusM),
      child: imageUrl != null ? CachedNetworkImage(
        imageUrl: imageUrl,
        width: 90,
        height: 110,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(width: 90, height: 110, color: _scaffoldBgColor),
        errorWidget: (context, url, error) => Container(
          width: 90,
          height: 110,
          color: _scaffoldBgColor,
          child: const Icon(Icons.broken_image, color: _secondaryTextColor, size: 24),
        ),
      ) : Container(width: 90, height: 110, color: _scaffoldBgColor),
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
    await context.read<CategoriesCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: _AppTheme.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const _ModernCategoryAppBar(categoryName: 'All Categories'),
            const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
            SliverToBoxAdapter(
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const _CategoriesGridSkeleton(),
                    loading: () => const _CategoriesGridSkeleton(),
                    loaded: (categories) => categories.isEmpty
                        ? _ModernEmptyState(
                            icon: Icons.category_outlined,
                            message: 'No categories available.',
                            onRetry: _onRefresh)
                        : _buildCategoriesGrid(categories),
                    error: (message) => _ModernErrorState(message: message, onRetry: _onRefresh),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<CategoryModel> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(_UI.paddingM),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: _UI.paddingM,
        mainAxisSpacing: _UI.paddingM,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) => _ModernCategoryCard(category: categories[index]),
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
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(_UI.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToCategory(context, category.id, category.name),
          borderRadius: BorderRadius.circular(_UI.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_UI.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.folder_open, color: _primaryColor, size: 24),
                ),
                const Spacer(),
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.count} Articles',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _secondaryTextColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Skeleton and State Widgets ---

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  Widget _buildPlaceholderLine({double height = 16, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: _UI.paddingM),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Added to constrain height within SliverToBoxAdapter
        itemCount: 5,
        // FIX 5: Corrected unnecessary underscores.
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(_UI.paddingM),
          margin: const EdgeInsets.only(bottom: _UI.paddingM),
          decoration: BoxDecoration(
            color: _cardBgColor,
            borderRadius: BorderRadius.circular(_UI.radiusL),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlaceholderLine(height: 10, width: 120),
                  const SizedBox(height: 12),
                  _buildPlaceholderLine(height: 18),
                  const SizedBox(height: 8),
                  _buildPlaceholderLine(height: 18, width: 100),
                  const SizedBox(height: 12),
                  _buildPlaceholderLine(height: 14),
                ],
              )),
              const SizedBox(width: _UI.paddingM),
              Container(width: 90, height: 110, decoration: BoxDecoration(
                color: _cardBgColor,
                borderRadius: BorderRadius.circular(_UI.radiusM)
              )),
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
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.all(_UI.paddingM),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: _UI.paddingM,
          mainAxisSpacing: _UI.paddingM,
          childAspectRatio: 0.9,
        ),
        itemCount: 8,
        // FIX 5: Corrected unnecessary underscores.
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: _cardBgColor,
            borderRadius: BorderRadius.circular(_UI.radiusL),
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
              const Icon(Icons.cloud_off, color: _secondaryTextColor, size: 50),
              const SizedBox(height: _UI.paddingM),
              const Text('An Error Occurred', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryTextColor)),
              const SizedBox(height: _UI.paddingS),
              Text(message, style: const TextStyle(color: _secondaryTextColor), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onRetry, child: const Text('Try Again'))
            ])));
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
            Icon(icon, color: _secondaryTextColor, size: 50),
            const SizedBox(height: _UI.paddingM),
            Text(message, style: const TextStyle(color: _secondaryTextColor, fontSize: 16)),
            const SizedBox(height: _UI.paddingS),
            const Text("Tap to refresh", style: TextStyle(color: _secondaryTextColor, fontSize: 12))
          ])),
    ));
  }
}

extension on PostsCubit {
  void loadMorePostsIfShould(int categoryId) {
    final s = state;
    s.whenOrNull(loaded: (posts, hasMore, _, currentCategoryId, _) {
      if (hasMore && currentCategoryId == categoryId) {
        loadMorePosts();
      }
    });
  }
}
