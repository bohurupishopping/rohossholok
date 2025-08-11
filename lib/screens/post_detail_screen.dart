// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart'; // Add this dependency for the shimmer effect
import '../core/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../routes/app_router.dart';
import '../services/wordpress_api_service.dart';
import '../models/post_model.dart';

// --- A centralized theme class for a modern, consistent UI ---
class _AppTheme {
  // Colors
  static const Color primary = Color(0xFF0D9488); // Teal
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFDC2626);

  // Placeholders
  static const Color placeholderBase = Color(0xFFE2E8F0);
  static const Color placeholderHighlight = Color(0xFFF1F5F9);

  // Spacing & Radii
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
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
    // Preserve existing state while refetching
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    
    try {
      final post = await _apiService.getPost(widget.postId);
      if (mounted) setState(() => _post = post);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  void _sharePost() {
    if (_post != null) {
      Share.share('${_post!.title.rendered}\n\n${_post!.link}', subject: _post!.title.rendered);
    }
  }
  
  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_isBookmarked ? 'বুকমার্ক করা হয়েছে' : 'বুকমার্ক সরানো হয়েছে'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_AppTheme.radiusM)),
        margin: const EdgeInsets.all(_AppTheme.spaceM),
      ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isLoading) return const CustomAppBar(title: 'লোড হচ্ছে...');
    if (_error != null) return const CustomAppBar(title: 'ত্রুটি');
    if (_post == null) return const CustomAppBar(title: 'পোস্ট পাওয়া যায়নি');
    
    return PostDetailAppBar(
      title: _post!.title.rendered,
      onShare: _sharePost,
      onBookmark: _toggleBookmark,
      isBookmarked: _isBookmarked,
      onBack: () => AppNavigation.goBack(context),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const _LoadingView();
    if (_error != null) return _ErrorView(message: _error!, onRetry: _loadPost);
    if (_post == null) return const _NotFoundView(message: 'এই পোস্টটি পাওয়া যায়নি।');
    
    return _PostContentView(post: _post!);
  }
}

// --- Main Content View ---

class _PostContentView extends StatelessWidget {
  final PostModel post;
  const _PostContentView({required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: _AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.featuredImageUrl != null)
            _FeaturedImage(imageUrl: post.featuredImageUrl!),
          _PostHeader(post: post),
          _PostHtmlContent(htmlData: post.content.rendered),
          _PostInfoCard(post: post),
          const _RelatedPostsSection(),
        ],
      ),
    );
  }
}

// --- UI Components ---

class _FeaturedImage extends StatelessWidget {
  final String imageUrl;
  const _FeaturedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const _ImagePlaceholder(),
            errorWidget: (context, url, error) => const _ImageError(),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostModel post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title.rendered,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _AppTheme.textPrimary, height: 1.3),
          ),
          const SizedBox(height: _AppTheme.spaceM),
          Wrap(
            spacing: _AppTheme.spaceS,
            runSpacing: _AppTheme.spaceS,
            children: [
              _PostMetaChip(icon: Icons.calendar_today_outlined, text: post.getFormattedDate()),
              _PostMetaChip(icon: Icons.access_time, text: '${post.getEstimatedReadingTime()} মিনিট পড়ার সময়'),
              if (post.getAuthorName().isNotEmpty)
                _PostMetaChip(icon: Icons.person_outline, text: post.getAuthorName()),
            ],
          ),
          const SizedBox(height: _AppTheme.spaceS),
          if (post.getCategoryNames().isNotEmpty)
            _CategoryChips(categories: post.getCategoryNames()),
        ],
      ),
    );
  }
}

class _PostMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _PostMetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceS, vertical: 6),
      decoration: BoxDecoration(
        color: _AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(_AppTheme.radiusM),
        border: Border.all(color: _AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: _AppTheme.textSecondary, fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  const _CategoryChips({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: _AppTheme.spaceS),
      child: Wrap(
        spacing: _AppTheme.spaceS,
        runSpacing: _AppTheme.spaceS,
        children: categories.map((name) => Chip(
          label: Text(name),
          avatar: const Icon(Icons.tag, size: 14, color: _AppTheme.primary),
          backgroundColor: _AppTheme.primary.withOpacity(0.1),
          labelStyle: const TextStyle(color: _AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
          padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceS),
          side: BorderSide.none,
        )).toList(),
      ),
    );
  }
}

