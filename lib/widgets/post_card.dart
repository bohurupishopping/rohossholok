// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../core/utils.dart';
import '../core/constants.dart';

/// Modern, optimized widget for displaying post information
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
    
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          child: isHorizontal
              ? _buildHorizontalLayout(theme, isTablet)
              : _buildVerticalLayout(theme, isTablet),
        ),
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
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppConstants.borderRadiusLarge),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 16 / 9,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          memCacheHeight: isTablet ? 400 : 300, // Memory optimization
          memCacheWidth: isTablet ? 600 : 450,  // Memory optimization
          placeholder: (context, url) => _buildImagePlaceholder(context, height),
          errorWidget: (context, url, error) => _buildImageError(context, height),
        ),
      ),
    );
  }

  // Modern image placeholder with shimmer effect
  Widget _buildImagePlaceholder(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerLow,
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'লোড হচ্ছে...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern image error state
  Widget _buildImageError(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
            Theme.of(context).colorScheme.errorContainer.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Icon(
                Icons.image_not_supported_rounded,
                size: 24,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'ছবি লোড হয়নি',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryChips(ThemeData theme) {
    final categories = post.categoryNames;
    if (categories.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall / 2,
      children: categories.take(2).map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall / 2,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.8),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
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
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMetadataItem(
            theme,
            Icons.access_time_rounded,
            publishDate != null
                ? AppUtils.formatRelativeTime(publishDate)
                : 'অজানা তারিখ',
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
            width: 1,
            height: 12,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          _buildMetadataItem(
            theme,
            Icons.schedule_rounded,
            '$readingTime মিনিট',
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 12,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}