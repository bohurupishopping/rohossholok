import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Reusable error widget for displaying error states
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryButtonText;
  final bool showRetryButton;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryButtonText,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SelectableText.rich(
              TextSpan(
                text: message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'আবার চেষ্টা করুন'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message:
          'ইন্টারনেট সংযোগ নেই। অনুগ্রহ করে আপনার ইন্টারনেট সংযোগ পরীক্ষা করুন।',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      retryButtonText: 'আবার চেষ্টা করুন',
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message:
          'সার্ভারে সমস্যা হয়েছে। অনুগ্রহ করে কিছুক্ষণ পর আবার চেষ্টা করুন।',
      icon: Icons.cloud_off,
      onRetry: onRetry,
      retryButtonText: 'আবার চেষ্টা করুন',
    );
  }
}

/// Not found error widget
class NotFoundWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onGoBack;

  const NotFoundWidget({super.key, this.message, this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: message ?? 'কোনো তথ্য পাওয়া যায়নি।',
      icon: Icons.search_off,
      onRetry: onGoBack,
      retryButtonText: 'ফিরে যান',
      showRetryButton: onGoBack != null,
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionButtonText;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.onAction,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionButtonText != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionButtonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// No posts widget
class NoPostsWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoPostsWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: 'এই বিভাগে কোনো পোস্ট নেই।',
      icon: Icons.article_outlined,
      onAction: onRefresh,
      actionButtonText: 'রিফ্রেশ করুন',
    );
  }
}

/// No categories widget
class NoCategoriesWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoCategoriesWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: 'কোনো বিভাগ পাওয়া যায়নি।',
      icon: Icons.category_outlined,
      onAction: onRefresh,
      actionButtonText: 'রিফ্রেশ করুন',
    );
  }
}

/// Modern search no results widget
class SearchNoResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const SearchNoResultsWidget({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'কোনো ফলাফল পাওয়া যায়নি',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                children: [
                  const TextSpan(text: '"'),
                  TextSpan(
                    text: searchQuery,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '" এর জন্য কোনো ফলাফল পাওয়া যায়নি।\nঅন্য কিছু খুঁজে দেখুন।',
                  ),
                ],
              ),
            ),
            if (onClearSearch != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('নতুন অনুসন্ধান'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
