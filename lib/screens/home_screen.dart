import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
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
          if (mounted && _hasLoadedCategories) {
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
              // Show placeholder or load categories lazily when visible
              if (!_hasLoadedCategories) {
                return GestureDetector(
                  onTap: () {
                    _hasLoadedCategories = true;
                    context.read<CategoriesCubit>().loadCategoriesIfNeeded();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(AppConstants.paddingMedium),
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          'বিভাগসমূহ দেখুন',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: SizedBox(
                height: 40,
                child: LoadingSpinner(),
              ),
            ),
            loaded: (categories) => _buildCategoriesList(categories),
            error: (message) => Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: AppErrorWidget(
                message: message,
                onRetry: () {
                  _hasLoadedCategories = true;
                  context.read<CategoriesCubit>().loadCategories();
                },
                showRetryButton: true,
              ),
            ),
          );
        },
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
            child: Text(
              'বিভাগসমূহ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          SizedBox(
            height: 40,
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
          initial: () => const SliverFillRemaining(
            child: Center(child: LoadingSpinner()),
          ),
          loading: () => const SliverFillRemaining(
            child: Center(child: LoadingSpinner()),
          ),
          loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
            if (posts.isEmpty) {
              return SliverFillRemaining(
                child: NoPostsWidget(
                  onRefresh: () => context.read<PostsCubit>().loadPosts(refresh: true),
                ),
              );
            }
            
            return SliverPadding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppConstants.paddingMedium,
                        ),
                        child: Center(child: LoadingSpinner()),
                      );
                    }
                    return null;
                  },
                  childCount: posts.length + (hasMore ? 1 : 0),
                ),
              ),
            );
          },
          error: (message) => SliverFillRemaining(
            child: AppErrorWidget(
              message: message,
              onRetry: () => context.read<PostsCubit>().loadPosts(),
            ),
          ),
        );
      },
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