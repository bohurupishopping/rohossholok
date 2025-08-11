// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui'; // Needed for ImageFilter.blur

import '../core/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../routes/app_router.dart';
import '../services/wordpress_api_service.dart';
import '../models/post_model.dart';

// --- Professional UI Color & Style Constants ---

const Color _primaryTextColor = Color(0xFF121212);
const Color _secondaryTextColor = Color(0xFF6C757D);
const Color _backgroundColor = Color(0xFFFFFFFF);
const Color _scaffoldBackgroundColor = Color(0xFFF4F6F8);
const Color _accentColor = Color(0xFF0F766E); // A teal accent for icons

// --- Spacing and Radii Constants ---
class _UIConstants {
  static const double horizontalPadding = 24.0;
  static const double sheetBorderRadius = 28.0;
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
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _apiService = RepositoryProvider.of<WordPressApiService>(context);
    _loadPost();
  }

  Future<void> _loadPost() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
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
      Share.share(
        'Read this: ${_post!.title.rendered}\n${_post!.link}',
        subject: _post!.title.rendered,
      );
    }
  }

  void _toggleBookmark() => setState(() => _isBookmarked = !_isBookmarked);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const _ModernLoadingView();
    }
    if (_error != null) {
      return _ModernErrorView(message: _error!, onRetry: _loadPost);
    }
    if (_post == null) {
      return _ModernNotFoundView(
        message: 'This article could not be found.',
        onBack: () => AppNavigation.goBack(context),
      );
    }
    
    // The core of the new design: A Stack
    return Stack(
      children: [
        // Layer 1: The background image
        _buildBackgroundImage(imageUrl: _post!.featuredImageUrl),
        
        // Layer 2: The draggable content sheet
        _buildContentSheet(context, post: _post!),
        
        // Layer 3: The floating toolbar
        _buildToolbar(
          onBack: () => AppNavigation.goBack(context),
          onBookmark: _toggleBookmark,
          isBookmarked: _isBookmarked,
        ),
      ],
    );
  }

  Widget _buildBackgroundImage({String? imageUrl}) {
    if (imageUrl == null) {
      return Container(color: Colors.grey.shade300);
    }
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.white, size: 60),
        ),
      ),
    );
  }

  Widget _buildToolbar({
    required VoidCallback onBack,
    required VoidCallback onBookmark,
    required bool isBookmarked,
  }) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ToolbarButton(icon: Icons.arrow_back, onPressed: onBack),
          _ToolbarButton(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            onPressed: onBookmark,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSheet(BuildContext context, {required PostModel post}) {
    // The sheet now starts at 96% and is locked in place,
    // prioritizing the reading content.
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      minChildSize: 0.93,
      maxChildSize: 0.93,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_UIConstants.sheetBorderRadius),
              topRight: Radius.circular(_UIConstants.sheetBorderRadius),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(_UIConstants.horizontalPadding),
            children: [
              // Header Section
              _buildPostHeader(context, post),
              const SizedBox(height: 16),
              
              // Body Content Section
              _buildPostContent(post.content.rendered),
            ],
          ),
        );
      },
    );
  }
}

// --- Rebuilt UI Components to Match Your Example ---

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(56),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

Widget _buildPostHeader(BuildContext context, PostModel post) {
  // Add a top padding equal to the toolbar height to prevent overlap
  final topPadding = MediaQuery.of(context).padding.top;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: topPadding + 44), // Space for the toolbar to be visible
      const SizedBox(height: 16),
      Text(
        post.title.rendered,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: _primaryTextColor,
          height: 1.3,
        ),
      ),
    ],
  );
}



Widget _buildPostContent(String htmlData) {
  return Html(
    data: htmlData,
    style: {
      'body': Style(
        fontSize: FontSize(16.0),
        lineHeight: const LineHeight(1.7),
        color: _primaryTextColor.withOpacity(0.85),
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      'p': Style(margin: Margins.only(bottom: 16)),
      'h1, h2, h3, h4, h5, h6': Style(
        fontWeight: FontWeight.bold,
        color: _primaryTextColor,
        margin: Margins.only(top: 24, bottom: 8),
      ),
      'a': Style(color: _accentColor, textDecoration: TextDecoration.none),
      'blockquote': Style(
        border: const Border(left: BorderSide(color: _accentColor, width: 3)),
        padding: HtmlPaddings.all(12),
        backgroundColor: _accentColor.withOpacity(0.05),
        fontStyle: FontStyle.italic,
      ),
    },
    onLinkTap: (url, context, attributes) {
      if (url != null) AppUtils.launchURL(url);
    },
  );
}


// --- Updated Loading and Error Views ---

class _ModernLoadingView extends StatelessWidget {
  const _ModernLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Stack(
        children: [
          Container(color: Colors.grey), // Background image placeholder
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height, // Full height
              padding: const EdgeInsets.all(_UIConstants.horizontalPadding),
              decoration: const BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_UIConstants.sheetBorderRadius),
                  topRight: Radius.circular(_UIConstants.sheetBorderRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80), // Space for toolbar
                  Container(height: 28, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 28, width: 200, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(height: 18, width: 150, color: Colors.white),
                ],
              ),
            ),
          )
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: _secondaryTextColor, size: 60),
            const SizedBox(height: 16),
            const Text('Something went wrong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryTextColor)),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: _secondaryTextColor, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
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
    // Similar to error view for consistency
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: _secondaryTextColor, size: 60),
            const SizedBox(height: 16),
            const Text('Article Not Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryTextColor)),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: _secondaryTextColor, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: TextButton.styleFrom(foregroundColor: _accentColor),
            )
          ],
        ),
      ),
    );
  }
}