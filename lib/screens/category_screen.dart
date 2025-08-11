import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
import '../providers/posts_cubit.dart';

import '../providers/categories_cubit.dart';
import '../models/category_model.dart';

import '../routes/app_router.dart';

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
    
    // Load posts for this category
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final postsState = context.read<PostsCubit>().state;
      postsState.whenOrNull(
        loaded: (posts, hasMore, currentPage, categoryId, searchQuery) {
          if (hasMore && categoryId == widget.categoryId) {
            context.read<PostsCubit>().loadMorePosts();
          }
        },
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.categoryName,
        onSearchPressed: () {
          AppNavigation.goToSearch(context);
        },
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PostsCubit>().filterByCategory(widget.categoryId);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildCategoryInfo(),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryInfo() {
    return SliverToBoxAdapter(
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return state.whenOrNull(
            loaded: (categories) {
              CategoryModel? category;
              try {
                category = categories.firstWhere(
                  (cat) => cat.id == widget.categoryId,
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
              
              return _buildCategoryHeader(category);
            },
          ) ?? const SizedBox.shrink();
        },
      ),
    );
  }
  
  Widget _buildCategoryHeader(dynamic category) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.folder,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  category.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            '${category.count} টি পোস্ট',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (category.description?.isNotEmpty == true) ...
          [
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              category.description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
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
            // Only show posts if they're for the current category
            if (categoryId != widget.categoryId) {
              return const SliverFillRemaining(
                child: Center(child: LoadingSpinner()),
              );
            }
            
            if (posts.isEmpty) {
              return SliverFillRemaining(
                child: NoPostsWidget(
                  onRefresh: () {
                    context.read<PostsCubit>().filterByCategory(widget.categoryId);
                  },
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
              onRetry: () => context.read<PostsCubit>().filterByCategory(
                widget.categoryId,
              ),
            ),
          ),
        );
      },
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
    
    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().loadCategories();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'সব বিভাগ',
        showSearch: false,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CategoriesCubit>().loadCategories();
        },
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: LoadingSpinner()),
              loading: () => const Center(child: LoadingSpinner()),
              loaded: (categories) => _buildCategoriesGrid(categories),
              error: (message) => AppErrorWidget(
                message: message,
                onRetry: () => context.read<CategoriesCubit>().loadCategories(),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildCategoriesGrid(List categories) {
    if (categories.isEmpty) {
      return const NoCategoriesWidget();
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }
  
  Widget _buildCategoryCard(dynamic category) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          AppNavigation.goToCategory(
            context,
            category.id,
            category.name,
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder,
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                category.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                '${category.count} টি পোস্ট',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}