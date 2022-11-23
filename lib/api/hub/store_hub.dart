import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:signalr_core/signalr_core.dart';

enum SendEvent {
  tokenAuth("TokenAuth");

  final String keyWork;

  const SendEvent(this.keyWork);
}

/// 存储集线器
class StoreHub {
  static final Logger _log = Logger("ConnHolder");
  final String _connName;
  final HubConnection _server;
  final Rx<HubConnectionState> _state;
  final Duration _timeout;
  final RxBool _isStop;
  final List<Function> _connectedCallbacks;

  StoreHub._({
    required String connName,
    required String url,
    required Duration timeout,
  })  : _connName = connName,
        _timeout = timeout,
        _server = HubConnectionBuilder().withUrl(url).build()
          ..keepAliveIntervalInMilliseconds = 3000
          ..serverTimeoutInMilliseconds = 8000,
        _isStop = true.obs,
        _state = HubConnectionState.disconnected.obs,
        _connectedCallbacks = <Function>[];

  Rx<HubConnectionState> get state => _state;

  setState() => _state.value = _server.state ?? HubConnectionState.disconnected;

  void addConnectedCallback(Function func) {
    _connectedCallbacks.add(func);
  }

  /// 是否未连接
  bool isDisConnected() {
    return _server.state! != HubConnectionState.connected;
  }

  /// 是否已连接
  bool isConnected() {
    return _server.state! == HubConnectionState.connected;
  }

  /// 调用
  dynamic invoke(String event, {List<Object>? args}) {
    return _server.invoke(event, args: args);
  }

  /// 订阅
  on(String methodName, Function callback) {
    _server.on(methodName, (params) => callback(params));
  }

  /// 停止连接
  stop() async {
    try {
      _info("开始断开连接");
      _isStop.value = true;
      await _server.stop();
      _info("断开连接成功");
    } catch (error) {
      _info("断开连接失败,重新尝试!");
      rethrow;
    } finally {
      setState();
    }
  }

  /// 开始连接
  start() async {
    try {
      if (state.value != HubConnectionState.disconnected) {
        return;
      }
      _info("开始连接");
      _isStop.value = false;
      await _server.start();
      setState();
      _info("连接成功");
    } catch (error) {
      _info("连接时发生异常: ${error.toString()}");
      _connTimeout();
      rethrow;
    }
    if (_connectedCallbacks.isNotEmpty) {
      for (var callback in _connectedCallbacks) {
        await callback();
      }
    }
  }

  /// 日志打印前缀
  _info(String info) {
    _log.info("==$_connName==> $info");
  }

  /// 初始化监听事件
  _init() {
    _onReconnecting();
    _onReconnected();
    _onClose();
  }

  /// 重连中回调
  _onReconnecting() {
    _server.onreconnecting((Exception? error) {
      setState();
      if (error != null) {
        _info("重连中发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 重连成功回调
  _onReconnected() {
    _server.onreconnecting((Exception? error) {
      setState();
      if (error != null) {
        _info("重连后发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 监听连接
  _onClose() {
    _server.onclose((Exception? error) async {
      setState();
      if (error != null) {
        _info("关闭时发生异常:${error.toString()}");
      }
      if (_isStop.value) {
        return;
      }
      _connTimeout();
    });
  }

  /// 重连定时器
  void _connTimeout() {
    Timer(_timeout, () async {
      _info("重连时间间隔: ${_timeout.inSeconds}s");
      await start();
    });
  }
}

StoreHub? _chatHub;
StoreHub? _anyStoreHub;
StoreHub? _storeHub;

StoreHub get chatHub {
  _chatHub ??= StoreHub._(
      connName: "chatHub",
      url: Constant.messageHub,
      timeout: const Duration(seconds: 5))
    .._init();
  return _chatHub!;
}

StoreHub get anyStoreHub {
  _anyStoreHub ??= StoreHub._(
      connName: "anyStoreHub",
      url: Constant.anyStoreHub,
      timeout: const Duration(seconds: 5))
    .._init();
  return _anyStoreHub!;
}

StoreHub get kernelHub {
  _storeHub ??= StoreHub._(
      connName: "kernelHub",
      url: Constant.kernelHub,
      timeout: const Duration(seconds: 5))
    .._init();
  return _storeHub!;
}
