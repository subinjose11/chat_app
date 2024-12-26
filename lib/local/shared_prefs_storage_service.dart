// ignore_for_file: depend_on_referenced_packages

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool?> getBool(String key, {bool defaultValue = false}) async {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<int?> getInt(String key, {int defaultValue = 0}) async {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static Future<String?> getString(String key,
      {String defaultValue = ''}) async {
    return _prefs?.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> saveToken(String value) async {
    await _prefs?.setString("Token", value);
  }

  static Future<String?> getToken() async {
    return _prefs?.getString("Token") ?? "";
  }

  static Future<double?> getDouble(String key,
      {double defaultValue = 0.0}) async {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  static Future<List<String>?> getStringList(String key,
      {List<String> defaultValue = const []}) async {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
