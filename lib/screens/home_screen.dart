// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/app_drawer.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../models/post_model.dart';
import '../models/category_model.dart';
import '../routes/app_router.dart';

// --- Theme (Unchanged) ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const Color primary = Color(0xFF4C6FFF);

  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusM = 12.0;
  static const double radiusL = 20.0;
}

// --- Main Screen Widget ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Load initial data after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PostsCubit>().loadPostsLazy();
        context.read<CategoriesCubit>().loadCategoriesIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Handles scroll events to trigger pagination.
  void _onScroll() {
    final position = _scrollController.position;
    // Trigger fetch when user is near the end of the list.
    if (position.pixels >= position.maxScrollExtent - 400) {
      // Directly call the cubit to load more posts.
      // The cubit itself should handle preventing duplicate requests.
      context.read<PostsCubit>().loadMorePosts();
    }
  }

  /// Handles pull-to-refresh.
  Future<void> _onRefresh() async {
    // Await both futures to complete in parallel.
    await Future.wait([
      context.read<PostsCubit>().loadPosts(refresh: true),
      context.read<CategoriesCubit>().refreshCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final bool shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('আপনি কি অ্যাপটি বন্ধ করতে চান?'),
                content: const Text('অ্যাপটি বন্ধ করতে নিশ্চিত?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('না'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('হ্যাঁ'),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldPop) {
          SystemNavigator.pop();
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
              slivers: const [
                _ModernAppBar(),
                SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
                _HottestNewsSection(),
                SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
                _ExploreSection(),
                SliverToBoxAdapter(
                    child: _SectionHeader(title: 'For You')), // Moved header here
                SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceS)),
                _ForYouSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- New Screen Sections (All optimized with const constructors) ---

class _ModernAppBar extends StatelessWidget {
  const _ModernAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
          _AppTheme.spaceM, _AppTheme.spaceL, _AppTheme.spaceM, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            _AppBarButton(
              icon: Icons.menu,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const Spacer(),
            _AppBarButton(icon: Icons.notifications_none, onPressed: () {}),
            const SizedBox(width: _AppTheme.spaceS),
            _AppBarButton(
                icon: Icons.search,
                onPressed: () => AppNavigation.goToSearch(context)),
            const SizedBox(width: _AppTheme.spaceM),
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMore;
  const _SectionHeader({required this.title, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _AppTheme.spaceM, vertical: _AppTheme.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _AppTheme.textPrimary),
          ),
          if (onSeeMore != null)
            TextButton(
              onPressed: onSeeMore,
              child: const Text('See More',
                  style: TextStyle(
                      color: _AppTheme.textSecondary,
                      fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

class _HottestNewsSection extends StatelessWidget {
  const _HottestNewsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _HottestNewsSkeleton(),
          loading: () => const _HottestNewsSkeleton(),
          loaded: (posts, _, __, ___, ____) {
            if (posts.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            final hottestPosts = posts.take(5).toList();
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Hottest Stories', onSeeMore: () {}),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hottestPosts.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: _AppTheme.spaceM),
                      itemBuilder: (context, index) {
                        return _HottestNewsCard(post: hottestPosts[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (message) =>
              SliverToBoxAdapter(child: Center(child: Text(message))),
        );
      },
    );
  }
}

class _HottestNewsCard extends StatelessWidget {
  final PostModel post;
  const _HottestNewsCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final categoryName = post.getCategoryNames().firstOrNull ?? 'General';

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: _AppTheme.spaceM),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(_AppTheme.radiusL),
                      topRight: Radius.circular(_AppTheme.radiusL),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          post.featuredImageUrl ?? 'https://via.placeholder.com/250x150',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: _AppTheme.spaceM,
                    left: _AppTheme.spaceM,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(_AppTheme.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔥 Trending No.1 • ${post.getFormattedDate()}',
                      style: const TextStyle(
                          color: _AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: _AppTheme.spaceS),
                    Text(
                      post.title.rendered,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreSection extends StatelessWidget {
  const _ExploreSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _ExploreSkeleton(),
          loading: () => const _ExploreSkeleton(),
          loaded: (categories) {
            if (categories.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                      title: 'Explore',
                      onSeeMore: () =>
                          AppNavigation.goToAllCategories(context)),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: _AppTheme.spaceM),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _ExploreCategoryCircle(
                            category: categories[index]);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          error: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        );
      },
    );
  }
}

class _ExploreCategoryCircle extends StatelessWidget {
  final CategoryModel category;
  const _ExploreCategoryCircle({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: _AppTheme.spaceM),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => AppNavigation.goToCategory(
                    context, category.id, category.name),
                borderRadius: BorderRadius.circular(35),
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: _AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForYouSection extends StatelessWidget {
  const _ForYouSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _ForYouSkeleton(),
          loading: () => const _ForYouSkeleton(),
          loaded: (posts, hasReachedMax, _, __, ___) {
            if (posts.isEmpty) {
              return const SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text("No posts found."),
              )));
            }
            // Add 1 to the item count for the loading indicator if we haven't reached the max.
            final itemCount = posts.length + (hasReachedMax ? 0 : 1);
            return SliverList.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // If it's the last item and we haven't reached the max, show a loader.
                if (index >= posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                        child: CircularProgressIndicator(color: _AppTheme.primary)),
                  );
                }
                // Otherwise, show the post card.
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                      _AppTheme.spaceM, 0, _AppTheme.spaceM, _AppTheme.spaceM),
                  child: _ForYouPostCard(post: posts[index]),
                );
              },
            );
          },
          error: (message) =>
              SliverToBoxAdapter(child: Center(child: Text(message))),
        );
      },
    );
  }
}

