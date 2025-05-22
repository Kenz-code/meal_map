import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_theme.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.surface,
    foregroundColor: lightColorScheme.onSurface,
    elevation: 0,
    centerTitle: true,

  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      textStyle: textTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightColorScheme.primary,
      textStyle: textTheme.labelLarge,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: lightColorScheme.primary,
      side: BorderSide(color: lightColorScheme.primary),
      textStyle: textTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  cardTheme: CardTheme(
    color: lightColorScheme.surfaceContainer,
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightColorScheme.surfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: lightColorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: lightColorScheme.primary),
    ),
    labelStyle: textTheme.bodyMedium?.copyWith(color: lightColorScheme.onSurface),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: lightColorScheme.surfaceVariant,
    contentTextStyle: textTheme.bodyMedium?.copyWith(color: lightColorScheme.onSurfaceVariant),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: lightColorScheme.surface,
    titleTextStyle: textTheme.headlineSmall?.copyWith(color: lightColorScheme.onSurface),
    contentTextStyle: textTheme.bodyLarge?.copyWith(color: lightColorScheme.onSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: darkTextTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.surface,
    foregroundColor: darkColorScheme.onSurface,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      textStyle: darkTextTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: darkColorScheme.primary,
      textStyle: darkTextTheme.labelLarge,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: darkColorScheme.primary,
      side: BorderSide(color: darkColorScheme.primary),
      textStyle: darkTextTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  cardTheme: CardTheme(
    color: darkColorScheme.surfaceContainer,
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkColorScheme.surfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: darkColorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: darkColorScheme.primary),
    ),
    labelStyle: darkTextTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurface),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkColorScheme.surfaceVariant,
    contentTextStyle: darkTextTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurfaceVariant),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: darkColorScheme.surface,
    titleTextStyle: darkTextTheme.headlineSmall?.copyWith(color: darkColorScheme.onSurface),
    contentTextStyle: darkTextTheme.bodyLarge?.copyWith(color: darkColorScheme.onSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
