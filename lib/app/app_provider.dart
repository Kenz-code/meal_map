import 'package:flutter/material.dart';
import 'package:meal_map/core/services/device_service.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/theme/theme.dart';
import 'dart:async';
import 'package:meal_map/core/services/shared_prefs_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark;
  final SharedPrefsService _prefsService;

  ThemeProvider(this._prefsService) : _isDark = _prefsService.getBoolOrDefault('ui_dark_mode_enabled', defaultValue: false);

  bool get isDark => _isDark;

  ThemeMode get currentMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    _prefsService.setBool('ui_dark_mode_enabled', _isDark);
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

  bool highlightQrLogin = false;

  AppStateNotifier() {
    _init();
  }

  Future<void> _init() async {
    _isFirstLaunch = SharedPrefsService.instance.getBoolOrDefault('hasNotSeenOnboarding', defaultValue: true);

    _isLoggedIn = AuthService().isLoggedIn();

    _initialized = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _isFirstLaunch = false;

    SharedPrefsService.instance.setBool("hasNotSeenOnboarding", false);

    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;

    DeviceService.instance.registerCurrentDevice();

    notifyListeners();
  }

  void logout() async {
    await DeviceService.instance.unregisterCurrentDevice();

    AuthService().signOut();

    _isLoggedIn = false;

    notifyListeners();
  }

  void deleteAccount() async {
    await DeviceService.instance.unregisterCurrentDevice();

    final e = await AuthService().deleteUser();
    debugPrint(e);

    _isLoggedIn = false;

    notifyListeners();
  }

  void requestQrHighlight() {
    highlightQrLogin = true;
    notifyListeners();
  }

  void clearQrHighlight() {
    highlightQrLogin = false;
    notifyListeners();
  }
}
