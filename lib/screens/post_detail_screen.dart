// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
import '../routes/app_router.dart';

import '../services/wordpress_api_service.dart';
import '../models/post_model.dart';


/// Screen for displaying individual post details
class PostDetailScreen extends StatefulWidget {
  final int postId;
  
  const PostDetailScreen({
    super.key,
    required this.postId,
  });
  
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final WordPressApiService _apiService;
  PostModel? _post;
  bool _isLoading = true;
  String? _error;
  bool _isBookmarked = false;
  
  @override
  void initState() {
    super.initState();
    _apiService = RepositoryProvider.of<WordPressApiService>(context);
    _loadPost();
  }
  
  Future<void> _loadPost() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final post = await _apiService.getPost(widget.postId);
      
      setState(() {
        _post = post;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  void _sharePost() {
    if (_post != null) {
      Share.share(
        '${_post!.title.rendered}\n\n${_post!.link}',
        subject: _post!.title.rendered,
      );
    }
  }
  
  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'বুকমার্ক করা হয়েছে' : 'বুকমার্ক সরানো হয়েছে',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'লোড হচ্ছে...'),
        body: const Center(child: LoadingSpinner()),
      );
    }
    
    if (_error != null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'ত্রুটি'),
        body: AppErrorWidget(
          message: _error!,
          onRetry: _loadPost,
        ),
      );
    }
    
    if (_post == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'পোস্ট পাওয়া যায়নি'),
        body: const NotFoundWidget(
          message: 'এই পোস্টটি পাওয়া যায়নি।',
        ),
      );
    }
    
    return Scaffold(
      appBar: PostDetailAppBar(
        title: _post!.title.rendered,
        onShare: _sharePost,
        onBookmark: _toggleBookmark,
        isBookmarked: _isBookmarked,
        onBack: () => AppNavigation.goBack(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedImage(),
            _buildPostContent(),
            _buildPostMeta(),
            _buildRelatedPosts(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeaturedImage() {
    final featuredImageUrl = _post!.featuredImageUrl;
    
    if (featuredImageUrl == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: featuredImageUrl,
            fit: BoxFit.cover,
            memCacheHeight: 400,
            memCacheWidth: 600,
            placeholder: (context, url) => _buildImagePlaceholder(),
            errorWidget: (context, url, error) => _buildImageError(),
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            const LoadingSpinner(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageError() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.error.withOpacity(0.7),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'ছবি লোড করা যায়নি',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPostContent() {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _post!.title.rendered,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Post meta
          _buildPostMetaRow(),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Categories
          if (_post!.getCategoryNames().isNotEmpty)
            _buildCategoriesRow(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Content
          Html(
            data: _post!.content.rendered,
            style: {
              'body': Style(
                fontSize: FontSize(16),
                lineHeight: const LineHeight(1.6),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'p': Style(
                margin: Margins.only(
                  bottom: AppConstants.paddingMedium,
                ),
              ),
              'h1, h2, h3, h4, h5, h6': Style(
                fontWeight: FontWeight.bold,
                margin: Margins.only(
                  top: AppConstants.paddingLarge,
                  bottom: AppConstants.paddingMedium,
                ),
              ),
              'blockquote': Style(
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 4,
                  ),
                ),
                padding: HtmlPaddings.only(
                  left: AppConstants.paddingMedium,
                ),
                margin: Margins.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
                backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              'code': Style(
                backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                padding: HtmlPaddings.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                fontFamily: 'monospace',
              ),
              'pre': Style(
                backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                padding: HtmlPaddings.all(AppConstants.paddingMedium),
                margin: Margins.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            },
            onLinkTap: (url, attributes, element) {
              if (url != null) {
                AppUtils.launchURL(url);
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostMetaRow() {
    final theme = Theme.of(context);
    final publishDate = _post!.getFormattedDate();
    final readingTime = _post!.getEstimatedReadingTime();
    final authorName = _post!.getAuthorName();
    
    return Wrap(
      spacing: AppConstants.paddingMedium,
      runSpacing: AppConstants.paddingSmall,
      children: [
        _buildMetaItem(
          icon: Icons.calendar_today,
          text: publishDate,
          theme: theme,
        ),
        _buildMetaItem(
          icon: Icons.access_time,
          text: '$readingTime মিনিট পড়ার সময়',
          theme: theme,
        ),
        if (authorName.isNotEmpty)
          _buildMetaItem(
            icon: Icons.person,
            text: authorName,
            theme: theme,
          ),
      ],
    );
  }
  
  Widget _buildMetaItem({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 14,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesRow() {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall,
      children: _post!.getCategoryNames().map(
        (categoryName) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.8),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tag_rounded,
                size: 12,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                categoryName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
  
  Widget _buildPostMeta() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Text(
                'পোস্ট তথ্য',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildMetaRow('প্রকাশিত', _post!.getFormattedDate(), Icons.calendar_today_rounded),
          _buildMetaRow('আপডেট', _post!.getFormattedModifiedDate(), Icons.update_rounded),
          _buildMetaRow('পড়ার সময়', '${_post!.getEstimatedReadingTime()} মিনিট', Icons.schedule_rounded),
          if (_post!.getAuthorName().isNotEmpty)
            _buildMetaRow('লেখক', _post!.getAuthorName(), Icons.person_rounded),
        ],
      ),
    );
  }
  
  Widget _buildMetaRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRelatedPosts() {
    // This would load related posts based on categories or tags
    // For now, we'll show a placeholder
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'সম্পর্কিত পোস্ট',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          const Text(
            'সম্পর্কিত পোস্ট শীঘ্রই আসছে...',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

/// Floating action button for post actions
class PostActionsFAB extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onCopyLink;
  final bool isBookmarked;
  
  const PostActionsFAB({
    super.key,
    this.onShare,
    this.onBookmark,
    this.onCopyLink,
    this.isBookmarked = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onBookmark != null)
          FloatingActionButton(
            heroTag: 'bookmark',
            onPressed: onBookmark,
            backgroundColor: isBookmarked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: AppConstants.paddingSmall),
        if (onShare != null)
          FloatingActionButton(
            heroTag: 'share',
            onPressed: onShare,
            child: const Icon(Icons.share),
          ),
        const SizedBox(height: AppConstants.paddingSmall),
        if (onCopyLink != null)
          FloatingActionButton(
            heroTag: 'copy',
            onPressed: onCopyLink,
            child: const Icon(Icons.link),
          ),
      ],
    );
  }
}