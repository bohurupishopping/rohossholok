// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

/// App theme configuration with Bengali-friendly design
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    const ColorScheme colorScheme = ColorScheme.light(
      // Primary colors - Deep blue for mystery theme
      primary: Color(AppColors.primaryBlue),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFBBDEFB), // Light blue
      onPrimaryContainer: Color(0xFF0D47A1), // Dark blue
      // Secondary colors - Warm orange for accent
      secondary: Color(AppColors.accentOrange),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE0B2), // Light orange
      onSecondaryContainer: Color(0xFFE65100), // Dark orange
      // Surface colors
      surface: Colors.white,
      onSurface: Color(AppColors.neutral800),
      surfaceContainerHighest: Color(AppColors.neutral200),
      onSurfaceVariant: Color(0xFF757575), // Medium grey
      // Background colors
      background: Color(0xFFFAFAFA), // Very light grey
      onBackground: Color(AppColors.neutral800),

      // Error colors
      error: Color(AppColors.error),
      onError: Colors.white,
      errorContainer: Color(0xFFFFEBEE), // Light red
      onErrorContainer: Color(0xFFB71C1C), // Dark red
      // Outline and shadow
      outline: Color(0xFFBDBDBD), // Light grey for borders
      shadow: Colors.black,

      // Inverse colors
      inverseSurface: Color(0xFF303030), // Dark grey
      onInverseSurface: Colors.white,
      inversePrimary: Color(0xFF90CAF9), // Light blue
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography
      textTheme: _buildTextTheme(colorScheme),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppConstants.elevationLow,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.titleLarge,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppConstants.iconSizeMedium,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: AppConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: AppConstants.elevationMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.bengaliFont,
            fontSize: AppTypography.bodyLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.bengaliFont,
            fontSize: AppTypography.bodyMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.bengaliFont,
            fontSize: AppTypography.bodyLarge,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodyMedium,
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodyMedium,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodySmall,
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodySmall,
          color: colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
          vertical: AppConstants.paddingSmall / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),

      // Drawer Theme
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppConstants.elevationHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstants.borderRadiusLarge),
            bottomRight: Radius.circular(AppConstants.borderRadiusLarge),
          ),
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodyLarge,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.bodyMedium,
          color: colorScheme.onSurfaceVariant,
        ),
        iconColor: colorScheme.onSurfaceVariant,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: AppConstants.elevationMedium,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.labelSmall,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTypography.bengaliFont,
          fontSize: AppTypography.labelSmall,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: AppConstants.iconSizeMedium,
      ),

      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: AppConstants.iconSizeMedium,
      ),
    );
  }

  /// Build text theme with Bengali font support
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.headlineLarge,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.headlineMedium,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.headlineSmall,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.titleLarge,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.titleMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.titleSmall,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.bodyLarge,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.bodyMedium,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.bodySmall,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurfaceVariant,
        height: 1.3,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.labelMedium,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: AppTypography.bengaliFont,
        fontSize: AppTypography.labelSmall,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Custom colors for specific use cases
class AppCustomColors {
  static const Color categoryChipBackground = Color(0xFFE8F4FD);
  static const Color categoryChipText = Color(0xFF1565C0);
  static const Color postMetaText = Color(0xFF757575);
  static const Color readingTimeBackground = Color(0xFFFFF3E0);
  static const Color readingTimeText = Color(0xFFE65100);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color shadowLight = Color(0x1A000000);
}
