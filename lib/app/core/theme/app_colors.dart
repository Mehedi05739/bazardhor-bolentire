import 'package:flutter/material.dart';

/// Centralized color palette for the app. A fresh "market" theme built around
/// a deep green primary with a warm amber accent.
abstract class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E8E5A);
  static const Color primaryDark = Color(0xFF14663F);
  static const Color accent = Color(0xFFF5A623);

  static const Color background = Color(0xFFF6F8F7);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A2421);
  static const Color textSecondary = Color(0xFF6B7C76);
  static const Color border = Color(0xFFE4EAE7);

  static const Color error = Color(0xFFD64545);
  static const Color success = Color(0xFF1E8E5A);

  /// Decorative gradients used on banners / placeholders.
  static const List<List<Color>> tileGradients = [
    [Color(0xFF1E8E5A), Color(0xFF34C77B)],
    [Color(0xFFF5A623), Color(0xFFF7C548)],
    [Color(0xFF3D7BFF), Color(0xFF6FA8FF)],
    [Color(0xFFB055D6), Color(0xFFD389F0)],
    [Color(0xFFE0556B), Color(0xFFF59AA8)],
  ];
}
