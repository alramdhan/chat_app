import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF799EFF);
  static const secondary = Color(0xFFFFDE63);
  static const kSecondary = Color(0xFFB6BBB8);

  static final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    secondary: secondary,
    brightness: Brightness.light,
  );
}