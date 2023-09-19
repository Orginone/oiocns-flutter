import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// kv离线存储
class Storage {
  // 单例写法
  static final Storage _instance = Storage._internal();
  factory Storage() => _instance;
  static late final SharedPreferences _prefs;

  Storage._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static Future<bool> setJson(String key, Object value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  static bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  static List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static void clear() {
    _prefs.clear();
  }
}
