import 'package:uuid/uuid.dart';
class Emitter {
  Map<String, Function> _refreshCallback = {};
  Map<String, Map<String, Function>> _partRefreshCallback = {};

  Emitter(Map<String, Function> a{},Map<String, Map<String, Function>> ) {
    _refreshCallback = {};
  } 
}


/// @desc 订阅变更
/// @param callback 变更回调
/// @returns 订阅ID
String subscribe((String key,)) {
  final id = Uuid().v4();
  if (callback) {
    callback(id);
    _refreshCallback[id] = callback;
  }
  return id;
}

/// @desc 取消订阅 支持取消多个
/// @param key 订阅ID
void unsubscribe(String key): void {
  if (key.isNotEmpty) {
    _refreshCallback.remove(key);
    _partRefreshCallback.remove(key);
  } else {
    key.forEach((id) {
      _refreshCallback.remove(id);
      _partRefreshCallback.remove(id);
    });
  }
}

/// @desc 变更回调
void changCallback(...args: dynamic){
  _refreshCallback.keys.forEach((key) {
    _refreshCallback[key](generateUuid(), ...args);
  });
}

bool callback(String key,any ){

}