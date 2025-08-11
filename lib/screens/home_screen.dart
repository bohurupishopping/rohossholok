// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_card.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../routes/app_router.dart';
import 'dart:async';

// --- Ultra Clean Modern Theme ---
class _CleanTheme {
  // Pure Minimal Color Palette
  static const Color primary = Color(0xFF6366F1); // Clean Indigo
  static const Color primarySoft = Color(0xFFEEF2FF);
  static const Color secondary = Color(0xFF10B981);
  static const Color secondarySoft = Color(0xFFF0FDF4);
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentSoft = Color(0xFFFEF3C7);
  
  // Clean Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // Pure Surface Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF3F4F6);
  
  // Status Colors (Soft)
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFEF2F2);
  
  // Shimmer (Ultra Subtle)
  static const Color shimmerBase = Color(0xFFF9FAFB);
  static const Color shimmerHighlight = Color(0xFFFFFFFF);
  
  // Typography (Clean Scale)
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeTitle = 24.0;
  
  // Perfect Spacing System
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;
  static const double spaceXXL = 24.0;
  static const double spaceXXXL = 32.0;
  
  // Pure Rounded System
  static const double radiusXS = 6.0;
  static const double radiusM = 16.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 28.0;
  static const double radiusFull = 50.0;
  
  // Icon Sizes (Compact)
  static const double iconXS = 12.0;
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconXL = 32.0;
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
        Timer(const Duration(milliseconds: 600), () {
          if (mounted) context.read<CategoriesCubit>().loadCategoriesIfNeeded();
        });
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
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 120), _handlePagination);
  }
  
  void _handlePagination() {
    if (!mounted || _isLoadingMore) return;
    
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 250) {
      final postsState = context.read<PostsCubit>().state;
      postsState.whenOrNull(
        loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
          if (hasMore && !_isLoadingMore) {
            setState(() => _isLoadingMore = true);
            context.read<PostsCubit>().loadMorePosts().whenComplete(() {
              if (mounted) setState(() => _isLoadingMore = false);
            });
          }
        },
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
      backgroundColor: _CleanTheme.background,
      appBar: CustomAppBar(
        title: AppConstants.appName,
        onSearchPressed: () => AppNavigation.goToSearch(context),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: _CleanTheme.primary,
        backgroundColor: _CleanTheme.surface,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: const [
            SliverToBoxAdapter(child: SizedBox(height: _CleanTheme.spaceL)),
            _CleanCategoriesSection(),
            SliverToBoxAdapter(child: SizedBox(height: _CleanTheme.spaceXL)),
            _CleanPostsSection(),
            SliverToBoxAdapter(child: SizedBox(height: _CleanTheme.spaceXXXL)),
          ],
        ),
      ),
    );
  }
}

// --- Ultra Clean Categories Section ---
class _CleanCategoriesSection extends StatelessWidget {
  const _CleanCategoriesSection();
  
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () => _CleanCategoriesPlaceholder(
              onTap: () => context.read<CategoriesCubit>().loadCategoriesIfNeeded(),
            ),
            loading: () => const _CleanCategoriesLoading(),
            loaded: (categories) => categories.isEmpty 
                ? const SizedBox.shrink() 
                : _CleanCategoriesList(categories: categories),
            error: (message) => _CleanCategoriesError(
              message: message,
              onRetry: () => context.read<CategoriesCubit>().loadCategories(),
            ),
          );
        },
      ),
    );
  }
}

