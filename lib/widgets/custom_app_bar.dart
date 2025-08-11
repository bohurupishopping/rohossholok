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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: leading ?? (showMenu ? _buildModernMenuButton(context) : null),
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: centerTitle,
        bottom: bottom,
        actions: _buildModernActions(context),
      ),
    );
  }

  Widget? _buildModernMenuButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingSmall),
      child: Material(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: InkWell(
          onTap: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: AppConstants.iconSizeSmall + 4,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? _buildModernActions(BuildContext context) {
    final defaultActions = <Widget>[];

    if (showSearch && onSearchPressed != null) {
      defaultActions.add(
        Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: InkWell(
              onTap: onSearchPressed,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall + 4,
                ),
              ),
            ),
          ),
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: InkWell(
              onTap: widget.onBack ?? () => AppNavigation.goBack(context),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall + 4,
                ),
              ),
            ),
          ),
        ),
        title: Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        child: Row(
          children: [
              // Search icon
              Container(
                margin: const EdgeInsets.all(AppConstants.paddingSmall),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall + 2,
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
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
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
                            margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _onClear,
                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: InkWell(
              onTap: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall + 4,
                ),
              ),
            ),
          ),
        ),
        actions: [
          if (onSearchPressed != null)
            Container(
              margin: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Material(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: InkWell(
                  onTap: onSearchPressed,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: AppConstants.iconSizeSmall + 4,
                    ),
                  ),
                ),
              ),
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
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: theme.colorScheme.surface,
              iconEnabledColor: Colors.white,
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
            ),
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Container(
          margin: const EdgeInsets.all(AppConstants.paddingSmall),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: InkWell(
              onTap: onBack ?? () => AppNavigation.goBack(context),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall + 4,
                ),
              ),
            ),
          ),
        ),
        actions: [
          if (onBookmark != null)
            Container(
              margin: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Material(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: InkWell(
                  onTap: onBookmark,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    child: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: Colors.white,
                      size: AppConstants.iconSizeSmall + 4,
                    ),
                  ),
                ),
              ),
            ),
          if (onShare != null)
            Container(
              margin: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Material(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: InkWell(
                  onTap: onShare,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    child: Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                      size: AppConstants.iconSizeSmall + 4,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
