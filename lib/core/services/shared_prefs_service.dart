import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A service wrapper around SharedPreferences with safe read/write access
/// and support for dependency injection and testing.
class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  /// Use this to initialize the singleton instance before accessing it
  static Future<SharedPrefsService> init() async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = SharedPrefsService._();
    }
    return _instance!;
  }

  SharedPrefsService._();

  /// Retrieve the singleton instance after calling init()
  static SharedPrefsService get instance {
    assert(
        _instance != null, 'Call SharedPrefsService.init() before using it.');
    return _instance!;
  }

  // ---- Basic Setters ---- //

  Future<bool> setBool(String key, bool value) => _prefs!.setBool(key, value);
  Future<bool> setInt(String key, int value) => _prefs!.setInt(key, value);
  Future<bool> setDouble(String key, double value) =>
      _prefs!.setDouble(key, value);
  Future<bool> setString(String key, String value) =>
      _prefs!.setString(key, value);
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs!.setStringList(key, value);
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(map); // Convert Map to JSON string
    await prefs.setString(key, jsonString);
  }

  // ---- Basic Getters ---- //

  bool? getBool(String key) => _prefs!.getBool(key);
  int? getInt(String key) => _prefs!.getInt(key);
  double? getDouble(String key) => _prefs!.getDouble(key);
  String? getString(String key) => _prefs!.getString(key);
  List<String>? getStringList(String key) => _prefs!.getStringList(key);
  Future<Map<String, dynamic>> loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return {};
    return jsonDecode(jsonString); // Convert back to Map
  }

  // ---- Typed Default Getters ---- //

  bool getBoolOrDefault(String key, {bool defaultValue = false}) =>
      _prefs!.getBool(key) ?? defaultValue;

  int getIntOrDefault(String key, {int defaultValue = 0}) =>
      _prefs!.getInt(key) ?? defaultValue;

  double getDoubleOrDefault(String key, {double defaultValue = 0.0}) =>
      _prefs!.getDouble(key) ?? defaultValue;

  String getStringOrDefault(String key, {String defaultValue = ''}) =>
      _prefs!.getString(key) ?? defaultValue;

  List<String> getStringListOrDefault(String key,
          {List<String> defaultValue = const []}) =>
      _prefs!.getStringList(key) ?? defaultValue;

  // ---- Deletion ---- //

  Future<bool> remove(String key) => _prefs!.remove(key);
  Future<bool> clear() => _prefs!.clear();

  // ---- Misc ---- //

  bool containsKey(String key) => _prefs!.containsKey(key);
  Set<String> getKeys() => _prefs!.getKeys();
}
