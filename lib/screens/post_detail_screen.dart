// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui'; // Needed for ImageFilter.blur

import '../core/utils.dart'; // Assuming AppUtils.launchURL exists
import '../routes/app_router.dart';
import '../services/wordpress_api_service.dart';
import '../models/post_model.dart';

// --- Theme (Unchanged) ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const Color primary = Color(0xFF4C6FFF); // Blue for category pills

  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusL = 28.0; // Large radius for the sheet
}

// --- Main Screen Widget ---
class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // Use a Future to drive the UI state declaratively.
  // The '?' allows us to gracefully handle "not found" cases where the API might return null.
  late Future<PostModel?> _postFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the post. The FutureBuilder will handle the rest.
    _fetchPost();
  }

  void _fetchPost() {
    // Use context.read for a cleaner way to get the repository.
    final apiService = context.read<WordPressApiService>();
    _postFuture = apiService.getPost(widget.postId);
  }

  void _retry() {
    // To retry, simply create a new Future and let setState trigger a rebuild
    // of the FutureBuilder.
    setState(() {
      _fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          AppNavigation.goBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: _AppTheme.scaffoldBg,
        // FutureBuilder handles loading, error, and data states automatically.
        body: FutureBuilder<PostModel?>(
          future: _postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _DetailSkeletonLoader();
            }

            if (snapshot.hasError) {
              return _ModernErrorView(
                message: 'Failed to load the article.',
                onRetry: _retry,
              );
            }

            final post = snapshot.data;
            if (post == null) {
              return _ModernNotFoundView(
                message: 'This article could not be found.',
                onBack: () => AppNavigation.goBack(context),
              );
            }

            // Once data is available, build the main view.
            return _PostDetailView(post: post);
          },
        ),
      ),
    );
  }
}

// --- UI Components (Broken down for Organization and Performance) ---

/// The main view shown when the post data has been successfully loaded.
class _PostDetailView extends StatelessWidget {
  final PostModel post;

  const _PostDetailView({required this.post});

  void _sharePost() {
    Share.share('Read this: ${post.title.rendered}\n${post.link}');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BackgroundImage(imageUrl: post.featuredImageUrl),
        _ContentSheet(post: post),
        _Toolbar(
          onBack: () => AppNavigation.goBack(context),
          onShare: _sharePost,
        ),
      ],
    );
  }
}

/// Renders the blurred background image.
class _BackgroundImage extends StatelessWidget {
  final String? imageUrl;

  const _BackgroundImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(color: Colors.grey.shade300);
    }
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        // A simple placeholder to avoid a jarring empty space on error.
        errorWidget: (context, url, error) =>
            Container(color: Colors.grey.shade300),
      ),
    );
  }
}

/// Renders the top toolbar with blurred buttons.
class _Toolbar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShare;

  const _Toolbar({required this.onBack, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ToolbarButton(icon: Icons.arrow_back_ios_new, onPressed: onBack),
          Row(
            children: [
              _ToolbarButton(icon: Icons.link, onPressed: onShare),
              const SizedBox(width: _AppTheme.spaceM),
              _ToolbarButton(icon: Icons.more_horiz, onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single blurred button for the toolbar.
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Using ClipRRect and BackdropFilter is expensive, but encapsulating it in
    // a 'const' widget ensures it only builds when necessary.
    return ClipRRect(
      borderRadius: BorderRadius.circular(56),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: _AppTheme.textPrimary, size: 20),
            onPressed: onPressed,
            splashRadius: 20,
          ),
        ),
      ),
    );
  }
}

/// The draggable sheet that contains the post's content.
class _ContentSheet extends StatelessWidget {
  final PostModel post;

  const _ContentSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _AppTheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_AppTheme.radiusL),
              topRight: Radius.circular(_AppTheme.radiusL),
            ),
          ),
          child: ListView(
            controller: scrollController,
            // Use const for padding since it's a constant value.
            padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
            children: [
              _PostHeader(post: post),
              const SizedBox(height: 24),
              _PostContent(htmlData: post.content.rendered),
              const SizedBox(height: 32),
              _RelatedStoriesSection(currentPost: post),
              const SizedBox(height: 48), // Bottom padding
            ],
          ),
        );
      },
    );
  }
}

