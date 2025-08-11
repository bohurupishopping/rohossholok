// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'dart:ui'; // Needed for ImageFilter.blur

import '../core/utils.dart'; // For AppUtils.launchURL
import '../routes/app_router.dart'; // For AppNavigation

// --- Centralized Modern UI Theme ---
class _AppTheme {
  static const Color scaffoldBg = Color(0xFFF6F8FD);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF4C6FFF); // Consistent blue accent

  static const Color textPrimary = Color(0xFF1B1D28);
  static const Color textSecondary = Color(0xFF7D7F8B);

  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  static const double radiusL = 28.0;
}


/// Contact screen displaying contact information and form
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
    // Load contact page content if needed, though this design focuses on hardcoded info.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<PagesCubit>().loadPageBySlug('contact-us');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppTheme.scaffoldBg,
      // We don't use a traditional AppBar in this design
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildContentSheet(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    // Using a placeholder image for the background
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1557683316-973673baf926?w=800'),
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
                    _buildHeader(),
                    const SizedBox(height: _AppTheme.spaceXL),
                    _buildContactInfoCards(),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Get In Touch With Us',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _AppTheme.textPrimary, height: 1.2),
        ),
        SizedBox(height: _AppTheme.spaceM),
        Text(
          'Have a question or feedback? We’d love to hear from you. Reach out to us anytime.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: _AppTheme.textSecondary, height: 1.5),
        ),
      ],
    );
  }
  
  Widget _buildContactInfoCards() {
    return Column(
      children: [
        _ContactInfoCard(
          icon: Icons.email_outlined,
          title: 'Email Us',
          subtitle: 'info@rohoshsholok.in',
          onTap: () => AppUtils.launchURL('mailto:pritam@bohurupi.com'),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        _ContactInfoCard(
          icon: Icons.phone_outlined,
          title: 'Website',
          subtitle: 'https://rohossholok.in',
          onTap: () => AppUtils.launchURL('tel:+15551234567'),
        ),
        const SizedBox(height: _AppTheme.spaceM),
        const _ContactInfoCard(
          icon: Icons.location_on_outlined,
          title: 'App related queries',
          subtitle: 'pritam@bohurupi.com',
        ),
      ],
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
                // This could open a mail client or a contact form page.
                AppUtils.launchURL('mailto:pritam@bohurupi.com');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 0,
              ),
              child: const Text('Send an Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(_AppTheme.radiusL),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(_AppTheme.spaceM),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _AppTheme.primary.withOpacity(0.1),
                  child: Icon(icon, color: _AppTheme.primary),
                ),
                const SizedBox(width: _AppTheme.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: _AppTheme.textPrimary, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: _AppTheme.textSecondary, fontSize: 14)),
                    ],
                  ),
                ),
                if(onTap != null)
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