class _PostHtmlContent extends StatelessWidget {
  final String htmlData;
  const _PostHtmlContent({required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        'body': Style(fontSize: FontSize(16.0), lineHeight: const LineHeight(1.7), color: _AppTheme.textPrimary, margin: Margins.all(_AppTheme.spaceM), padding: HtmlPaddings.zero),
        'p': Style(margin: Margins.only(bottom: _AppTheme.spaceM)),
        'h1, h2, h3, h4, h5, h6': Style(fontWeight: FontWeight.bold, margin: Margins.only(top: _AppTheme.spaceL, bottom: _AppTheme.spaceS)),
        'blockquote': Style(
          border: const Border(left: BorderSide(color: _AppTheme.primary, width: 4)),
          padding: HtmlPaddings.only(left: _AppTheme.spaceM),
          margin: Margins.symmetric(vertical: _AppTheme.spaceM),
          backgroundColor: _AppTheme.surfaceContainer,
        ),
        'code': Style(backgroundColor: _AppTheme.surfaceContainer, fontFamily: 'monospace', padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2)),
        'pre': Style(backgroundColor: _AppTheme.surfaceContainer, padding: HtmlPaddings.all(_AppTheme.spaceM), margin: Margins.symmetric(vertical: _AppTheme.spaceM)),
      },
      onLinkTap: (url, _, __) => (url != null) ? AppUtils.launchURL(url) : null,
    );
  }
}

class _PostInfoCard extends StatelessWidget {
  final PostModel post;
  const _PostInfoCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      child: Container(
        padding: const EdgeInsets.all(_AppTheme.spaceL),
        decoration: BoxDecoration(
          color: _AppTheme.surface,
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          border: Border.all(color: _AppTheme.border),
        ),
        child: Column(
          children: [
            const _SectionHeader(icon: Icons.info_outline_rounded, title: 'পোস্ট তথ্য'),
            const SizedBox(height: _AppTheme.spaceM),
            _InfoRow(label: 'প্রকাশিত', value: post.getFormattedDate(), icon: Icons.calendar_today_outlined),
            _InfoRow(label: 'আপডেট', value: post.getFormattedModifiedDate(), icon: Icons.update_outlined),
            if (post.getAuthorName().isNotEmpty)
              _InfoRow(label: 'লেখক', value: post.getAuthorName(), icon: Icons.person_outline),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _AppTheme.spaceS),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _AppTheme.textSecondary),
          const SizedBox(width: _AppTheme.spaceM),
          Text(label, style: const TextStyle(color: _AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: _AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _RelatedPostsSection extends StatelessWidget {
  const _RelatedPostsSection();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(icon: Icons.article_outlined, title: 'সম্পর্কিত পোস্ট'),
          const SizedBox(height: _AppTheme.spaceM),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(_AppTheme.spaceL),
            decoration: BoxDecoration(
              color: _AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(_AppTheme.radiusL),
              border: Border.all(color: _AppTheme.border),
            ),
            child: const Center(
              child: Text('সম্পর্কিত পোস্ট শীঘ্রই আসছে...', style: TextStyle(fontStyle: FontStyle.italic, color: _AppTheme.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _AppTheme.primary),
        const SizedBox(width: _AppTheme.spaceS),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
      ],
    );
  }
}

// --- Image Placeholder & Error Widgets ---

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.placeholderBase,
      highlightColor: _AppTheme.placeholderHighlight,
      child: Container(color: _AppTheme.surface),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppTheme.surfaceContainer,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 48, color: _AppTheme.textSecondary),
          SizedBox(height: _AppTheme.spaceS),
          Text('ছবি লোড করা যায়নি', style: TextStyle(color: _AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

// --- State Views (Loading, Error, Not Found) ---

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.placeholderBase,
      highlightColor: _AppTheme.placeholderHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(_AppTheme.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusL))),
            const SizedBox(height: _AppTheme.spaceM),
            Container(height: 32, width: double.infinity, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
            const SizedBox(height: _AppTheme.spaceS),
            Container(height: 24, width: 200, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
            const SizedBox(height: _AppTheme.spaceL),
            Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
            const SizedBox(height: _AppTheme.spaceS),
            Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
            const SizedBox(height: _AppTheme.spaceS),
            Container(height: 16, width: 250, decoration: BoxDecoration(color: _AppTheme.surface, borderRadius: BorderRadius.circular(_AppTheme.radiusM))),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_AppTheme.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 60, color: _AppTheme.error),
            const SizedBox(height: _AppTheme.spaceM),
            const Text('ত্রুটি', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
            const SizedBox(height: _AppTheme.spaceS),
            Text(message, style: const TextStyle(fontSize: 14, color: _AppTheme.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: _AppTheme.spaceL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('আবার চেষ্টা করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_AppTheme.radiusM)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  final String message;
  const _NotFoundView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 60, color: _AppTheme.textSecondary),
          const SizedBox(height: _AppTheme.spaceM),
          const Text('পোস্ট পাওয়া যায়নি', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
          const SizedBox(height: _AppTheme.spaceS),
          Text(message, style: const TextStyle(fontSize: 14, color: _AppTheme.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}