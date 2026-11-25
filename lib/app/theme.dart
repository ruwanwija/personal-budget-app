import 'package:material_ui/material_ui.dart';

class AppColors {
  static const Color brandDeepGreen = Color(0xFF1B3B36);
  static const Color brandTeal = Color(0xFF2A6F68);
  static const Color brandMint = Color(0xFFDCF2EC);

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
      seedColor: AppColors.brandDeepGreen,
      primary: AppColors.brandDeepGreen,
      secondary: AppColors.brandTeal,
      brightness: Brightness.light,
      surface: const Color(0xFFF7F9F8),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF4F7F6),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.brandDeepGreen,
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
