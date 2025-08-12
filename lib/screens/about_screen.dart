// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui'; // Needed for ImageFilter.blur

import '../core/utils.dart'; // For AppUtils.launchURL
import '../routes/app_router.dart'; // For AppNavigation
import '../providers/pages_cubit.dart';
import '../models/page_model.dart';

// --- Centralized Modern UI Theme ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF4C6FFF); // Consistent blue accent

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const Color shimmerBase = Color(0xFFF0F2F5);
  static const Color shimmerHighlight = Colors.white;

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  static const double radiusL = 28.0; // Changed to 28.0 for consistency with contact_screen
}

/// About screen displaying information about the website
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PagesCubit>().loadPageBySlug('about-us'); // Use correct slug 'about-us'
    });
  }

  Future<void> _onRefresh() async {
    await context.read<PagesCubit>().loadPageBySlug('about-us');
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
        body: Stack(
          children: [
            _buildBackgroundImage(),
            _buildContentSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1504384308090-c89971002875?w=800'), // Placeholder image
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.black.withOpacity(0.1)),
      ),
    );
  }

  Widget _buildContentSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.95, // Start almost full screen
      minChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(_AppTheme.radiusL)),
          ),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: _AppTheme.primary,
                  onRefresh: _onRefresh,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: _AppTheme.spaceL),
                    children: [
                      const SizedBox(height: _AppTheme.spaceM),
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
                      const SizedBox(height: _AppTheme.spaceXL),
                      BlocBuilder<PagesCubit, PagesState>(
                        builder: (context, state) {
                          return state.when(
                            initial: () => const _AboutPageSkeleton(),
                            loading: () => const _AboutPageSkeleton(),
                            loaded: (page) => Column(
                              children: [
                                _buildHeader(page),
                                const SizedBox(height: _AppTheme.spaceXL),
                                _buildPageBody(page),
                                _buildMissionSection(),
                                _buildTeamSection(),
                              ],
                            ),
                            allLoaded: (_) => const Center(child: Text('Error: Multiple pages loaded.')),
                            error: (message) => _ModernErrorState(message: message, onRetry: _onRefresh),
                          );
                        },
                      ),
                      const SizedBox(height: _AppTheme.spaceXL),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(PageModel page) {
    return Column(
      children: [
        Text(
          page.title.rendered,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary, height: 1.2),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        const Text(
          'Discover Our Story and Mission',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: _AppTheme.textSecondary, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPageBody(PageModel page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _AppTheme.spaceL), // Adjusted padding
      child: Html(
        data: page.content.rendered,
        style: {
          'body, p': Style(
            fontSize: FontSize(16.0),
            lineHeight: const LineHeight(1.7),
            color: _AppTheme.textSecondary,
          ),
          'h1, h2, h3, h4, h5, h6': Style(
            fontSize: FontSize(20.0),
            fontWeight: FontWeight.bold,
            color: _AppTheme.textPrimary,
            margin: Margins.only(top: 24, bottom: 8),
          ),
        },
        onLinkTap: (url, _, _) => (url != null) ? AppUtils.launchURL(url) : null,
      ),
    );
  }

  Widget _buildMissionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: _AppTheme.spaceM), // Adjusted margin
      padding: const EdgeInsets.all(_AppTheme.spaceL),
      decoration: BoxDecoration(
        color: _AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        border: Border.all(color: _AppTheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Mission',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _AppTheme.primary),
          ),
          const SizedBox(height: _AppTheme.spaceM),
          _buildMissionPoint(
            icon: Icons.lightbulb_outline,
            text: 'To provide high-quality, informative, and engaging content in Bengali.',
          ),
          _buildMissionPoint(
            icon: Icons.school_outlined,
            text: 'To create an educational hub that enriches our readers\' knowledge.',
          ),
          _buildMissionPoint(
            icon: Icons.language,
            text: 'To promote and spread the beauty of the Bengali language worldwide.',
          ),
        ],
      ),
    );
  }
  
  Widget _buildMissionPoint({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _AppTheme.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _AppTheme.primary, size: 22),
          const SizedBox(width: _AppTheme.spaceM),
          Expanded(child: Text(text, style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 15, height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _AppTheme.spaceL), // Adjusted padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_AppTheme.spaceL, _AppTheme.spaceM, _AppTheme.spaceL, _AppTheme.spaceXL),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppUtils.launchURL('mailto:info@rohoshsholok.in');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 0,
              ),
              child: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: _AppTheme.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  AppNavigation.goBack(context); // Navigate back using the GoRouter's goBack logic
                },
                child: const Text('Back to Dashboard', style: TextStyle(color: _AppTheme.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const _TeamMemberCard({required this.name, required this.role, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      decoration: BoxDecoration(
        color: _AppTheme.surface,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
          const SizedBox(width: _AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(role, style: const TextStyle(color: _AppTheme.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AboutPageSkeleton extends StatelessWidget {
  const _AboutPageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _AppTheme.shimmerBase,
      highlightColor: _AppTheme.shimmerHighlight,
      child: Column( // Changed to Column as it's inside a ListView now
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 32, width: 250, color: Colors.white), // Placeholder for title
          const SizedBox(height: _AppTheme.spaceM),
          Container(height: 16, width: 300, color: Colors.white), // Placeholder for subtitle
          const SizedBox(height: _AppTheme.spaceXL),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: _AppTheme.spaceS),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: _AppTheme.spaceS),
          Container(height: 14, width: 150, color: Colors.white),
          const SizedBox(height: _AppTheme.spaceXL),
          Container(height: 22, width: 150, color: Colors.white), // Mission title
          const SizedBox(height: _AppTheme.spaceM),
          _buildMissionPointSkeleton(),
          _buildMissionPointSkeleton(),
          _buildMissionPointSkeleton(),
          const SizedBox(height: _AppTheme.spaceXL),
          Container(height: 22, width: 150, color: Colors.white), // Team title
          const SizedBox(height: _AppTheme.spaceM),
          _buildTeamMemberCardSkeleton(),
          const SizedBox(height: _AppTheme.spaceM),
          _buildTeamMemberCardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildMissionPointSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: _AppTheme.spaceM),
      child: Row(
        children: [
          Container(width: 22, height: 22, color: Colors.white),
          const SizedBox(width: _AppTheme.spaceM),
          Expanded(child: Container(height: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(_AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.white),
          const SizedBox(width: _AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 18, width: 120, color: Colors.white),
                const SizedBox(height: 4),
                Container(height: 14, width: 80, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ModernErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ModernErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: _AppTheme.textSecondary, size: 50),
            const SizedBox(height: _AppTheme.spaceM),
            const Text('An Error Occurred', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary)),
            const SizedBox(height: _AppTheme.spaceS),
            Text(message, style: const TextStyle(color: _AppTheme.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, style: ElevatedButton.styleFrom(backgroundColor: _AppTheme.primary, foregroundColor: Colors.white), child: const Text('Try Again'))
          ]
        )
      )
    );
  }
}
