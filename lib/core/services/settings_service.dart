import 'shared_prefs_service.dart';

class SettingsService {
  // Singleton pattern for the SettingsService itself
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  /// Access the shared prefs wrapper instance
  final SharedPrefsService _storage = SharedPrefsService.instance;

  // --- Storage Keys ---
  // Keeping keys private here prevents other parts of the app
  // from accidentally overwriting settings with string typos.
  static const String _keyDarkMode = 'ui_dark_mode_enabled';

  // --- Theme Settings ---

  /// Returns the current dark mode preference.
  /// Uses your wrapper's 'getBoolOrDefault' for safety.
  bool get isDarkMode => _storage.getBoolOrDefault(_keyDarkMode, defaultValue: false);

  /// Updates and persists the dark mode preference.
  Future<void> setDarkMode(bool value) async {
    await _storage.setBool(_keyDarkMode, value);
  }

// --- Future-Proofing Example ---
/*
  static const String _keyUserConfig = 'user_config_map';

  Future<void> saveUserConfig(Map<String, dynamic> config) async {
    await _storage.saveMap(_keyUserConfig, config);
  }
  */
}