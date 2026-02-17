import 'package:flutter/material.dart';

/// BibleSeek brand palette and semantic color tokens.
/// Use these in theme definition; elsewhere prefer Theme.of(context).colorScheme
/// or theme extensions for semantic colors.
abstract class AppColors {
  // Brand
  static const Color brandBlue = Color(0xFF7A8BB0);
  static const Color brandBlueStrong = Color(0xFF4F74C4);
  static const Color brandBlueLight = Color(0xFF8CB2C9);

  // Neutrals
  static const Color neutralGrey = Color(0xFF878583);

  // Warm accents
  static const Color warmTan = Color(0xFFA59F8C);
  static const Color accentWarm = Color(0xFFBF9D85);
  static const Color accentOrange = Color(0xFFFF9447);

  // Semantic
  static const Color likeRed = Color(0xFFDB4336);

  // Light/dark surface (minimal overrides; let M3 generate the rest)
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF0F0F0);
  static const Color onSurfaceLight = Color(0xFF1C1C1E);
  static const Color onSurfaceVariantLight = Color(0xFF6B6B6B);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2D2D2D);
  static const Color onSurfaceDark = Color(0xFFE8E8E8);
  static const Color onSurfaceVariantDark = Color(0xFFB0B0B0);
}
