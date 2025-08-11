// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Add this dependency for the shimmer effect
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_card.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../routes/app_router.dart';
import 'dart:async';

// --- A centralized theme class for a modern, consistent UI ---
class _AppTheme {
  // Colors
  static const Color primary = Color(0xFF0D9488); // Teal
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFDC2626);

  // Placeholders
  static const Color placeholderBase = Color(0xFFE2E8F0);
  static const Color placeholderHighlight = Color(0xFFF1F5F9);

  // Spacing & Radii
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollDebounceTimer;
  bool _isLoadingMorePosts = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsCubit>().loadPostsLazy();
      // Lazily load categories after a short delay to prioritize post rendering.
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) context.read<CategoriesCubit>().loadCategoriesIfNeeded();
      });
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }
  
  void _onScroll() {
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), _handlePagination);
  }
  
  void _handlePagination() {
    if (!_isLoadingMorePosts && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      final postsState = context.read<PostsCubit>().state;
      // CORRECTED: Use .whenOrNull to safely access the loaded state
      postsState.whenOrNull(
        loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
          if (hasMore) {
            _isLoadingMorePosts = true;
            context.read<PostsCubit>().loadMorePosts().whenComplete(() {
              if (mounted) {
                _isLoadingMorePosts = false;
              }
            });
          }
        },
      );
    }
  }

  Future<void> _onRefresh() async {
    final postsFuture = context.read<PostsCubit>().loadPosts(refresh: true);
    final categoriesFuture = context.read<CategoriesCubit>().refreshCategories();
    await Future.wait([postsFuture, categoriesFuture]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppConstants.appName, onSearchPressed: () => AppNavigation.goToSearch(context)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: _AppTheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: const [
            SliverToBoxAdapter(child: SizedBox(height: _AppTheme.spaceS)),
            _CategoriesSection(),
            _PostsSection(),
          ],
        ),
      ),
    );
  }
}

// --- Section Widgets ---

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () => _CategoriesPlaceholder(onTap: () => context.read<CategoriesCubit>().loadCategoriesIfNeeded()),
            loading: () => const _CategoriesLoading(),
            loaded: (categories) => categories.isEmpty ? const SizedBox.shrink() : _CategoriesList(categories: categories),
            error: (message) => _CategoriesError(message: message, onRetry: () => context.read<CategoriesCubit>().loadCategories()),
          );
        },
      ),
    );
  }
}

class _PostsSection extends StatelessWidget {
  const _PostsSection();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _PostsLoading(),
          loading: () => const _PostsLoading(),
          loaded: (posts, hasMore, _, __, ___) {
            if (posts.isEmpty) return const _EmptyPosts();
            return SliverPadding(
              padding: const EdgeInsets.all(_AppTheme.spaceM),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return PostCard(post: posts[index], onTap: () => AppNavigation.goToPost(context, posts[index].id));
                  } else {
                    return const _LoadMoreIndicator();
                  }
                },
                separatorBuilder: (context, index) => const SizedBox(height: _AppTheme.spaceM),
                itemCount: posts.length + (hasMore ? 1 : 0),
              ),
            );
          },
          error: (message) => _PostsError(message: message, onRetry: () => context.read<PostsCubit>().loadPosts()),
        );
      },
    );
  }
}

// --- Category Components ---

class _CategoriesList extends StatelessWidget {
  final List categories;
  const _CategoriesList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(icon: Icons.category_outlined, title: 'বিভাগসমূহ'),
        const SizedBox(height: _AppTheme.spaceS),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: _AppTheme.spaceS),
                child: _CategoryChip(
                  label: category.name,
                  count: category.count,
                  onTap: () => AppNavigation.goToCategory(context, category.id, category.name),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: CircleAvatar(
        backgroundColor: _AppTheme.primary,
        child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
      label: Text(label),
      backgroundColor: _AppTheme.surfaceContainer,
      labelStyle: const TextStyle(color: _AppTheme.textPrimary, fontWeight: FontWeight.w600),
      side: const BorderSide(color: _AppTheme.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceS),
    );
  }
}

