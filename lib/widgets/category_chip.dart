// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../core/constants.dart';

// Modern UI Theme matching home_screen.dart and category_screen.dart
class _ModernTheme {
  static const Color surface = Colors.white;
  static const Color textSecondary = Color(0xFF7D7F8B);
  static const Color primary = Color(0xFF4C6FFF);
}

/// Reusable category chip widget
class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final bool showCount;
  final bool isSelected;
  final CategoryChipSize size;
  
  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
    this.showCount = false,
    this.isSelected = false,
    this.size = CategoryChipSize.medium,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: _getBackgroundColor(theme),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            border: Border.all(
              color: _getBorderColor(theme),
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: _ModernTheme.primary.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _ModernTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  showCount ? category.displayNameWithCount : category.name,
                  style: _getTextStyle(theme),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  TextStyle? _getTextStyle(ThemeData theme) {
    final baseStyle = switch (size) {
      CategoryChipSize.small => theme.textTheme.labelSmall,
      CategoryChipSize.medium => theme.textTheme.labelMedium,
      CategoryChipSize.large => theme.textTheme.labelLarge,
    };
    
    return baseStyle?.copyWith(
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
      color: isSelected 
          ? _ModernTheme.primary
          : _ModernTheme.textSecondary,
      fontSize: switch (size) {
        CategoryChipSize.small => 11,
        CategoryChipSize.medium => 12,
        CategoryChipSize.large => 14,
      },
    );
  }
  
  Color _getBackgroundColor(ThemeData theme) {
    if (isSelected) {
      return _ModernTheme.primary.withValues(alpha: 0.1);
    }
    return _ModernTheme.surface;
  }
  
  Color _getBorderColor(ThemeData theme) {
    if (isSelected) {
      return _ModernTheme.primary;
    }
    return _ModernTheme.textSecondary.withValues(alpha: 0.3);
  }
  
  double _getBorderRadius() {
    return switch (size) {
      CategoryChipSize.small => AppConstants.borderRadiusMedium,
      CategoryChipSize.medium => AppConstants.borderRadiusLarge,
      CategoryChipSize.large => AppConstants.borderRadiusLarge + 2,
    };
  }
  
  
  EdgeInsets _getPadding() {
    switch (size) {
      case CategoryChipSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
          vertical: 2,
        );
      case CategoryChipSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: 4,
        );
      case CategoryChipSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: 6,
        );
    }
  }
}

/// Category chip sizes
enum CategoryChipSize {
  small,
  medium,
  large,
}

/// Category list widget for horizontal scrolling
class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(CategoryModel?)? onCategorySelected;
  final bool showAllOption;
  final CategoryChipSize chipSize;
  
  const CategoryList({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.showAllOption = true,
    this.chipSize = CategoryChipSize.medium,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getListHeight(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
        ),
        itemCount: categories.length + (showAllOption ? 1 : 0),
        itemBuilder: (context, index) {
          if (showAllOption && index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
              child: _buildAllChip(context),
            );
          }
          
          final categoryIndex = showAllOption ? index - 1 : index;
          final category = categories[categoryIndex];
          
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: CategoryChip(
              category: category,
              isSelected: selectedCategoryId == category.id,
              onTap: () => onCategorySelected?.call(category),
              showCount: true,
              size: chipSize,
            ),
          );
        },
      ),
    );
  }
  
  double _getListHeight() {
    switch (chipSize) {
      case CategoryChipSize.small:
        return 40;
      case CategoryChipSize.medium:
        return 48;
      case CategoryChipSize.large:
        return 56;
    }
  }
  
  Widget _buildAllChip(BuildContext context) {
    Theme.of(context);
    final isSelected = selectedCategoryId == null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onCategorySelected?.call(null),
        borderRadius: BorderRadius.circular(_getAllChipBorderRadius()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: _getAllChipPadding(),
          decoration: BoxDecoration(
            color: isSelected 
                ? _ModernTheme.primary.withValues(alpha: 0.1)
                : _ModernTheme.surface,
            borderRadius: BorderRadius.circular(_getAllChipBorderRadius()),
            border: Border.all(
              color: isSelected
                  ? _ModernTheme.primary
                  : _ModernTheme.textSecondary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: _ModernTheme.primary.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.apps_rounded,
                  size: 14,
                  color: _ModernTheme.primary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                'সব',
                style: _getAllChipTextStyle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  TextStyle? _getAllChipTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedCategoryId == null;
    
    final baseStyle = switch (chipSize) {
      CategoryChipSize.small => theme.textTheme.labelSmall,
      CategoryChipSize.medium => theme.textTheme.labelMedium,
      CategoryChipSize.large => theme.textTheme.labelLarge,
    };
    
    return baseStyle?.copyWith(
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
      color: isSelected 
          ? _ModernTheme.primary
          : _ModernTheme.textSecondary,
      fontSize: switch (chipSize) {
        CategoryChipSize.small => 11,
        CategoryChipSize.medium => 12,
        CategoryChipSize.large => 14,
      },
    );
  }
  
  double _getAllChipBorderRadius() {
    return switch (chipSize) {
      CategoryChipSize.small => AppConstants.borderRadiusMedium,
      CategoryChipSize.medium => AppConstants.borderRadiusLarge,
      CategoryChipSize.large => AppConstants.borderRadiusLarge + 2,
    };
  }
  
  EdgeInsets _getAllChipPadding() {
    return switch (chipSize) {
      CategoryChipSize.small => const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 6,
      ),
      CategoryChipSize.medium => const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: 8,
      ),
      CategoryChipSize.large => const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
        vertical: 10,
      ),
    };
  }
}

/// Category grid widget for displaying categories in a grid layout
class CategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(CategoryModel)? onCategorySelected;
  final int crossAxisCount;
  final double childAspectRatio;
  
  const CategoryGrid({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.crossAxisCount = 2,
    this.childAspectRatio = 3.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppConstants.paddingSmall,
        mainAxisSpacing: AppConstants.paddingSmall,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryChip(
          category: category,
          isSelected: selectedCategoryId == category.id,
          onTap: () => onCategorySelected?.call(category),
          showCount: true,
          size: CategoryChipSize.medium,
        );
      },
    );
  }
}