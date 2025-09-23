import 'package:flutter/material.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/theme/theme.dart';
import 'dart:async';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  ThemeMode get currentMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class AppStateNotifier extends ChangeNotifier {
  bool _initialized = false;
  bool _isFirstLaunch = true;
  bool _isLoggedIn = false;

  bool get initialized => _initialized;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoggedIn => _isLoggedIn;

  AppStateNotifier() {
    _init();
  }

  Future<void> _init() async {
    // final prefs = await SharedPreferences.getInstance();
    // _isFirstLaunch = prefs.getBool('seenOnboarding') ?? true;
    _isFirstLaunch = false;

    _isLoggedIn = AuthService().isLoggedIn();

    _initialized = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _isFirstLaunch = false;
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setBool('seenOnboarding', false);
    // });
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    AuthService().signOut();

    _isLoggedIn = false;

    notifyListeners();
  }
}
