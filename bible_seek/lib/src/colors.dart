import 'package:flutter/material.dart';

import 'package:bible_seek/src/design/app_colors.dart';

/// @deprecated Use AppColors or Theme.of(context).colorScheme instead.
class AppColor {
  static Color get kPrimary => AppColors.brandBlue;
  static Color get kWhite => Colors.white;
  static Color get kBackground => AppColors.backgroundLight;
  static Color get kGrayscaleDark100 => AppColors.onSurfaceLight;
  static Color get kLine => const Color(0xFFEBEBEB);
  static Color get kBackground2 => AppColors.surfaceVariantLight;
  static Color get kGrayscale40 => AppColors.onSurfaceVariantLight;
  static Color get kOffWhite => const Color(0xFFF1F1F1);
  static Color get kTan => AppColors.warmTan;
  static Color get kBlue => AppColors.brandBlue;
  static Color get kDark => AppColors.neutralGrey;
}
