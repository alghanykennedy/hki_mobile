import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette (Dark Navy)
  // TODO: verify against Figma
  static const Color primary = Color(0xFF233A5E);
  static const Color primaryDark = Color(0xFF182A45);
  static const Color primaryLight = Color(0xFF355280);

  // Backgrounds & Surface
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color sheetHandle = Color(0xFFD9D9D9); // Gray handle on top of bottom sheet

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnDark = Colors.white;
  static const Color textOnDarkSecondary = Color(0xFFCBD5E1);

  // Form / Border / Inputs
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF233A5E);
  static const Color inputBackground = Colors.white;
  static const Color hint = Color(0xFF94A3B8);

  // Status & Feedback
  static const Color error = Color(0xFFDC2626);
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color success = Color(0xFF16A34A);
  static const Color successBackground = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF2563EB);

  // Offline banner
  static const Color offline = Color(0xFFEF4444);
  static const Color online = Color(0xFF10B981);

  // Disabled
  static const Color disabled = Color(0xFFCBD5E1);
  static const Color disabledText = Color(0xFF94A3B8);
}
