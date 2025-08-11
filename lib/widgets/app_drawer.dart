import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../routes/app_router.dart';
import '../providers/categories_cubit.dart';
import '../models/category_model.dart';

/// Main navigation drawer for the app
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMainMenuItems(context),
                const Divider(),
                _buildCategoriesSection(context),
                const Divider(),
                _buildFooterItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            child: Icon(
              Icons.article,
              size: 32,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            AppConstants.appName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'বাংলা ব্লগ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildDrawerItem(
          context: context,
          icon: Icons.home,
          title: 'হোম',
          onTap: () {
            AppNavigation.goHome(context);
            Navigator.of(context).pop();
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.search,
          title: 'অনুসন্ধান',
          onTap: () {
            AppNavigation.goToSearch(context);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  
  Widget _buildCategoriesSection(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: Text(
                'বিভাগসমূহ',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const _LoadingCategoriesWidget(),
              loaded: (categories) => _CategoriesListWidget(
                categories: categories,
                onCategoryTap: (category) {
                  Navigator.pop(context);
                  AppNavigation.goToCategory(context, category.id, category.name);
                },
              ),
              error: (message) => _ErrorCategoriesWidget(
                message: message,
                onRetry: () => context.read<CategoriesCubit>().loadCategories(),
              ),
            ),
          ],
        );
      },
    );
  }
  

  
  Widget _buildFooterItems(BuildContext context) {
    return Column(
      children: [
        _buildDrawerItem(
          context: context,
          icon: Icons.info_outline,
          title: 'আমাদের সম্পর্কে',
          onTap: () {
            AppNavigation.goToAbout(context);
            Navigator.of(context).pop();
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.contact_mail_outlined,
          title: 'যোগাযোগ',
          onTap: () {
            AppNavigation.goToContact(context);
            Navigator.of(context).pop();
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.settings_outlined,
          title: 'সেটিংস',
          onTap: () {
            // Navigate to settings page
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      onTap: onTap,
      dense: true,
    );
  }
}

/// Loading widget for categories
class _LoadingCategoriesWidget extends StatelessWidget {
  const _LoadingCategoriesWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => 
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Categories list widget
class _CategoriesListWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;

  const _CategoriesListWidget({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.take(5).map((category) => 
        ListTile(
          leading: const Icon(Icons.label_outline),
          title: Text(category.name),
          trailing: Text('${category.count}'),
          onTap: () => onCategoryTap(category),
          dense: true,
        ),
      ).toList(),
    );
  }
}

/// Error widget for categories
class _ErrorCategoriesWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCategoriesWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(height: 8),
        Text(
          'ক্যাটেগরি লোড করতে সমস্যা',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text('আবার চেষ্টা করুন'),
        ),
      ],
    );
  }
}

/// Mini drawer for tablet/desktop layouts
class MiniDrawer extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onToggle;
  
  const MiniDrawer({
    super.key,
    required this.isExpanded,
    this.onToggle,
  });
  
  @override
  Widget build(BuildContext context) {
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 280 : 72,
      child: Drawer(
        child: Column(
          children: [
            _buildMiniHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMiniItem(
                    context: context,
                    icon: Icons.home,
                    title: 'হোম',
                    onTap: () {
                      AppNavigation.goHome(context);
                    },
                  ),
                  _buildMiniItem(
                    context: context,
                    icon: Icons.search,
                    title: 'অনুসন্ধান',
                    onTap: () {
                      AppNavigation.goToSearch(context);
                    },
                  ),
                  _buildMiniItem(
                    context: context,
                    icon: Icons.category,
                    title: 'বিভাগ',
                    onTap: () {
                      // Navigate to categories
                    },
                  ),
                  _buildMiniItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'সম্পর্কে',
                    onTap: () {
                      AppNavigation.goToAbout(context);
                    },
                  ),
                  _buildMiniItem(
                    context: context,
                    icon: Icons.contact_mail_outlined,
                    title: 'যোগাযোগ',
                    onTap: () {
                      AppNavigation.goToContact(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMiniHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 120,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (onToggle != null)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          Icon(
            Icons.article,
            size: isExpanded ? 32 : 24,
            color: theme.colorScheme.onPrimary,
          ),
          if (isExpanded) ...
          [
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildMiniItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Tooltip(
      message: isExpanded ? '' : title,
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        title: isExpanded
            ? Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        onTap: onTap,
        dense: true,
      ),
    );
  }
}