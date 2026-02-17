import 'package:flutter/material.dart';

/// Centralized border radius constants.
abstract class AppRadius {
  static const double radius4 = 4;
  static const double radius5 = 5;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius14 = 14;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;
  static const double radius35 = 35;

  static BorderRadius get r4 => BorderRadius.circular(radius4);
  static BorderRadius get r5 => BorderRadius.circular(radius5);
  static BorderRadius get r8 => BorderRadius.circular(radius8);
  static BorderRadius get r12 => BorderRadius.circular(radius12);
  static BorderRadius get r14 => BorderRadius.circular(radius14);
  static BorderRadius get r16 => BorderRadius.circular(radius16);
  static BorderRadius get r20 => BorderRadius.circular(radius20);
  static BorderRadius get r24 => BorderRadius.circular(radius24);
  static BorderRadius get r35 => BorderRadius.circular(radius35);
}