class _CleanCategoriesList extends StatelessWidget {
  final List categories;
  const _CleanCategoriesList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CleanSectionTitle(
            title: 'বিভাগসমূহ',
            subtitle: '${categories.length}টি বিভাগ',
            icon: Icons.apps_rounded,
          ),
          const SizedBox(height: _CleanTheme.spaceM),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : _CleanTheme.spaceM,
                  ),
                  child: _CleanCategoryCard(
                    label: category.name,
                    count: category.count,
                    index: index,
                    onTap: () => AppNavigation.goToCategory(
                      context, 
                      category.id, 
                      category.name,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanCategoryCard extends StatelessWidget {
  final String label;
  final int count;
  final int index;
  final VoidCallback onTap;
  
  const _CleanCategoryCard({
    required this.label,
    required this.count,
    required this.index,
    required this.onTap,
  });

  Color get _categoryColor {
    final colors = [
      _CleanTheme.primary,
      _CleanTheme.secondary,
      _CleanTheme.accent,
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  Color get _categorySoftColor {
    final colors = [
      _CleanTheme.primarySoft,
      _CleanTheme.secondarySoft,
      _CleanTheme.accentSoft,
      const Color(0xFFFDF2F8),
      const Color(0xFFF5F3FF),
      const Color(0xFFECFEFF),
    ];
    return colors[index % colors.length];
  }

  IconData get _categoryIcon {
    final icons = [
      Icons.article_rounded,
      Icons.trending_up_rounded,
      Icons.sports_soccer_rounded,
      Icons.business_center_rounded,
      Icons.science_rounded,
      Icons.language_rounded,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_CleanTheme.radiusL),
        child: Container(
          width: 90,
          decoration: BoxDecoration(
            color: _categorySoftColor,
            borderRadius: BorderRadius.circular(_CleanTheme.radiusL),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _CleanTheme.iconXL,
                height: _CleanTheme.iconXL,
                decoration: BoxDecoration(
                  color: _categoryColor,
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
                ),
                child: Icon(
                  _categoryIcon,
                  color: Colors.white,
                  size: _CleanTheme.iconS,
                ),
              ),
              const SizedBox(height: _CleanTheme.spaceS),
              Text(
                label,
                style: const TextStyle(
                  fontSize: _CleanTheme.fontSizeXS,
                  fontWeight: FontWeight.w600,
                  color: _CleanTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: _CleanTheme.spaceXXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _CleanTheme.spaceS,
                  vertical: _CleanTheme.spaceXXS,
                ),
                decoration: BoxDecoration(
                  color: _categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusFull),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: _CleanTheme.fontSizeXS,
                    fontWeight: FontWeight.bold,
                    color: _categoryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Ultra Clean Posts Section ---
class _CleanPostsSection extends StatelessWidget {
  const _CleanPostsSection();
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _CleanPostsLoading(),
          loading: () => const _CleanPostsLoading(),
          loaded: (posts, hasMore, _, _, _) {
            if (posts.isEmpty) return const _CleanEmptyPosts();
            
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
                child: Column(
                  children: [
                    _CleanSectionTitle(
                      title: 'সর্বশেষ সংবাদ',
                      subtitle: '${posts.length}টি পোস্ট',
                      icon: Icons.feed_rounded,
                    ),
                    const SizedBox(height: _CleanTheme.spaceM),
                    Container(
                      decoration: BoxDecoration(
                        color: _CleanTheme.surface,
                        borderRadius: BorderRadius.circular(_CleanTheme.radiusXL),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length + (hasMore ? 1 : 0),
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
                          color: _CleanTheme.border,
                        ),
                        itemBuilder: (context, index) {
                          if (index < posts.length) {
                            return PostCard(
                              post: posts[index],
                              onTap: () => AppNavigation.goToPost(context, posts[index].id),
                            );
                          } else {
                            return const _CleanLoadMoreIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (message) => _CleanPostsError(
            message: message,
            onRetry: () => context.read<PostsCubit>().loadPosts(),
          ),
        );
      },
    );
  }
}

// --- Clean Helper Widgets ---
class _CleanSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  
  const _CleanSectionTitle({
    required this.title,
    this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _CleanTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
          ),
          child: Icon(
            icon,
            color: _CleanTheme.primary,
            size: _CleanTheme.iconM,
          ),
        ),
        const SizedBox(width: _CleanTheme.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: _CleanTheme.fontSizeXL,
                  fontWeight: FontWeight.bold,
                  color: _CleanTheme.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: _CleanTheme.spaceXXS),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: _CleanTheme.fontSizeS,
                    color: _CleanTheme.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// --- Loading States ---
class _CleanCategoriesLoading extends StatelessWidget {
  const _CleanCategoriesLoading();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
      child: Shimmer.fromColors(
        baseColor: _CleanTheme.shimmerBase,
        highlightColor: _CleanTheme.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _CleanTheme.surface,
                    borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
                  ),
                ),
                const SizedBox(width: _CleanTheme.spaceM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _CleanTheme.surface,
                        borderRadius: BorderRadius.circular(_CleanTheme.radiusXS),
                      ),
                    ),
                    const SizedBox(height: _CleanTheme.spaceXS),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _CleanTheme.surface,
                        borderRadius: BorderRadius.circular(_CleanTheme.radiusXS),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: _CleanTheme.spaceM),
            SizedBox(
              height: 100,
              child: Row(
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 90,
                    margin: EdgeInsets.only(
                      right: index == 3 ? 0 : _CleanTheme.spaceM,
                    ),
                    decoration: BoxDecoration(
                      color: _CleanTheme.surface,
                      borderRadius: BorderRadius.circular(_CleanTheme.radiusL),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CleanPostsLoading extends StatelessWidget {
  const _CleanPostsLoading();
  
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
        child: Shimmer.fromColors(
          baseColor: _CleanTheme.shimmerBase,
          highlightColor: _CleanTheme.shimmerHighlight,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _CleanTheme.surface,
                      borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
                    ),
                  ),
                  const SizedBox(width: _CleanTheme.spaceM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 18,
                        decoration: BoxDecoration(
                          color: _CleanTheme.surface,
                          borderRadius: BorderRadius.circular(_CleanTheme.radiusXS),
                        ),
                      ),
                      const SizedBox(height: _CleanTheme.spaceXS),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _CleanTheme.surface,
                          borderRadius: BorderRadius.circular(_CleanTheme.radiusXS),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _CleanTheme.spaceM),
              Container(
                decoration: BoxDecoration(
                  color: _CleanTheme.surface,
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusXL),
                ),
                child: Column(
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: 100,
                      margin: const EdgeInsets.all(_CleanTheme.spaceL),
                      decoration: BoxDecoration(
                        color: _CleanTheme.shimmerBase,
                        borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Error & Empty States ---
class _CleanCategoriesPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _CleanCategoriesPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_CleanTheme.radiusXL),
          child: Container(
            padding: const EdgeInsets.all(_CleanTheme.spaceL),
            decoration: BoxDecoration(
              color: _CleanTheme.surface,
              borderRadius: BorderRadius.circular(_CleanTheme.radiusXL),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.apps_rounded,
                  color: _CleanTheme.textSecondary,
                  size: _CleanTheme.iconM,
                ),
                SizedBox(width: _CleanTheme.spaceM),
                Expanded(
                  child: Text(
                    'বিভাগসমূহ দেখুন',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _CleanTheme.textSecondary,
                      fontSize: _CleanTheme.fontSizeM,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: _CleanTheme.iconXS,
                  color: _CleanTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CleanCategoriesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const _CleanCategoriesError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _CleanTheme.spaceL),
      child: Container(
        padding: const EdgeInsets.all(_CleanTheme.spaceL),
        decoration: BoxDecoration(
          color: _CleanTheme.errorSoft,
          borderRadius: BorderRadius.circular(_CleanTheme.radiusXL),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _CleanTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: _CleanTheme.error,
                size: _CleanTheme.iconM,
              ),
            ),
            const SizedBox(width: _CleanTheme.spaceM),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: _CleanTheme.error,
                  fontWeight: FontWeight.w500,
                  fontSize: _CleanTheme.fontSizeM,
                ),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                backgroundColor: _CleanTheme.error.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusM),
                ),
              ),
              child: const Text(
                'পুনরায় চেষ্টা',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _CleanTheme.fontSizeS,
                  color: _CleanTheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CleanEmptyPosts extends StatelessWidget {
  const _CleanEmptyPosts();
  
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(_CleanTheme.spaceXXL),
          padding: const EdgeInsets.all(_CleanTheme.spaceXXXL),
          decoration: BoxDecoration(
            color: _CleanTheme.surface,
            borderRadius: BorderRadius.circular(_CleanTheme.radiusXXL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _CleanTheme.primarySoft,
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusXXL),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  size: 40,
                  color: _CleanTheme.primary,
                ),
              ),
              const SizedBox(height: _CleanTheme.spaceXL),
              const Text(
                'কোনো পোস্ট পাওয়া যায়নি',
                style: TextStyle(
                  fontSize: _CleanTheme.fontSizeXXL,
                  fontWeight: FontWeight.bold,
                  color: _CleanTheme.textPrimary,
                ),
              ),
              const SizedBox(height: _CleanTheme.spaceS),
              const Text(
                'নতুন পোস্ট দেখতে রিফ্রেশ করুন',
                style: TextStyle(
                  fontSize: _CleanTheme.fontSizeM,
                  color: _CleanTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _CleanTheme.spaceXXL),
              ElevatedButton(
                onPressed: () => context.read<PostsCubit>().loadPosts(refresh: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _CleanTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _CleanTheme.spaceXXL,
                    vertical: _CleanTheme.spaceL,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_CleanTheme.radiusFull),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'রিফ্রেশ করুন',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _CleanTheme.fontSizeM,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CleanPostsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const _CleanPostsError({
    required this.message,
    required this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(_CleanTheme.spaceXXL),
          padding: const EdgeInsets.all(_CleanTheme.spaceXXXL),
          decoration: BoxDecoration(
            color: _CleanTheme.surface,
            borderRadius: BorderRadius.circular(_CleanTheme.radiusXXL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _CleanTheme.errorSoft,
                  borderRadius: BorderRadius.circular(_CleanTheme.radiusXXL),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 40,
                  color: _CleanTheme.error,
                ),
              ),
              const SizedBox(height: _CleanTheme.spaceXL),
              const Text(
                'কিছু সমস্যা হয়েছে',
                style: TextStyle(
                  fontSize: _CleanTheme.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: _CleanTheme.textPrimary,
                ),
              ),
              const SizedBox(height: _CleanTheme.spaceS),
              Text(
                message,
                style: const TextStyle(
                  fontSize: _CleanTheme.fontSizeM,
                  color: _CleanTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _CleanTheme.spaceXXL),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _CleanTheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _CleanTheme.spaceXXL,
                    vertical: _CleanTheme.spaceL,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_CleanTheme.radiusFull),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'পুনরায় চেষ্টা করুন',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _CleanTheme.fontSizeM,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CleanLoadMoreIndicator extends StatelessWidget {
  const _CleanLoadMoreIndicator();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_CleanTheme.spaceXL),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(_CleanTheme.spaceS),
          decoration: BoxDecoration(
            color: _CleanTheme.primarySoft,
            borderRadius: BorderRadius.circular(_CleanTheme.radiusFull),
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: _CleanTheme.primary,
          ),
        ),
      ),
    );
  }
}
