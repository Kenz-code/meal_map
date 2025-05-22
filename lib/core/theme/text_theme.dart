import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textTheme = TextTheme(
  displayLarge: GoogleFonts.dmSans(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: Colors.black,
  ),
  displayMedium: GoogleFonts.dmSans(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  displaySmall: GoogleFonts.dmSans(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  headlineLarge: GoogleFonts.dmSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  headlineMedium: GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  headlineSmall: GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  titleLarge: GoogleFonts.dmSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.black,
  ),
  titleMedium: GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: Colors.black,
  ),
  titleSmall: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black,
  ),
  bodyLarge: GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: Colors.black,
  ),
  bodyMedium: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: Colors.black,
  ),
  bodySmall: GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: Colors.black,
  ),
  labelLarge: GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black,
  ),
  labelMedium: GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.black,
  ),
  labelSmall: GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.black,
  ),
);

final darkTextTheme = textTheme.apply(
  bodyColor: Colors.white,
  displayColor: Colors.white,
);

