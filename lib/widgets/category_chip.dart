import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../core/constants.dart';

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
    
    return FilterChip(
      label: Text(
        showCount ? category.displayNameWithCount : category.name,
        style: _getTextStyle(theme),
      ),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        width: 1,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: _getVisualDensity(),
      padding: _getPadding(),
    );
  }
  
  TextStyle? _getTextStyle(ThemeData theme) {
    switch (size) {
      case CategoryChipSize.small:
        return theme.textTheme.labelSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      case CategoryChipSize.medium:
        return theme.textTheme.labelMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      case CategoryChipSize.large:
        return theme.textTheme.labelLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
    }
  }
  
  VisualDensity _getVisualDensity() {
    switch (size) {
      case CategoryChipSize.small:
        return VisualDensity.compact;
      case CategoryChipSize.medium:
        return VisualDensity.standard;
      case CategoryChipSize.large:
        return VisualDensity.comfortable;
    }
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
              child: FilterChip(
                label: Text(
                  'সব',
                  style: _getAllChipTextStyle(context),
                ),
                selected: selectedCategoryId == null,
                onSelected: (_) => onCategorySelected?.call(null),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                side: BorderSide(
                  color: selectedCategoryId == null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: chipSize == CategoryChipSize.small
                    ? VisualDensity.compact
                    : VisualDensity.standard,
              ),
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
  
  TextStyle? _getAllChipTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    switch (chipSize) {
      case CategoryChipSize.small:
        return theme.textTheme.labelSmall?.copyWith(
          fontWeight: selectedCategoryId == null ? FontWeight.w600 : FontWeight.w500,
        );
      case CategoryChipSize.medium:
        return theme.textTheme.labelMedium?.copyWith(
          fontWeight: selectedCategoryId == null ? FontWeight.w600 : FontWeight.w500,
        );
      case CategoryChipSize.large:
        return theme.textTheme.labelLarge?.copyWith(
          fontWeight: selectedCategoryId == null ? FontWeight.w600 : FontWeight.w500,
        );
    }
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