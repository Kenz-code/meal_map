import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_map/core/theme/colors.dart';

final textTheme = TextTheme(
  displayLarge: GoogleFonts.dmSans(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  displayMedium: GoogleFonts.dmSans(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  displaySmall: GoogleFonts.dmSans(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  headlineLarge: GoogleFonts.dmSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  headlineMedium: GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  headlineSmall: GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  titleLarge: GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: lightColorScheme.onSurface,
  ),
  titleMedium: GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: lightColorScheme.onSurface,
  ),
  titleSmall: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: lightColorScheme.onSurface,
  ),
  bodyLarge: GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: lightColorScheme.onSurface,
  ),
  bodyMedium: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: lightColorScheme.onSurface,
  ),
  bodySmall: GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: lightColorScheme.onSurface,
  ),
  labelLarge: GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: lightColorScheme.onSurface,
  ),
  labelMedium: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onSurface,
  ),
  labelSmall: GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: lightColorScheme.onSurface,
  ),
);


final darkTextTheme = textTheme.apply(
  bodyColor: darkColorScheme.onSurface,
  displayColor: darkColorScheme.onSurface,
);

