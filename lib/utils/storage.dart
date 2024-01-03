import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'log/log_util.dart';

/// kv离线存储
class Storage {
  factory Storage() => _instance;
  // 单例写法
  Storage._internal();
  static final Storage _instance = Storage._internal();
  static late final SharedPreferences _prefs;

  static Future<Storage> init() async {
    LogUtil.d('init');
    _prefs = await SharedPreferences.getInstance();
    LogUtil.d(_prefs);
    return _instance;
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

  static Future<bool> setListValue(String key, int index, String value) async {
    List<String> data = getList(key);
    if (data.length > index) {
      data.setAll(index, [value]);
      setList(key, data);
      return true;
    }
    return false;
  }

  static String getString(String key) {
    // LogUtil.d('getString');
    // LogUtil.d(_prefs);
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

  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}
