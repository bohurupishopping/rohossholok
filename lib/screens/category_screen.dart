// ignore_for_file: deprecated_member_use

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
    _scrollController.removeListener(_onScroll);
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
          physics: const BouncingScrollPhysics(),
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
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.folder_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.article_rounded,
                              color: theme.colorScheme.onSecondaryContainer,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${category.count} টি পোস্ট',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (category.description?.isNotEmpty == true) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: theme.colorScheme.onTertiaryContainer,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              sliver: SliverList.builder(
                itemCount: posts.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    return Container(
                      margin: const EdgeInsets.only(
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
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingLarge,
                      ),
                      child: const Center(child: LoadingSpinner()),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
        childAspectRatio: 1.3,
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
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppNavigation.goToCategory(
            context,
            category.id,
            category.name,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.folder_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  category.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.article_rounded,
                        color: theme.colorScheme.onSecondaryContainer,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${category.count}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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