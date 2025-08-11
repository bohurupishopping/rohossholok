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

// --- New Modern UI Theme based on the demo image ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const Color primary = Color(0xFF4C6FFF); // Blue for category pills

  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  static const double radiusL = 28.0; // Large radius for the sheet
}

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final WordPressApiService _apiService;
  PostModel? _post;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _apiService = RepositoryProvider.of<WordPressApiService>(context);
    _loadPost();
  }

  Future<void> _loadPost() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final post = await _apiService.getPost(widget.postId);
      if (mounted) setState(() => _post = post);
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to load the article.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _sharePost() {
    if (_post != null) {
      Share.share('Read this: ${_post!.title.rendered}\n${_post!.link}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const _DetailSkeletonLoader();
    if (_error != null) return _ModernErrorView(message: _error!, onRetry: _loadPost);
    if (_post == null) {
      return _ModernNotFoundView(
        message: 'This article could not be found.',
        onBack: () => AppNavigation.goBack(context),
      );
    }

    return Stack(
      children: [
        _buildBackgroundImage(imageUrl: _post!.featuredImageUrl),
        _buildContentSheet(post: _post!),
        _buildToolbar(
          onBack: () => AppNavigation.goBack(context),
          onShare: _sharePost,
        ),
      ],
    );
  }

  Widget _buildBackgroundImage({String? imageUrl}) {
    if (imageUrl == null) return Container(color: Colors.grey.shade300);
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildToolbar({required VoidCallback onBack, required VoidCallback onShare}) {
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

  Widget _buildContentSheet({required PostModel post}) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75, // Start lower to show the image
      minChildSize: 0.75,
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
            padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
            children: [
              _buildPostHeader(post),
              const SizedBox(height: 24),
              _buildPostContent(post.content.rendered),
              const SizedBox(height: 48), // Bottom padding
            ],
          ),
        );
      },
    );
  }
}

// --- New UI Components to Match Your Demo ---

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
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

Widget _buildPostHeader(PostModel post) {
  final categoryName = post.getCategoryNames().firstOrNull ?? 'General';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: _AppTheme.spaceL),
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
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=10'),
              ),
              const SizedBox(width: 8),
              Text(
                categoryName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: _AppTheme.spaceM),
      Text(
        post.title.rendered,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary, height: 1.3),
      ),
      const SizedBox(height: _AppTheme.spaceM),
      Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
          const SizedBox(width: 4),
          const Text('Trending No.1', style: TextStyle(color: _AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(width: _AppTheme.spaceM),
          Text(post.getFormattedDate(), style: const TextStyle(color: _AppTheme.textSecondary)),
        ],
      ),
    ],
  );
}

Widget _buildPostContent(String htmlData) {
  return Html(
    data: htmlData,
    style: {
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
    },
    onLinkTap: (url, _, _) => (url != null) ? AppUtils.launchURL(url) : null,
  );
}

// --- Skeleton and State Widgets ---

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
                  Container(height: 30, width: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                  const SizedBox(height: 24),
                  Container(height: 28, width: double.infinity, color: Colors.white),
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.cloud_off, color: _AppTheme.textSecondary, size: 50),
              const SizedBox(height: _AppTheme.spaceM),
              const Text('An Error Occurred', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: _AppTheme.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onRetry, style: ElevatedButton.styleFrom(backgroundColor: _AppTheme.primary, foregroundColor: Colors.white), child: const Text('Try Again'))
            ])));
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.search_off, color: _AppTheme.textSecondary, size: 50),
              const SizedBox(height: _AppTheme.spaceM),
              const Text('Article Not Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: _AppTheme.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              TextButton(onPressed: onBack, child: const Text('Go Back', style: TextStyle(color: _AppTheme.primary)))
            ])));
  }
}