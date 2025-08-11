import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../core/utils.dart';
import '../core/constants.dart';

/// Reusable widget for displaying post information
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final bool showExcerpt;
  final bool isHorizontal;
  
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.showExcerpt = true,
    this.isHorizontal = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = AppUtils.isTablet(screenWidth);
    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: isHorizontal
            ? _buildHorizontalLayout(theme, isTablet)
            : _buildVerticalLayout(theme, isTablet),
      ),
    );
  }
  
  Widget _buildVerticalLayout(ThemeData theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeaturedImage(isTablet),
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryChips(theme),
              const SizedBox(height: AppConstants.paddingSmall),
              _buildTitle(theme),
              if (showExcerpt) ...
              [
                const SizedBox(height: AppConstants.paddingSmall),
                _buildExcerpt(theme),
              ],
              const SizedBox(height: AppConstants.paddingMedium),
              _buildMetadata(theme),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHorizontalLayout(ThemeData theme, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet ? 200 : 120,
          height: isTablet ? 150 : 100,
          child: _buildFeaturedImage(isTablet, aspectRatio: 1.2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryChips(theme),
                const SizedBox(height: AppConstants.paddingSmall),
                _buildTitle(theme, maxLines: 2),
                if (showExcerpt) ...
                [
                  const SizedBox(height: AppConstants.paddingSmall),
                  _buildExcerpt(theme, maxLines: 2),
                ],
                const SizedBox(height: AppConstants.paddingMedium),
                _buildMetadata(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeaturedImage(bool isTablet, {double? aspectRatio}) {
    final imageUrl = AppUtils.getImageUrl(post.featuredImageUrl);
    final height = isTablet ? 200.0 : 180.0;
    
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppConstants.borderRadiusMedium),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 16 / 9,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: height,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'ছবি লোড হয়নি',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryChips(ThemeData theme) {
    final categories = post.categoryNames;
    if (categories.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: AppConstants.paddingSmall,
      children: categories.take(2).map((category) {
        return Chip(
          label: Text(
            category,
            style: theme.textTheme.labelSmall,
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          side: BorderSide.none,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
  
  Widget _buildTitle(ThemeData theme, {int? maxLines}) {
    return Text(
      post.title.rendered,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      maxLines: maxLines ?? 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildExcerpt(ThemeData theme, {int? maxLines}) {
    return Text(
      post.plainExcerpt,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      maxLines: maxLines ?? 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _buildMetadata(ThemeData theme) {
    final publishDate = post.parsedDate;
    final readingTime = post.readingTimeMinutes;
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          publishDate != null
              ? AppUtils.formatRelativeTime(publishDate)
              : 'অজানা তারিখ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.schedule,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '$readingTime মিনিট পড়ার সময়',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}