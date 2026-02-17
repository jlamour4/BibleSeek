import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized text styles. Use via theme or direct reference.
abstract class AppTextStyles {
  static TextStyle screenTitle(BuildContext context) => GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle verseRef(BuildContext context) => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle bodyText(BuildContext context) => GoogleFonts.roboto(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle metaText(BuildContext context) => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// Section heading (e.g. "Trending Topics")
  static TextStyle sectionTitle(BuildContext context) => GoogleFonts.roboto(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// Large body / button label
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
