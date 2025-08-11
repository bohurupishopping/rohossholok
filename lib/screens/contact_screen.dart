import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_widget.dart';
import '../providers/pages_cubit.dart';

import '../models/page_model.dart';

/// Contact screen displaying contact information and form
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    
    // Load contact page content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PagesCubit>().loadPageBySlug('contact');
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'যোগাযোগ',
        showSearch: false,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PagesCubit>().loadPageBySlug('contact');
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildContactHeader(),
              BlocBuilder<PagesCubit, PagesState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppConstants.paddingMedium),
                        child: LoadingSpinner(),
                      ),
                    ),
                    loaded: (page) => _buildPageContent(page),
                    allLoaded: (pages) => const SizedBox.shrink(),
                    error: (message) => Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: AppErrorWidget(
                        message: message,
                        onRetry: () => context.read<PagesCubit>().loadPageBySlug('contact'),
                      ),
                    ),
                  );
                },
              ),
              _buildContactInfo(),
              _buildContactForm(),
              _buildSocialLinks(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildContactHeader() {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
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
          Icon(
            Icons.contact_mail,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'যোগাযোগ করুন',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'আমাদের সাথে যোগাযোগ করুন এবং আপনার মতামত জানান',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPageContent(PageModel page) {
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
        },
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            AppUtils.launchURL(url);
          }
        },
      ),
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
            'যোগাযোগের তথ্য',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildContactInfoItem(
            icon: Icons.web,
            title: 'ওয়েবসাইট',
            subtitle: 'rohossholok.in',
            onTap: () => AppUtils.launchURL('https://rohossholok.in'),
          ),
          _buildContactInfoItem(
            icon: Icons.email,
            title: 'ইমেইল',
            subtitle: 'contact@rohossholok.in',
            onTap: () => AppUtils.launchURL('mailto:contact@rohossholok.in'),
          ),
          _buildContactInfoItem(
            icon: Icons.phone,
            title: 'ফোন',
            subtitle: '+880 1XXX-XXXXXX',
            onTap: () => AppUtils.launchURL('tel:+8801XXXXXXXX'),
          ),
          _buildContactInfoItem(
            icon: Icons.location_on,
            title: 'ঠিকানা',
            subtitle: 'ঢাকা, বাংলাদেশ',
            onTap: null,
          ),
          _buildContactInfoItem(
            icon: Icons.access_time,
            title: 'কার্যসময়',
            subtitle: 'সকাল ৯টা - সন্ধ্যা ৬টা (রবি-বৃহস্পতি)',
            onTap: null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
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
  
  Widget _buildContactForm() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আমাদের কাছে বার্তা পাঠান',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildTextField(
              controller: _nameController,
              label: 'নাম *',
              hint: 'আপনার পূর্ণ নাম লিখুন',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'নাম প্রয়োজন';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildTextField(
              controller: _emailController,
              label: 'ইমেইল *',
              hint: 'আপনার ইমেইল ঠিকানা লিখুন',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'ইমেইল প্রয়োজন';
                }
                if (!AppUtils.isValidEmail(value)) {
                  return 'সঠিক ইমেইল ঠিকানা লিখুন';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildTextField(
              controller: _subjectController,
              label: 'বিষয় *',
              hint: 'বার্তার বিষয় লিখুন',
              icon: Icons.subject,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'বিষয় প্রয়োজন';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            _buildTextField(
              controller: _messageController,
              label: 'বার্তা *',
              hint: 'আপনার বার্তা লিখুন',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'বার্তা প্রয়োজন';
                }
                if (value.trim().length < 10) {
                  return 'বার্তা কমপক্ষে ১০ অক্ষরের হতে হবে';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'বার্তা পাঠান',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('আপনার বার্তা সফলভাবে পাঠানো হয়েছে!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('বার্তা পাঠাতে সমস্যা হয়েছে: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  Widget _buildSocialLinks() {
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
        children: [
          Text(
            'সোশ্যাল মিডিয়ায় আমাদের ফলো করুন',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => AppUtils.launchURL('https://facebook.com/rohossholok'),
              ),
              _buildSocialButton(
                icon: Icons.alternate_email,
                label: 'Twitter',
                color: const Color(0xFF1DA1F2),
                onTap: () => AppUtils.launchURL('https://twitter.com/rohossholok'),
              ),
              _buildSocialButton(
                icon: Icons.camera_alt,
                label: 'Instagram',
                color: const Color(0xFFE4405F),
                onTap: () => AppUtils.launchURL('https://instagram.com/rohossholok'),
              ),
              _buildSocialButton(
                icon: Icons.video_library,
                label: 'YouTube',
                color: const Color(0xFFFF0000),
                onTap: () => AppUtils.launchURL('https://youtube.com/@rohossholok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall / 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}