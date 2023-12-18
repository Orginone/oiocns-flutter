import 'package:uuid/uuid.dart';

class Emitter {
  // final id = const Uuid().v1();
  Map<String, void Function(String, List<dynamic>)> _refreshCallback = {};

  final Map<String, Map<String, void Function(String)>> _partRefreshCallback =
      {};
  Emitter() {
    _refreshCallback = {};
  }

  /// 订阅变更
  /// [callback] 变更回调
  /// 返回订阅ID
  String subscribe(void Function(String, List<dynamic>?) callback,
      [bool? target = true]) {
    final id = const Uuid().v1();
    if (target!) {
      callback(id, []);
    }
    _refreshCallback[id] = callback;
    return id;
  }

  /// 取消订阅 支持取消多个
  /// [key] 订阅ID
  void unsubscribe([dynamic key]) {
    if (null == key) {
      _refreshCallback.clear();
      _partRefreshCallback.clear();
    } else if (key is String) {
      _refreshCallback.remove(key);
      _partRefreshCallback.remove(key);
    } else if (key is List<String>) {
      for (var id in key) {
        _refreshCallback.remove(id);
        _partRefreshCallback.remove(id);
      }
    }
  }

  /// 变更回调
  void changCallback({List<dynamic>? args}) {
    _refreshCallback
        .forEach((key, value) => Function.apply(value, [key, args]));
    // _refreshCallback.map((key, value) => Function.apply(value, [key, args]));
  }
}
