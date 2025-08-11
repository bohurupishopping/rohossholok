// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Search bar widget for posts and content
class SearchWidget extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String hintText;
  final bool autofocus;
  final TextEditingController? controller;
  
  const SearchWidget({
    super.key,
    this.initialQuery,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText = 'পোস্ট খুঁজুন...',
    this.autofocus = false,
    this.controller,
  });
  
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _controller;
  bool _hasText = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
      _hasText = widget.initialQuery!.isNotEmpty;
    }
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
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
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          suffixIcon: _hasText
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onErrorContainer,
                        size: 16,
                      ),
                    ),
                    onPressed: _onClear,
                    tooltip: 'পরিষ্কার করুন',
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

/// Search suggestions widget
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final VoidCallback? onClearHistory;
  
  const SearchSuggestions({
    super.key,
    required this.suggestions,
    this.onSuggestionTap,
    this.onClearHistory,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: theme.colorScheme.onTertiaryContainer,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'সাম্প্রতিক অনুসন্ধান',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (onClearHistory != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClearHistory,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.clear_all_rounded,
                              color: theme.colorScheme.onErrorContainer,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'পরিষ্কার করুন',
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          ...suggestions.map(
            (suggestion) => _buildSuggestionItem(context, suggestion),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSuggestionTap?.call(suggestion),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.north_west_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 14,
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

/// Search filters widget
class SearchFilters extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?>? onCategoryChanged;
  final DateTimeRange? dateRange;
  final ValueChanged<DateTimeRange?>? onDateRangeChanged;
  final VoidCallback? onClearFilters;
  
  const SearchFilters({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategoryChanged,
    this.dateRange,
    this.onDateRangeChanged,
    this.onClearFilters,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFilters = selectedCategory != null || dateRange != null;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ফিল্টার',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (hasFilters && onClearFilters != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClearFilters,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.clear_all_rounded,
                              color: theme.colorScheme.onErrorContainer,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'পরিষ্কার করুন',
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Category filter
            _buildFilterSection(
              context,
              'বিভাগ',
              Icons.folder_rounded,
              _buildCategoryDropdown(context),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Date range filter
            _buildFilterSection(
              context,
              'তারিখ',
              Icons.calendar_today_rounded,
              _buildDateRangeButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget child,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
           color: theme.colorScheme.outline.withValues(alpha: 0.1),
           width: 1,
         ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onSecondaryContainer,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          child,
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          hintText: 'বিভাগ নির্বাচন করুন',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.category_rounded,
              color: theme.colorScheme.onTertiaryContainer,
              size: 16,
            ),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'সব বিভাগ',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          ...categories.map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
        onChanged: onCategoryChanged,
        dropdownColor: theme.colorScheme.surface,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDateRangeButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDateRangePicker(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.date_range_rounded,
                  color: theme.colorScheme.onTertiaryContainer,
                  size: 16,
                ),
              ),
              Expanded(
                child: Text(
                  dateRange != null
                      ? '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}'
                      : 'তারিখ নির্বাচন করুন',
                  style: TextStyle(
                    color: dateRange != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: dateRange != null ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange,
      helpText: 'তারিখ নির্বাচন করুন',
      cancelText: 'বাতিল',
      confirmText: 'নিশ্চিত',
    );
    
    if (picked != null) {
      onDateRangeChanged?.call(picked);
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Search results header
class SearchResultsHeader extends StatelessWidget {
  final String query;
  final int resultCount;
  final String? category;
  final VoidCallback? onClearSearch;
  
  const SearchResultsHeader({
    super.key,
    required this.query,
    required this.resultCount,
    this.category,
    this.onClearSearch,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      children: [
                        const TextSpan(text: '"'),
                        TextSpan(
                          text: query,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: '" এর জন্য '),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
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
                              '$resultCount টি ফলাফল',
                              style: TextStyle(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (category != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.folder_rounded,
                                color: theme.colorScheme.onTertiaryContainer,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                category!,
                                style: TextStyle(
                                  color: theme.colorScheme.onTertiaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (onClearSearch != null)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClearSearch,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
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
              ),
          ],
        ),
      ),
    );
  }
}