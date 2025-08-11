// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohossholok/providers/categories_cubit.dart';

// --- Centralized Modern UI Theme ---
// This should ideally be defined in a central theme file,
// but is included here for context and portability.
class _AppTheme {
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF4C6FFF);

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusM = 12.0;
}


/// A modern, clean widget to display search suggestions (recent history).
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onClearHistory;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Recent Searches',
          onClear: onClearHistory,
        ),
        ...suggestions.map((term) => _HistoryTile(
          term: term,
          onTap: () => onSuggestionTap(term),
        )),
      ],
    );
  }
}

/// A modern, clean widget to display popular search topics as chips.
class PopularSearches extends StatelessWidget {
  final List<String> topics;
  final ValueChanged<String> onTopicTap;

  const PopularSearches({
    super.key,
    required this.topics,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Popular Topics'),
        const SizedBox(height: _AppTheme.spaceM),
        Wrap(
          spacing: _AppTheme.spaceS,
          runSpacing: _AppTheme.spaceS,
          children: topics.map((topic) => _TopicChip(
            label: topic,
            onTap: () => onTopicTap(topic),
          )).toList(),
        ),
      ],
    );
  }
}

/// A clean, modern modal bottom sheet for displaying search filters.
class FilterSheet extends StatelessWidget {
  final CategoriesCubit categoriesCubit;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  
  const FilterSheet({
    super.key,
    required this.categoriesCubit,
    this.selectedCategory,
    required this.onCategorySelected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filter by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
          const SizedBox(height: _AppTheme.spaceM),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            bloc: categoriesCubit,
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (categories) => DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: const Text('Select a category'),
                  onChanged: onCategorySelected,
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text("All Categories")),
                    ...categories.map((cat) => DropdownMenuItem<String>(value: cat.id.toString(), child: Text(cat.name))),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_AppTheme.radiusM),
                      borderSide: const BorderSide(color: _AppTheme.primary)
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM, vertical: 14),
                  ),
                ),
                orElse: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
          const SizedBox(height: _AppTheme.spaceL),
        ],
      ),
    );
  }
}


// --- Internal Helper Widgets for Search ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClear;
  const _SectionHeader({required this.title, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _AppTheme.spaceM, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                foregroundColor: _AppTheme.primary,
                padding: EdgeInsets.zero
              ),
              child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  const _HistoryTile({required this.term, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, color: _AppTheme.textSecondary),
      title: Text(term, style: const TextStyle(color: _AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.north_west, color: _AppTheme.textSecondary, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TopicChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      labelStyle: const TextStyle(color: _AppTheme.textPrimary, fontWeight: FontWeight.w600),
      backgroundColor: _AppTheme.surface,
      side: BorderSide(color: Colors.grey.shade200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceS, vertical: 6),
    );
  }
}