class _ForYouPostCard extends StatelessWidget {
  final PostModel post;
  const _ForYouPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final categoryName = post.getCategoryNames().firstOrNull ?? 'General';
    // This expensive operation is better done in the data layer (e.g., PostModel constructor)
    // but is kept here to match the original functionality.
    final cleanExcerpt = post.excerpt.rendered.replaceAll(RegExp(r'<[^>]*>'), '');

    return Container(
      padding: const EdgeInsets.all(_AppTheme.spaceS),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusM),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(_AppTheme.radiusM),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$categoryName • ${post.getFormattedDate()}',
                      style: const TextStyle(
                          color: _AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: _AppTheme.spaceS),
                    Text(
                      post.title.rendered,
                      style: const TextStyle(
                        color: _AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: _AppTheme.spaceS),
                    Text(
                      cleanExcerpt,
                      style: const TextStyle(
                          color: _AppTheme.textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: _AppTheme.spaceM),
              ClipRRect(
                borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                child: CachedNetworkImage(
                  imageUrl: post.featuredImageUrl ??
                      'https://via.placeholder.com/100x100',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Skeleton Loaders (Optimized with const constructors) ---

class _HottestNewsSkeleton extends StatelessWidget {
  const _HottestNewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: _AppTheme.shimmerBase,
        highlightColor: _AppTheme.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Hottest Stories'),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding:
                    const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
                itemBuilder: (context, index) {
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: _AppTheme.spaceM),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_AppTheme.radiusL),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreSkeleton extends StatelessWidget {
  const _ExploreSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: _AppTheme.shimmerBase,
        highlightColor: _AppTheme.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Explore'),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: _AppTheme.spaceM),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ForYouSkeleton extends StatelessWidget {
  const _ForYouSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: _AppTheme.shimmerBase,
          highlightColor: _AppTheme.shimmerHighlight,
          child: Container(
            margin: const EdgeInsets.fromLTRB(
                _AppTheme.spaceM, 0, _AppTheme.spaceM, _AppTheme.spaceM),
            padding: const EdgeInsets.all(_AppTheme.spaceS),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_AppTheme.radiusM),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(height: 16, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(
                          height: 16,
                          width: 150,
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 4)),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
