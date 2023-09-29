import 'package:uuid/uuid.dart';

typedef CmdType = dynamic Function(String type, String cmd, List<dynamic> args);

/// 日志
class Command {
  final id = const Uuid().v1();
  late Map<String, CmdType> callbacks;
  late Map<String, Function> flagCallbacks;

  Command() {
    callbacks = {};
    flagCallbacks = {};
  }

  /// 订阅变更
  /// @param callback 变更回调
  /// @returns 订阅ID
  String subscribe(CmdType? callback) {
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
      for (var id in id) {
        callbacks.remove(id);
      }
    }
  }

  /// 发送命令
  /// @param type 类型，目前支持 config、data
  /// @param cmd 命令
  /// @param args 参数
  void emitter(String type, String cmd, List<dynamic>? args) {
    for (var key in callbacks.keys) {
      Function.apply(callbacks[key] as Function, [type, cmd, ...?args]);
    }
  }

  /// 根据标识订阅变更
  String subscribeByFlag(String flag, Function callback) {
    flagCallbacks['$id-$flag'] = callback;
    callback.call();
    return id;
  }

  /// 取消标识订阅
  void unsubscribeByFlag(String id) {
    final ids = flagCallbacks.keys.where((i) => i.startsWith('$id-')).toList();
    for (var id in ids) {
      flagCallbacks.remove(id);
    }
  }

  /// 发送命令
  void emitterFlag({String flag = '', List<dynamic> args = const []}) {
    for (var id in flagCallbacks.keys) {
      if (flag == '' || id.endsWith('-$flag')) {
        flagCallbacks[id]?.call(args);
      }
    }
  }
}

final Command command = Command();