/// The header section inside the content sheet (category, title, metadata).
class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    final categoryName = post.getCategoryNames().firstOrNull ?? 'General';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: _AppTheme.spaceL),
        // Drag handle
        Center(
          child: Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: _AppTheme.spaceL),
        // Category Pill
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=10'),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        // Title
        Text(
          post.title.rendered,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _AppTheme.textPrimary,
              height: 1.3),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        // Metadata
        Row(
          children: [
            const Icon(Icons.local_fire_department,
                color: Colors.orange, size: 16),
            const SizedBox(width: 4),
            const Text('Trending No.1',
                style: TextStyle(
                    color: _AppTheme.textSecondary,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: _AppTheme.spaceM),
            Text(post.getFormattedDate(),
                style: const TextStyle(color: _AppTheme.textSecondary)),
          ],
        ),
      ],
    );
  }
}

/// Renders the HTML body of the post.
class _PostContent extends StatelessWidget {
  final String htmlData;

  const _PostContent({required this.htmlData});

  // Define the styles as a static const map for maximum efficiency.
  // This avoids recreating the entire style map on every build.
  static final Map<String, Style> _htmlStyles = {
    'body, p': Style(
      fontSize: FontSize(16.0),
      lineHeight: const LineHeight(1.8),
      color: _AppTheme.textSecondary,
      margin: Margins.only(bottom: 16),
    ),
    'h1, h2, h3, h4, h5, h6': Style(
      fontSize: FontSize(18.0),
      fontWeight: FontWeight.bold,
      color: _AppTheme.textPrimary,
      margin: Margins.only(top: 24, bottom: 8),
    ),
    'a': Style(color: _AppTheme.primary, textDecoration: TextDecoration.none),
    'blockquote': Style(
      border: const Border(left: BorderSide(color: _AppTheme.primary, width: 3)),
      padding: HtmlPaddings.symmetric(horizontal: 16),
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w600,
      color: _AppTheme.textPrimary,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: _htmlStyles,
      onLinkTap: (url, _, _) => (url != null) ? AppUtils.launchURL(url) : null,
    );
  }
}

// --- Related Stories Section ---

class _RelatedStoriesSection extends StatefulWidget {
  final PostModel currentPost;
  
  const _RelatedStoriesSection({required this.currentPost});
  
  @override
  State<_RelatedStoriesSection> createState() => _RelatedStoriesSectionState();
}

class _RelatedStoriesSectionState extends State<_RelatedStoriesSection> {
  late Future<List<PostModel>> _relatedPostsFuture;
  
  @override
  void initState() {
    super.initState();
    _fetchRelatedPosts();
  }
  
