// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../widgets/app_drawer.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../models/post_model.dart';
import '../models/category_model.dart';
import '../routes/app_router.dart';

// --- New Modern UI Theme based on the demo image ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);
  
  static const Color primary = Color(0xFF4C6FFF); // Blue for category pills
  
  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusM = 12.0;
  static const double radiusL = 20.0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  Timer? _scrollDebounceTimer;
  bool _isLoadingMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PostsCubit>().loadPostsLazy();
        context.read<CategoriesCubit>().loadCategoriesIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 150), _handlePagination);
  }

  void _handlePagination() {
    if (!mounted || _isLoadingMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      final state = context.read<PostsCubit>().state;
      state.maybeWhen(
        loaded: (posts, hasReachedMax, currentPage, categoryId, searchQuery) {
          if (!hasReachedMax) {
            setState(() => _isLoadingMore = true);
            context.read<PostsCubit>().loadMorePosts().whenComplete(() {
              if (mounted) setState(() => _isLoadingMore = false);
            });
          }
        },
        orElse: () {},
      );
    }
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<PostsCubit>().loadPosts(refresh: true),
      context.read<CategoriesCubit>().refreshCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      // The AppBar is now part of the CustomScrollView for a more integrated feel
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: _AppTheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const _ModernAppBar(),
            const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
            const _HottestNewsSection(),
            const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
            const _ExploreSection(),
            const SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceL)),
            _ForYouSection(isLoadingMore: _isLoadingMore),
          ],
        ),
      ),
    );
  }
}

// --- New Screen Sections ---

class _ModernAppBar extends StatelessWidget {
  const _ModernAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(_AppTheme.spaceM, _AppTheme.spaceL, _AppTheme.spaceM, 0),
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
            _AppBarButton(icon: Icons.search, onPressed: () => AppNavigation.goToSearch(context)),
            const SizedBox(width: _AppTheme.spaceM),
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/logo.png'), // Local asset
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMore;
  const _SectionHeader({required this.title, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM, vertical: _AppTheme.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary),
          ),
          if (onSeeMore != null)
            TextButton(
              onPressed: onSeeMore,
              child: const Text('See More', style: TextStyle(color: _AppTheme.textSecondary, fontWeight: FontWeight.w500)),
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
          loaded: (posts, hasReachedMax, currentPage, categoryId, searchQuery) {
            if (posts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
            final hottestPosts = posts.take(5).toList();
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Hottest News', onSeeMore: () {}),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hottestPosts.length,
                      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
                      itemBuilder: (context, index) {
                        return _HottestNewsCard(post: hottestPosts[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (message) => SliverToBoxAdapter(child: Center(child: Text(message))),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
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
                      imageUrl: post.featuredImageUrl ?? 'https://via.placeholder.com/250x150',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: _AppTheme.spaceM,
                    left: _AppTheme.spaceM,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categoryName,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 12),
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
                    const SizedBox(height: _AppTheme.spaceS),
                    // Removed author details as per request
                    // Row(
                    //   children: [
                    //     const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3')),
                    //     const SizedBox(width: _AppTheme.spaceS),
                    //     Text(post.getAuthorName(), style: const TextStyle(color: _AppTheme.textSecondary)),
                    //     const Spacer(),
                    //     const Icon(Icons.more_horiz, color: _AppTheme.textSecondary),
                    //   ],
                    // ),
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
            if (categories.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Explore', onSeeMore: () => AppNavigation.goToAllCategories(context)),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _ExploreCategoryCircle(category: categories[index]);
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => AppNavigation.goToCategory(context, category.id, category.name),
                borderRadius: BorderRadius.circular(35),
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
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
  final bool isLoadingMore;
  const _ForYouSection({required this.isLoadingMore});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _ForYouSkeleton(),
          loading: () => const _ForYouSkeleton(),
          loaded: (posts, hasReachedMax, currentPage, categoryId, searchQuery) {
            if (posts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
            return SliverList.builder(
              itemCount: posts.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < posts.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(_AppTheme.spaceM, 0, _AppTheme.spaceM, _AppTheme.spaceM),
                    child: _ForYouPostCard(post: posts[index]),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator(color: _AppTheme.primary)),
                  );
                }
              },
            );
          },
          error: (message) => SliverToBoxAdapter(child: Center(child: Text(message))),
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
                      style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 12),
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
                      post.excerpt.rendered.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                      style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: _AppTheme.spaceS),
                    // Removed author details as per request
                    // Row(
                    //   children: [
                    //     const CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')),
                    //     const SizedBox(width: _AppTheme.spaceS),
                    //     Expanded(
                    //       child: Text(
                    //         post.getAuthorName(),
                    //         style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 13),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //     const Icon(Icons.more_horiz, color: _AppTheme.textSecondary),
                    //   ],
                    // ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- Skeleton Loaders ---

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
            const _SectionHeader(title: 'Hottest News'),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
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
                padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
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
            margin: const EdgeInsets.fromLTRB(_AppTheme.spaceM, 0, _AppTheme.spaceM, _AppTheme.spaceM),
            padding: const EdgeInsets.all(_AppTheme.spaceS),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_AppTheme.radiusM),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(height: 12, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(height: 16, color: Colors.white),
                      const SizedBox(height: _AppTheme.spaceS),
                      Container(height: 16, width: 150, color: Colors.white),
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
