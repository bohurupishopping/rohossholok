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
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );
}

/// Search app bar for search functionality
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

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _onTextChanged() {
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
        icon: const Icon(Icons.arrow_back),
        tooltip: 'ফিরে যান',
      ),
      title: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onQuerySubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: _onClear,
                  icon: const Icon(Icons.clear),
                  tooltip: 'পরিষ্কার করুন',
                )
              : null,
        ),
        style: theme.textTheme.bodyLarge,
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
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
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