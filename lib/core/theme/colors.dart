import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: Color(0xFF40C057), // green-6
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD3F9D8), // green-1
  onPrimaryContainer: Color(0xFF2B8A3E), // green-8

  // Secondary
  secondary: Color(0xFF1098AD), // cyan-7
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE3FAFC), // cyan-1
  onSecondaryContainer: Color(0xFF0C8599), // cyan-8

  // Tertiary
  tertiary: Color(0xFF7950F2), // violet-6
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFF3F0FF), // violet-1
  onTertiaryContainer: Color(0xFF5F3DC4), // violet-8

  // Surface & Background
  surface: Colors.white,
  onSurface: Color(0xFF212529), // gray-9
  surfaceContainer: Color(0xFFF8F9FA), // gray-0
  onSurfaceVariant: Color(0xFF495057), // gray-7

  // Surface Variant & Outline
  surfaceVariant: Color(0xFFE9ECEF), // gray-1
  outline: Color(0xFFADB5BD), // gray-5

  // Error
  error: Color(0xFFFA5252), // red-6
  onError: Colors.white,
  errorContainer: Color(0xFFFFE3E3), // red-1
  onErrorContainer: Color(0xFFC92A2A), // red-8

  // Shadow
  shadow: Colors.black,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: Color(0xFF69DB7C), // green-4
  onPrimary: Color(0xFF1B1C1E), // dark base
  primaryContainer: Color(0xFF2B8A3E), // green-8
  onPrimaryContainer: Color(0xFFB2F2BB), // green-2

  // Secondary
  secondary: Color(0xFF22B8CF), // cyan-5
  onSecondary: Color(0xFF1B1C1E),
  secondaryContainer: Color(0xFF0B7285), // cyan-9
  onSecondaryContainer: Color(0xFFC5F6FA), // cyan-2

  // Tertiary
  tertiary: Color(0xFF9775FA), // violet-5
  onTertiary: Color(0xFF1B1C1E),
  tertiaryContainer: Color(0xFF5F3DC4), // violet-8
  onTertiaryContainer: Color(0xFFD0BFFF), // violet-2

  // Surface & Surface Container
  surface: Color(0xFF1E1E1E), // dark custom
  onSurface: Color(0xFFF1F3F5), // gray-1
  surfaceContainer: Color(0xFF343A40), // gray-8
  onSurfaceVariant: Color(0xFFCED4DA), // gray-3

  // Surface Variant & Outline
  surfaceVariant: Color(0xFF495057), // gray-7
  outline: Color(0xFF868E96), // gray-6

  // Error
  error: Color(0xFFFF6B6B), // red-5
  onError: Color(0xFF1B1C1E),
  errorContainer: Color(0xFFC92A2A), // red-8
  onErrorContainer: Color(0xFFFFC9C9), // red-2

  // Shadow
  shadow: Colors.black,
);
