import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF199A8E);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFFD7EFEC);
  static const Color accent = Color(0xFF24C5B5);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F8FA);
  static const Color inputFill = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF0E1012);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color danger = Color(0xFFEF5350);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF24C5B5), Color(0xFF199A8E)],
  );
}
