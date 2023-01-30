import 'dart:collection';

import 'package:uuid/uuid.dart';

class Emitter {
  final HashMap _refreshCallback = HashMap<String, Function>();
  final HashMap _partRefreshCallback =
      HashMap<String, HashMap<String, Function>>();

  /// @desc 订阅变更
  /// @param callback 变更回调
  /// @returns 订阅ID
  subscribe(Function(String)? callback) {
    var id = const Uuid().v1();
    if (callback != null) {
      callback.call(id);
      _refreshCallback[id] = callback;
    }
    return id;
  }

  /// @desc 订阅局部变更
  /// @param callback 变更回调
  /// @returns 订阅ID
  String subscribePart(List<String> p, Function(String) callback) {
    var key = const Uuid().v1();
    if (p.isNotEmpty) {
      callback.call(key);
      _partRefreshCallback[key] = {};
      for (var value in p) {
        _partRefreshCallback[key][value] = callback;
      }
    }
    return key;
  }

  /// @desc 取消订阅 支持取消多个
  /// @param key 订阅ID
  void unsubscribe(List<String> p) {
    if (p.isNotEmpty) {
      for (var key in p) {
        _refreshCallback.remove(key);
        _partRefreshCallback.remove(key);
      }
    }
  }

  /// @desc 变更回调
  changCallback() {
    for (var element in _refreshCallback.keys) {
      var value = _refreshCallback[element];
      value.call(const Uuid().v1());
    }
  }

  /// @desc 局部变更回调
  /// @param {string} p 订阅方法名称
  changCallbackPart(String key) {
    changCallback();
    for (var element in _partRefreshCallback.keys) {
      var value = _partRefreshCallback[element][key];
      value.call(const Uuid().v1());
    }
  }
}
