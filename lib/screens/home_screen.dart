// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_card.dart';
import '../widgets/category_chip.dart';
import '../providers/posts_cubit.dart';
import '../providers/categories_cubit.dart';
import '../routes/app_router.dart';
import 'dart:async';

/// Home screen displaying latest posts and categories
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Lazy loading and visibility detection
  bool _categoriesVisible = false;
  bool _hasLoadedCategories = false;
  Timer? _scrollDebounceTimer;
  
  // Request deduplication
  bool _isLoadingMorePosts = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load only posts initially - categories will be loaded lazily
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use lazy loading for posts
      context.read<PostsCubit>().loadPostsLazy();
      
      // Don't load categories immediately - wait for user interaction
      _scheduleInitialCategoryLoad();
    });
  }
  
  /// Schedule category loading after a short delay to reduce startup requests
  void _scheduleInitialCategoryLoad() {
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted && !_hasLoadedCategories) {
        context.read<CategoriesCubit>().loadCategoriesIfNeeded();
        _hasLoadedCategories = true;
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }
  
  void _onScroll() {
    // Debounce scroll events to reduce excessive calls
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      _handleScrollEvents();
    });
  }
  
  void _handleScrollEvents() {
    if (!mounted) return;
    
    // Check if categories section is visible for lazy loading
    _checkCategoriesVisibility();
    
    // Handle pagination with deduplication
    _handlePagination();
  }
  
  void _checkCategoriesVisibility() {
    if (_scrollController.hasClients && !_hasLoadedCategories) {
      final scrollPosition = _scrollController.position.pixels;
      
      // Load categories when user starts scrolling or after initial delay
      if (scrollPosition > 50 || !_categoriesVisible) {
        _categoriesVisible = true;
        _hasLoadedCategories = true;
        context.read<CategoriesCubit>().loadCategoriesIfNeeded();
      }
    }
  }
  
  void _handlePagination() {
    if (_isLoadingMorePosts || !_scrollController.hasClients) return;
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final postsState = context.read<PostsCubit>().state;
      postsState.whenOrNull(
        loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
          if (hasMore && !_isLoadingMorePosts) {
            _isLoadingMorePosts = true;
            context.read<PostsCubit>().loadMorePosts().then((_) {
              _isLoadingMorePosts = false;
            });
          }
        },
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.appName,
        onSearchPressed: () {
          AppNavigation.goToSearch(context);
        },
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh posts first (higher priority)
          await context.read<PostsCubit>().loadPosts(refresh: true);
          
          // Then refresh categories if they were already loaded
          if (_hasLoadedCategories && mounted) {
            await context.read<CategoriesCubit>().refreshCategories();
          }
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildCategoriesSection(),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              // Show modern placeholder with rounded design
              if (!_hasLoadedCategories) {
                return _buildCategoriesPlaceholder(context);
              }
              return const SizedBox.shrink();
            },
            loading: () => _buildCategoriesLoading(),
            loaded: (categories) => _buildCategoriesList(categories),
            error: (message) => _buildCategoriesError(context, message),
          );
        },
      ),
    );
  }
  
  // Modern categories placeholder with rounded design
  Widget _buildCategoriesPlaceholder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: InkWell(
          onTap: () {
            _hasLoadedCategories = true;
            context.read<CategoriesCubit>().loadCategoriesIfNeeded();
          },
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Icon(
                    Icons.category_rounded,
                    size: AppConstants.iconSizeSmall,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'বিভাগসমূহ দেখুন',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'সকল বিভাগ ব্রাউজ করুন',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: AppConstants.iconSizeSmall,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern loading state for categories
  Widget _buildCategoriesLoading() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
      ),
      height: 56,
      child: const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // Modern error state for categories
  Widget _buildCategoriesError(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
                size: AppConstants.iconSizeSmall,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _hasLoadedCategories = true;
                  context.read<CategoriesCubit>().loadCategories();
                },
                child: const Text('পুনরায় চেষ্টা'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(List categories) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Icon(
                    Icons.category_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'বিভাগসমূহ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppConstants.paddingSmall,
                  ),
                  child: CategoryChip(
                    category: category,
                    showCount: true,
                    onTap: () {
                      AppNavigation.goToCategory(
                        context,
                        category.id,
                        category.name,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostsSection() {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildPostsLoading(),
          loading: () => _buildPostsLoading(),
          loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
            if (posts.isEmpty) {
              return _buildEmptyPosts(context);
            }
            
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingMedium,
                AppConstants.paddingSmall,
                AppConstants.paddingMedium,
                AppConstants.paddingMedium,
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
                            AppNavigation.goToPost(
                              context,
                              post.id,
                            );
                          },
                        ),
                      );
                    } else if (hasMore) {
                      return _buildLoadMoreIndicator();
                    }
                    return null;
                  },
                  childCount: posts.length + (hasMore ? 1 : 0),
                ),
              ),
            );
          },
          error: (message) => _buildPostsError(context, message),
        );
      },
    );
  }

  // Modern loading state for posts
  Widget _buildPostsLoading() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'পোস্ট লোড হচ্ছে...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern empty state for posts
  Widget _buildEmptyPosts(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(AppConstants.paddingLarge),
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                ),
                child: Icon(
                  Icons.article_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Text(
                'কোনো পোস্ট পাওয়া যায়নি',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'নতুন পোস্ট দেখতে রিফ্রেশ করুন',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              FilledButton.icon(
                onPressed: () => context.read<PostsCubit>().loadPosts(refresh: true),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('রিফ্রেশ করুন'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern error state for posts
  Widget _buildPostsError(BuildContext context, String message) {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(AppConstants.paddingLarge),
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                'কিছু সমস্যা হয়েছে',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              FilledButton.icon(
                onPressed: () => context.read<PostsCubit>().loadPosts(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('পুনরায় চেষ্টা'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern load more indicator
  Widget _buildLoadMoreIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingMedium,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Text(
                'আরো পোস্ট লোড হচ্ছে...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Featured posts section widget
class FeaturedPostsSection extends StatelessWidget {
  final List posts;
  final VoidCallback? onSeeAll;
  
  const FeaturedPostsSection({
    super.key,
    required this.posts,
    this.onSeeAll,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (posts.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ফিচার্ড পোস্ট',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('সব দেখুন'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(
                    right: AppConstants.paddingMedium,
                  ),
                  child: PostCard(
                    post: post,
                    isHorizontal: true,
                    onTap: () {
                      AppNavigation.goToPost(context, post.id);
                    },
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

/// Recent posts section widget
class RecentPostsSection extends StatelessWidget {
  final List posts;
  final VoidCallback? onSeeAll;
  
  const RecentPostsSection({
    super.key,
    required this.posts,
    this.onSeeAll,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (posts.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'সাম্প্রতিক পোস্ট',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('সব দেখুন'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          ...posts.take(5).map(
            (post) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: PostCard(
                post: post,
                isHorizontal: true,
                onTap: () {
                  AppNavigation.goToPost(context, post.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}