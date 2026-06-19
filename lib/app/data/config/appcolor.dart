import 'package:flutter/material.dart';

class AppColor {
  // 🔹 Base Background
  static const Color backgroundColor = Color(0xFFFDF6EC);
  static const Color backgroundColorLight = Color(0xFFFFFBF5);

  // 🔹 Primary Button Colors
  static const Color buttonOneColor = Color(0xFFB96237); // Warm brown/orange
  static const Color buttonTwoColor = Color(0xFF113650); // Deep navy

  // 🔹 Extended Palette
  static const Color primaryDark = Color(0xFF0D2B40);
  static const Color accent = Color(0xFFD4845A);
  static const Color accentLight = Color(0xFFE8B898);

  // 🔹 Text Colors
  static const Color textPrimary = Color(0xFF2E3A59);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = Colors.white;

  // 🔹 Card / Surface
  static const Color cardColor = Colors.white;
  static const Color cardBorder = Color(0xFFF0E6D8);
  static const Color surfaceColor = Color(0xFFFFF8F0);

  // 🔹 Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF9A825);

  // 🔹 AppBar
  static const Color appBarColor = buttonOneColor;

  // 🔹 Shimmer Base Colors
  static const Color shimmerBase = Color(0xFFF0E6D8);
  static const Color shimmerHighlight = Color(0xFFFDF6EC);

  // 🔹 Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB96237), Color(0xFFD4845A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF113650), Color(0xFF1A4F72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFDF6EC), Color(0xFFFFFBF5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 🔹 Shadows
  static BoxShadow softShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  static BoxShadow buttonShadow = BoxShadow(
    color: const Color(0xFFB96237).withValues(alpha: 0.3),
    blurRadius: 12,
    offset: const Offset(0, 6),
  );

  static BoxShadow buttonShadowNavy = BoxShadow(
    color: const Color(0xFF113650).withValues(alpha: 0.3),
    blurRadius: 12,
    offset: const Offset(0, 6),
  );
}
