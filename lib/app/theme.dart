import 'package:material_ui/material_ui.dart';

class AppColors {
  static const Color brandPrimary = Color(0xFF0F3D7A);
  static const Color brandSecondary = Color(0xFF1E64C8);
  static const Color brandTint = Color(0xFFDBEAFE);

  // Aliases kept for screen compatibility (mapped to Blue theme palette)
  static const Color brandDeepGreen = brandPrimary;
  static const Color brandTeal = brandSecondary;
  static const Color brandMint = brandTint;

  static const Color positiveGreen = Color(0xFF15803D);
  static const Color positiveBgLight = Color(0xFFDCFCE7);
  static const Color positiveBgDark = Color(0xFF14532D);

  static const Color negativeRed = Color(0xFFDC2626);
  static const Color negativeBgLight = Color(0xFFFEE2E2);
  static const Color negativeBgDark = Color(0xFF7F1D1D);

  static const Color warningAmber = Color(0xFFD97706);
  static const Color warningBgLight = Color(0xFFFEF3C7);
  static const Color warningBgDark = Color(0xFF78350F);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandSecondary,
      brightness: Brightness.light,
      surface: const Color(0xFFF8FAFC),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF3F6FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.brandDeepGreen,
            width: 1.8,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.brandMint,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandDeepGreen);
          }
          return IconThemeData(color: Colors.grey.shade600);
        }),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandTeal,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  static Color varianceColor(BuildContext context, double difference) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (difference >= 0) {
      return isDark ? const Color(0xFF4ADE80) : AppColors.positiveGreen;
    }
    return isDark ? const Color(0xFFF87171) : AppColors.negativeRed;
  }

  static Color varianceBackground(BuildContext context, double difference) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (difference >= 0) {
      return isDark ? AppColors.positiveBgDark : AppColors.positiveBgLight;
    }
    return isDark ? AppColors.negativeBgDark : AppColors.negativeBgLight;
  }
}
