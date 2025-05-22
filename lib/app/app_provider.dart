import 'package:flutter/material.dart';
import 'package:meal_map/core/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeMode get currentMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
