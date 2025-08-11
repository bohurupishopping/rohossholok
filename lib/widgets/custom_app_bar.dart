// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../routes/app_router.dart';

/// Custom app bar for the application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final bool showSearch;
  final bool showMenu;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.bottom,
    this.onMenuPressed,
    this.onSearchPressed,
    this.showSearch = true,
    this.showMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onPrimary,
        ),
      ),
      leading: leading ?? (showMenu ? _buildMenuButton(context) : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      bottom: bottom,
      actions: _buildActions(context),
    );
  }

  Widget? _buildMenuButton(BuildContext context) {
    return IconButton(
      onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
      icon: const Icon(Icons.menu),
      tooltip: 'মেনু',
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    final defaultActions = <Widget>[];

    if (showSearch && onSearchPressed != null) {
      defaultActions.add(
        IconButton(
          onPressed: onSearchPressed,
          icon: const Icon(Icons.search),
          tooltip: 'অনুসন্ধান',
        ),
      );
    }

    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

/// Modern search app bar with clean design and animations
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? initialQuery;
  final ValueChanged<String>? onQueryChanged;
  final ValueChanged<String>? onQuerySubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final String hintText;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    this.initialQuery,
    this.onQueryChanged,
    this.onQuerySubmitted,
    this.onClear,
    this.onBack,
    this.hintText = 'পোস্ট খুঁজুন...',
    this.autofocus = true,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _controller.addListener(_onTextChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _hasText = widget.initialQuery?.isNotEmpty ?? false;
    if (_hasText) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    widget.onQueryChanged?.call(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      leading: IconButton(
        onPressed: widget.onBack ?? () => AppNavigation.goBack(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
        ),
        tooltip: 'ফিরে যান',
      ),
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Search icon
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.primary,
                size: 18,
              ),
            ),

            // Text field
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: widget.autofocus,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onQuerySubmitted,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Clear button with animation
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _fadeAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _hasText
                        ? Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _onClear,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: theme.colorScheme.onErrorContainer,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Category app bar with category selection
class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?>? onCategoryChanged;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMenuPressed;

  const CategoryAppBar({
    super.key,
    required this.title,
    this.selectedCategory,
    required this.categories,
    this.onCategoryChanged,
    this.onSearchPressed,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu),
        tooltip: 'মেনু',
      ),
      actions: [
        if (onSearchPressed != null)
          IconButton(
            onPressed: onSearchPressed,
            icon: const Icon(Icons.search),
            tooltip: 'অনুসন্ধান',
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              hintText: 'বিভাগ নির্বাচন করুন',
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('সব বিভাগ'),
              ),
              ...categories.map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              ),
            ],
            onChanged: onCategoryChanged,
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 56);
}

/// Post detail app bar with share and bookmark actions
class PostDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final bool isBookmarked;
  final VoidCallback? onBack;

  const PostDetailAppBar({
    super.key,
    required this.title,
    this.onShare,
    this.onBookmark,
    this.isBookmarked = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: IconButton(
        onPressed: onBack ?? () => AppNavigation.goBack(context),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'ফিরে যান',
      ),
      actions: [
        if (onBookmark != null)
          IconButton(
            onPressed: onBookmark,
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            tooltip: isBookmarked ? 'বুকমার্ক সরান' : 'বুকমার্ক করুন',
          ),
        if (onShare != null)
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.share),
            tooltip: 'শেয়ার করুন',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
