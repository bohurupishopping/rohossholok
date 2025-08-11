import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
import '../providers/pages_cubit.dart';

import '../models/page_model.dart';

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
    
    // Load about page content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PagesCubit>().loadPageBySlug('about');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'আমাদের সম্পর্কে',
        showSearch: false,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PagesCubit>().loadPageBySlug('about');
        },
        child: BlocBuilder<PagesCubit, PagesState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: LoadingSpinner()),
              loading: () => const Center(child: LoadingSpinner()),
              loaded: (page) => _buildPageContent(page),
              allLoaded: (pages) => const Center(
                child: Text('একাধিক পৃষ্ঠা লোড হয়েছে'),
              ),
              error: (message) => AppErrorWidget(
                message: message,
                onRetry: () => context.read<PagesCubit>().loadPageBySlug('about'),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPageContent(PageModel page) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(page),
          _buildPageBody(page),
          _buildTeamSection(),
          _buildMissionSection(),
          _buildContactInfo(),
        ],
      ),
    );
  }
  
  Widget _buildPageHeader(PageModel page) {
    final theme = Theme.of(context);
    final featuredImageUrl = page.featuredImageUrl;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          if (featuredImageUrl != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: CachedNetworkImage(
                  imageUrl: featuredImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(child: LoadingSpinner()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: [
                Text(
                  page.title.rendered,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'রহস্যলোক - বাংলা ব্লগের জগত',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPageBody(PageModel page) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Html(
        data: page.content.rendered,
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
        },
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            AppUtils.launchURL(url);
          }
        },
      ),
    );
  }
  
  Widget _buildTeamSection() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আমাদের টিম',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildTeamMember(
            name: 'রহস্যলোক টিম',
            role: 'কন্টেন্ট ক্রিয়েটর ও ডেভেলপার',
            description: 'বাংলা ভাষায় মানসম্পন্ন কন্টেন্ট তৈরি এবং ওয়েবসাইট রক্ষণাবেক্ষণের দায়িত্বে রয়েছেন।',
            avatar: Icons.group,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTeamMember({
    required String name,
    required String role,
    required String description,
    required IconData avatar,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                avatar,
                size: 30,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    role,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMissionSection() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'আমাদের লক্ষ্য',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'রহস্যলোক একটি বাংলা ব্লগ প্ল্যাটফর্ম যার মূল উদ্দেশ্য হলো বাংলা ভাষায় মানসম্পন্ন, তথ্যবহুল এবং আকর্ষণীয় কন্টেন্ট প্রদান করা। আমরা বিভিন্ন বিষয়ে লেখালেখি করি যা পাঠকদের জ্ঞান বৃদ্ধিতে সহায়তা করে।',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildMissionPoints(),
        ],
      ),
    );
  }
  
  Widget _buildMissionPoints() {
    final theme = Theme.of(context);
    final points = [
      'মানসম্পন্ন বাংলা কন্টেন্ট তৈরি',
      'তথ্যবহুল এবং শিক্ষামূলক লেখা',
      'পাঠকদের সাথে ইন্টারঅ্যাক্টিভ সম্পর্ক',
      'বাংলা ভাষার প্রচার ও প্রসার',
    ];
    
    return Column(
      children: points.map(
        (point) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingSmall / 2,
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  point,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
  
  Widget _buildContactInfo() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'যোগাযোগ করুন',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildContactItem(
            icon: Icons.web,
            title: 'ওয়েবসাইট',
            subtitle: 'rohossholok.in',
            onTap: () => AppUtils.launchURL('https://rohossholok.in'),
          ),
          _buildContactItem(
            icon: Icons.email,
            title: 'ইমেইল',
            subtitle: 'contact@rohossholok.in',
            onTap: () => AppUtils.launchURL('mailto:contact@rohossholok.in'),
          ),
          _buildContactItem(
            icon: Icons.location_on,
            title: 'ঠিকানা',
            subtitle: 'বাংলাদেশ',
            onTap: null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: onTap != null ? theme.colorScheme.primary : null,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}