// --- Helper & State Widgets ---

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
      child: Row(
        children: [
          Icon(icon, color: _AppTheme.primary, size: 20),
          const SizedBox(width: _AppTheme.spaceS),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _CategoriesPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _CategoriesPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM, vertical: _AppTheme.spaceS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        child: Container(
          padding: const EdgeInsets.all(_AppTheme.spaceM),
          decoration: BoxDecoration(
            color: _AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(_AppTheme.radiusL),
            border: Border.all(color: _AppTheme.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.category_outlined, color: _AppTheme.textSecondary),
              SizedBox(width: _AppTheme.spaceM),
              Expanded(child: Text('বিভাগসমূহ দেখুন', style: TextStyle(fontWeight: FontWeight.bold, color: _AppTheme.textSecondary))),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesLoading extends StatelessWidget {
  const _CategoriesLoading();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.placeholderBase,
      highlightColor: _AppTheme.placeholderHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(icon: Icons.category_outlined, title: 'বিভাগসমূহ'),
          const SizedBox(height: _AppTheme.spaceS),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
              itemCount: 5,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: _AppTheme.spaceS),
                child: Chip(label: Container(width: 80, height: 20, color: _AppTheme.surface)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _CategoriesError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM, vertical: _AppTheme.spaceS),
      child: Container(
        padding: const EdgeInsets.all(_AppTheme.spaceM),
        decoration: BoxDecoration(color: _AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: _AppTheme.error),
            const SizedBox(width: _AppTheme.spaceM),
            Expanded(child: Text(message, style: const TextStyle(color: _AppTheme.error, fontWeight: FontWeight.w500))),
            TextButton(onPressed: onRetry, child: const Text('পুনরায় চেষ্টা করুন', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}

class _PostsLoading extends StatelessWidget {
  const _PostsLoading();
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(5, (_) => const _PostCardPlaceholder()),
        ),
      ),
    );
  }
}

class _PostCardPlaceholder extends StatelessWidget {
  const _PostCardPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.placeholderBase,
      highlightColor: _AppTheme.placeholderHighlight,
      child: Container(
        margin: const EdgeInsets.only(bottom: _AppTheme.spaceM),
        decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusL)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180, decoration: const BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(_AppTheme.radiusL)))),
            Padding(
              padding: const EdgeInsets.all(_AppTheme.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: double.infinity, color: _AppTheme.surface),
                  const SizedBox(height: _AppTheme.spaceS),
                  Container(height: 20, width: 200, color: _AppTheme.surface),
                  const SizedBox(height: _AppTheme.spaceM),
                  Container(height: 16, width: 100, color: _AppTheme.surface),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPosts extends StatelessWidget {
  const _EmptyPosts();
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 60, color: _AppTheme.textSecondary),
            const SizedBox(height: _AppTheme.spaceM),
            const Text('কোনো পোস্ট পাওয়া যায়নি', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
            const SizedBox(height: _AppTheme.spaceS),
            const Text('নতুন পোস্ট দেখতে রিফ্রেশ করুন', style: TextStyle(fontSize: 14, color: _AppTheme.textSecondary)),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton.icon(
              onPressed: () => context.read<PostsCubit>().loadPosts(refresh: true),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('রিফ্রেশ করুন'),
              style: ElevatedButton.styleFrom(backgroundColor: _AppTheme.primary, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _PostsError({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(_AppTheme.spaceL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 60, color: _AppTheme.error),
              const SizedBox(height: _AppTheme.spaceM),
              const Text('কিছু সমস্যা হয়েছে', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
              const SizedBox(height: _AppTheme.spaceS),
              Text(message, style: const TextStyle(fontSize: 14, color: _AppTheme.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: _AppTheme.spaceL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('পুনরায় চেষ্টা করুন'),
                style: ElevatedButton.styleFrom(backgroundColor: _AppTheme.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: _AppTheme.spaceM),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 3, color: _AppTheme.primary),
        ),
      ),
    );
  }
}