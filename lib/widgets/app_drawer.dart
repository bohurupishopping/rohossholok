// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../routes/app_router.dart';
import '../providers/categories_cubit.dart';
import '../models/category_model.dart';

// Modern color scheme constants for drawer components
const _primaryColor = Color(0xFF1565C0);
const _surfaceColor = Color(0xFFF8FAFC);
const _onSurfaceColor = Color(0xFF334155);
const _secondaryColor = Color(0xFF64748B);
const _accentColor = Color(0xFF0EA5E9);
const _textColor = Color(0xFF334155);

/// Modern navigation drawer with optimized performance and clean UI
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _surfaceColor,
      child: Column(
        children: [
          _buildModernHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 8),
                _buildMainMenuItems(context),
                _buildDivider(),
                _buildCategoriesSection(context),
                _buildDivider(),
                _buildFooterItems(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Modern header with logo and clean design
  Widget _buildModernHeader(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryColor, _accentColor],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
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
                    'assets/logo.png',
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
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 1,
      decoration: BoxDecoration(
        color: _secondaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  /// Main menu items with optimized performance
  Widget _buildMainMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.category_rounded,
                        size: 16,
                        color: _accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceColor,
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: _accentColor.withValues(alpha: 0.1),
          highlightColor: _accentColor.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: _accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _onSurfaceColor,
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
                            color: _secondaryColor,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _secondaryColor,
                  size: 18,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: _secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _secondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _secondaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                          color: _secondaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: categories
            .take(5)
            .map(
              (category) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onCategoryTap(category),
                    borderRadius: BorderRadius.circular(12),
                    splashColor: _accentColor.withValues(alpha: 0.1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.label_outline_rounded,
                              size: 16,
                              color: _primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _onSurfaceColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${category.count}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _accentColor,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Failed to load categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 12,
              color: _secondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Material(
            color: _accentColor,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isExpanded ? 280 : 72,
      child: Drawer(
        backgroundColor: _surfaceColor,
        child: Column(
          children: [
            _buildModernMiniHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () => AppNavigation.goHome(context),
                  ),
                  const SizedBox(height: 8),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.search_rounded,
                    title: 'Search',
                    onTap: () => AppNavigation.goToSearch(context),
                  ),
                  const SizedBox(height: 8),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.category_rounded,
                    title: 'Categories',
                    onTap: () {
                      // Navigate to categories
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildModernMiniDrawerItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () => AppNavigation.goToAbout(context),
                  ),
                  const SizedBox(height: 8),
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
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryColor, _accentColor],
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
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      isExpanded ? Icons.chevron_left : Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          Container(
            width: isExpanded ? 48 : 40,
            height: isExpanded ? 48 : 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                  size: isExpanded ? 24 : 20,
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 12),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: _primaryColor.withValues(alpha: 0.1),
          highlightColor: _primaryColor.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: _primaryColor,
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                       fontSize: 11,
                       fontWeight: FontWeight.w500,
                       color: _textColor,
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
