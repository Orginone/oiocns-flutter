import 'package:uuid/uuid.dart';

typedef CmdType = dynamic Function(String type, String cmd, List<dynamic> args);

/// 日志
class Command {
   final id = const Uuid().v1();
 late  Map<String, CmdType> callbacks;

  Command() {
   callbacks={} ;
  }

  /// 订阅变更
  /// @param callback 变更回调
  /// @returns 订阅ID
  String subscribe(CmdType ?callback) {
    
    if (callback != null) {
      callbacks[id] = callback;
    }
    return id;
  }

  /// 取消订阅，支持取消多个
  /// @param id 订阅ID
  void unsubscribe(dynamic id) {
    if (id is String) {
      callbacks.remove(id);
    } else if (id is List<String>) {
      id.forEach((String id) {
        callbacks.remove(id);
      });
    }
  }

  /// 发送命令
  /// @param type 类型，目前支持 config、data
  /// @param cmd 命令
  /// @param args 参数
  void emitter(String type, String cmd, List<dynamic> ?args) {
    callbacks.keys.forEach((String key) {
      
       Function.apply(callbacks[key] as Function, [type, cmd, ...?args]);
    });
  }
}

final Command command = Command();