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
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
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
    
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'সাম্প্রতিক অনুসন্ধান',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onClearHistory != null)
                  TextButton(
                    onPressed: onClearHistory,
                    child: const Text('পরিষ্কার করুন'),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...suggestions.map(
            (suggestion) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(suggestion),
              trailing: const Icon(Icons.north_west),
              onTap: () => onSuggestionTap?.call(suggestion),
              dense: true,
            ),
          ),
        ],
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
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ফিল্টার',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hasFilters && onClearFilters != null)
                  TextButton(
                    onPressed: onClearFilters,
                    child: const Text('পরিষ্কার করুন'),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            // Category filter
            Text(
              'বিভাগ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                hintText: 'বিভাগ নির্বাচন করুন',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
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
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Date range filter
            Text(
              'তারিখ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            OutlinedButton.icon(
              onPressed: () => _showDateRangePicker(context),
              icon: const Icon(Icons.date_range),
              label: Text(
                dateRange != null
                    ? '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}'
                    : 'তারিখ নির্বাচন করুন',
              ),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
              ),
            ),
          ],
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
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: '"'),
                        TextSpan(
                          text: query,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: '" এর জন্য '),
                        TextSpan(
                          text: '$resultCount',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: ' টি ফলাফল পাওয়া গেছে'),
                        if (category != null) ...
                        [
                          const TextSpan(text: ' "'),
                          TextSpan(
                            text: category!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: '" বিভাগে'),
                        ],
                      ],
                    ),
                  ),
                ),
                if (onClearSearch != null)
                  IconButton(
                    onPressed: onClearSearch,
                    icon: const Icon(Icons.close),
                    tooltip: 'অনুসন্ধান পরিষ্কার করুন',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}