import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Soft Blue/Teal (professional and calming)
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryLight = Color(0xFF7AB5F5);
  static const Color primaryDark = Color(0xFF2E5C8A);

  // Secondary Colors - Warm Orange (for accents)
  static const Color secondary = Color(0xFFFF9F43);
  static const Color secondaryLight = Color(0xFFFFB976);
  static const Color secondaryDark = Color(0xFFE67E22);

  // Success, Warning, Error
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFF58D68D);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textDisabled = Color(0xFFBDC3C7);
  static const Color textHint = Color(0xFF95A5A6);

  // Border & Divider
  static const Color border = Color(0xFFE0E6ED);
  static const Color divider = Color(0xFFECF0F1);

  // Status Colors
  static const Color present = Color(0xFF2ECC71);
  static const Color late = Color(0xFFF39C12);
  static const Color absent = Color(0xFFE74C3C);
  static const Color halfDay = Color(0xFF3498DB);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );

  // Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
