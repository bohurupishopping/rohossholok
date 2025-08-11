// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../routes/app_router.dart';
import '../providers/categories_cubit.dart';
import '../models/category_model.dart';

// Modern UI Theme matching home_screen.dart and category_screen.dart
class _ModernTheme {
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);
  static const Color primary = Color(0xFF4C6FFF);
}

/// Modern navigation drawer with optimized performance and clean UI
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return Drawer(
      backgroundColor: _ModernTheme.surface,
      child: Column(
        children: [
          _buildModernHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: AppConstants.paddingSmall),
                _buildMainMenuItems(context),
                _buildDivider(context),
                _buildCategoriesSection(context),
                _buildDivider(context),
                _buildFooterItems(context),
                const SizedBox(height: AppConstants.paddingMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Modern header with logo and clean design
  Widget _buildModernHeader(BuildContext context) {
    Theme.of(context);
    
    return Container(
      height: AppConstants.drawerHeaderHeight,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingLarge,
        AppConstants.paddingMedium,
        AppConstants.paddingLarge,
        AppConstants.paddingLarge,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_ModernTheme.primary, _ModernTheme.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.borderRadiusExtraLarge),
          bottomRight: Radius.circular(AppConstants.borderRadiusExtraLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    '/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.article_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bengali Blog Platform',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Custom divider with modern styling
  Widget _buildDivider(BuildContext context) {
    Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      height: 1,
      decoration: BoxDecoration(
        color: _ModernTheme.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  /// Main menu items with optimized performance
  Widget _buildMainMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
      child: Column(
        children: [
          _buildModernDrawerItem(
            context: context,
            icon: Icons.home_rounded,
            title: 'Home',
            subtitle: 'Latest posts and updates',
            onTap: () {
              AppNavigation.goHome(context);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 4),
          _buildModernDrawerItem(
            context: context,
            icon: Icons.search_rounded,
            title: 'Search',
            subtitle: 'Find articles and content',
            onTap: () {
              AppNavigation.goToSearch(context);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Categories section with modern design and performance optimization
  Widget _buildCategoriesSection(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        Theme.of(context);
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall + 4,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _ModernTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        size: AppConstants.iconSizeSmall,
                        color: _ModernTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall + 4),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: AppConstants.iconSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: _ModernTheme.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const _ModernLoadingWidget(),
                loaded: (categories) => _ModernCategoriesListWidget(
                  categories: categories,
                  onCategoryTap: (category) {
                    Navigator.pop(context);
                    AppNavigation.goToCategory(
                      context,
                      category.id,
                      category.name,
                    );
                  },
                ),
                error: (message) => _ModernErrorWidget(
                  message: message,
                  onRetry: () => context.read<CategoriesCubit>().loadCategories(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Footer items with modern design
  Widget _buildFooterItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
      child: Column(
        children: [
          _buildModernDrawerItem(
            context: context,
            icon: Icons.info_outline_rounded,
            title: 'About Us',
            subtitle: 'Learn more about our platform',
            onTap: () {
              AppNavigation.goToAbout(context);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 4),
          _buildModernDrawerItem(
            context: context,
            icon: Icons.contact_mail_outlined,
            title: 'Contact',
            subtitle: 'Get in touch with us',
            onTap: () {
              AppNavigation.goToContact(context);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 4),
          _buildModernDrawerItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'App preferences and options',
            onTap: () {
              // Navigate to settings page
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Modern drawer item with optimized performance and clean design
  Widget _buildModernDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          splashColor: _ModernTheme.primary.withValues(alpha: 0.1),
          highlightColor: _ModernTheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: AppConstants.drawerIconContainerSize,
                  height: AppConstants.drawerIconContainerSize,
                  decoration: BoxDecoration(
                    color: _ModernTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: _ModernTheme.primary,
                    size: AppConstants.drawerIconSize,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _ModernTheme.textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: _ModernTheme.textSecondary,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _ModernTheme.textSecondary,
                  size: AppConstants.iconSizeSmall + 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern loading widget with shimmer effect
class _ModernLoadingWidget extends StatelessWidget {
  const _ModernLoadingWidget();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: _ModernTheme.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Row(
              children: [
                const SizedBox(width: AppConstants.paddingMedium),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _ModernTheme.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _ModernTheme.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                          color: _ModernTheme.textSecondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern categories list widget with optimized performance
class _ModernCategoriesListWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;

  const _ModernCategoriesListWidget({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
      child: Column(
        children: categories
            .take(5)
            .map(
              (category) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  child: InkWell(
                    onTap: () => onCategoryTap(category),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    splashColor: _ModernTheme.primary.withValues(alpha: 0.1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingMedium,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _ModernTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                            child: Icon(
                              Icons.label_outline_rounded,
                              size: AppConstants.iconSizeSmall,
                              color: _ModernTheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _ModernTheme.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingSmall,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: _ModernTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                            ),
                            child: Text(
                              '${category.count}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _ModernTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Modern error widget with clean design
class _ModernErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ModernErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: theme.colorScheme.error,
              size: 24,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Failed to load categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _ModernTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 12,
              color: _ModernTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Material(
            color: _ModernTheme.primary,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

/// Modern mini drawer for tablet/desktop layouts with optimized performance
class MiniDrawer extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onToggle;

  const MiniDrawer({super.key, required this.isExpanded, this.onToggle});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isExpanded ? AppConstants.drawerWidth : AppConstants.miniDrawerWidth,
      child: Drawer(
        backgroundColor: _ModernTheme.surface,
        child: Column(
          children: [
            _buildModernMiniHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () => AppNavigation.goHome(context),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.search_rounded,
                    title: 'Search',
                    onTap: () => AppNavigation.goToSearch(context),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.category_rounded,
                    title: 'Categories',
                    onTap: () {
                      // Navigate to categories
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () => AppNavigation.goToAbout(context),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.contact_mail_outlined,
                    title: 'Contact',
                    onTap: () => AppNavigation.goToContact(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modern mini header with logo and clean design
  Widget _buildModernMiniHeader(BuildContext context) {
    Theme.of(context);
    
    return Container(
      height: AppConstants.miniDrawerHeaderHeight,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_ModernTheme.primary, _ModernTheme.primary.withValues(alpha: 0.8)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (onToggle != null)
            Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                child: InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      isExpanded ? Icons.chevron_left : Icons.chevron_right,
                      color: Colors.white,
                      size: AppConstants.iconSizeSmall,
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          Container(
            width: isExpanded ? 48 : 40,
            height: isExpanded ? 48 : 40,
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              child: Image.asset(
                '/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                  size: isExpanded ? 24 : AppConstants.iconSizeSmall,
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }

  /// Modern mini drawer item with rounded design
  Widget _buildModernMiniDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          splashColor: _ModernTheme.primary.withValues(alpha: 0.1),
          highlightColor: _ModernTheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.paddingMedium,
              horizontal: AppConstants.paddingSmall,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _ModernTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    size: AppConstants.iconSizeSmall,
                    color: _ModernTheme.primary,
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    title,
                    style: TextStyle(
                       fontSize: 11,
                       fontWeight: FontWeight.w500,
                       color: _ModernTheme.textPrimary,
                     ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

}