  void _fetchRelatedPosts() {
    final apiService = context.read<WordPressApiService>();
    final categoryIds = widget.currentPost.categories;
    
    if (categoryIds.isNotEmpty) {
      _relatedPostsFuture = apiService.getRelatedPosts(
        currentPostId: widget.currentPost.id,
        categoryId: categoryIds.first,
        perPage: 4,
      );
    } else {
      _relatedPostsFuture = Future.value(<PostModel>[]);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
          child: Text(
            'Related Stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        FutureBuilder<List<PostModel>>(
          future: _relatedPostsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _RelatedStoriesSkeleton();
            }
            
            if (snapshot.hasError) {
              return const _RelatedStoriesError();
            }
            
            final relatedPosts = snapshot.data ?? [];
            
            if (relatedPosts.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Column(
              children: relatedPosts.map((post) => 
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _AppTheme.spaceL, 0, _AppTheme.spaceL, _AppTheme.spaceM),
                  child: _RelatedStoryCard(post: post),
                )
              ).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Related story card using the same design as _ModernFeedCard from category_screen.dart
class _RelatedStoryCard extends StatelessWidget {
  final PostModel post;
  
  const _RelatedStoryCard({required this.post});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => AppNavigation.goToPost(context, post.id),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.getFormattedDate()} • ${post.getEstimatedReadingTime()} min read',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: _AppTheme.spaceS),
                      Text(
                        post.title.rendered,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: _AppTheme.spaceS),
                      if (post.excerpt.rendered.isNotEmpty)
                        Text(
                          post.excerpt.rendered.replaceAll(RegExp(r"<[^>]*>"), ''),
                          style: const TextStyle(
                            fontSize: 14,
                            color: _AppTheme.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: _AppTheme.spaceM),
                      _buildTags(post),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                _buildImage(post.featuredImageUrl),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTags(PostModel post) {
    final tags = post.getCategoryNames().take(2).toList();
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: _AppTheme.spaceS,
      runSpacing: _AppTheme.spaceS,
      children: tags
          .map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFFC2185B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
          .toList(),
    );
  }
  
  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: 90,
              height: 110,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const SizedBox(width: 90, height: 110, child: ColoredBox(color: Color(0xFFF6F8FD))),
              errorWidget: (context, url, error) => const SizedBox(
                width: 90,
                height: 110,
                child: ColoredBox(
                  color: Color(0xFFF6F8FD),
                  child: Icon(Icons.broken_image,
                      color: Color(0xFF757575), size: 24),
                ),
              ),
            )
          : const SizedBox(width: 90, height: 110, child: ColoredBox(color: Color(0xFFF6F8FD))),
    );
  }
}

/// Loading skeleton for related stories
class _RelatedStoriesSkeleton extends StatelessWidget {
  const _RelatedStoriesSkeleton();
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.shimmerBase,
      highlightColor: _AppTheme.shimmerHighlight,
      child: Column(
        children: List.generate(2, (index) => 
          Container(
            margin: const EdgeInsets.fromLTRB(
              _AppTheme.spaceL, 0, _AppTheme.spaceL, _AppTheme.spaceM),
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            decoration: BoxDecoration(
              color: _AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10, width: 120, color: Colors.white),
                      const SizedBox(height: 12),
                      Container(height: 18, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 18, width: 100, color: Colors.white),
                      const SizedBox(height: 12),
                      Container(height: 14, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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

/// Error widget for related stories
class _RelatedStoriesError extends StatelessWidget {
  const _RelatedStoriesError();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20),
          SizedBox(width: _AppTheme.spaceS),
          Text(
            'Failed to load related stories',
            style: TextStyle(
              color: _AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Skeleton and State Widgets (Optimized with const constructors) ---

class _DetailSkeletonLoader extends StatelessWidget {
  const _DetailSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.shimmerBase,
      highlightColor: _AppTheme.shimmerHighlight,
      child: Stack(
        children: [
          Container(color: Colors.white), // Background placeholder
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_AppTheme.radiusL),
                  topRight: Radius.circular(_AppTheme.radiusL),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  Container(
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20))),
                  const SizedBox(height: 24),
                  Container(
                      height: 28, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 28, width: 200, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(height: 14, width: 180, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ModernErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off,
                color: _AppTheme.textSecondary, size: 50),
            const SizedBox(height: _AppTheme.spaceM),
            const Text('An Error Occurred',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(color: _AppTheme.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                    backgroundColor: _AppTheme.primary,
                    foregroundColor: Colors.white),
                child: const Text('Try Again'))
          ],
        ),
      ),
    );
  }
}

class _ModernNotFoundView extends StatelessWidget {
  final String message;
  final VoidCallback onBack;
  const _ModernNotFoundView({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off,
                color: _AppTheme.textSecondary, size: 50),
            const SizedBox(height: _AppTheme.spaceM),
            const Text('Article Not Found',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(color: _AppTheme.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton(
                onPressed: onBack,
                child: const Text('Go Back',
                    style: TextStyle(color: _AppTheme.primary)))
          ],
        ),
      ),
    );
  }
}