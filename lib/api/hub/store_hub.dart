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
  final RxBool _isStarted;
  final List<Function> _connectedCallbacks;
  Timer? _timer;

  StoreHub({
    required String connName,
    required String url,
    required Duration timeout,
  })  : _connName = connName,
        _timeout = timeout,
        _server = HubConnectionBuilder().withUrl(url).build(),
        _state = HubConnectionState.disconnected.obs,
        _isStarted = false.obs,
        _connectedCallbacks = <Function>[] {
    _server.keepAliveIntervalInMilliseconds = 3000;
    _server.serverTimeoutInMilliseconds = 8000;
    _onReconnecting();
    _onReconnected();
    _onClose();
  }

  Rx<HubConnectionState> get state => _state;

  setState() => _state.value = _server.state ?? HubConnectionState.disconnected;

  void addConnectedCallback(Function func) {
    if (!_connectedCallbacks.contains(func)) {
      _connectedCallbacks.add(func);
    }
  }

  /// 是否未连接
  bool isDisConnected() {
    return _server.state! != HubConnectionState.connected;
  }

  /// 是否已连接
  bool isConnected() {
    return _server.state! == HubConnectionState.connected;
  }

  /// 是否断开连接中
  bool isDisconnecting() {
    return _server.state! == HubConnectionState.disconnecting;
  }

  /// 是否断开连接中
  bool isReconnecting() {
    return _server.state! == HubConnectionState.reconnecting;
  }

  /// 是否连接中
  bool isConnecting() {
    return _server.state! == HubConnectionState.connecting;
  }

  /// 调用
  Future<dynamic> invoke(String event, {List<Object>? args}) {
    return _server.invoke(event, args: args);
  }

  /// 订阅
  on(String methodName, Function(List<dynamic>?) callback) {
    _server.on(methodName, callback);
  }

  /// 停止连接
  stop() async {
    _info("开始断开连接");
    _isStarted.value = false;
    _timer?.cancel();
    await _server.stop();
    setState();
    _info("断开连接成功");
  }

  /// 开始连接
  start() async {
    if (_server.state != HubConnectionState.disconnected) {
      _info("开始连接失败，当前连接状态：${_server.state}");
      return;
    }
    try {
      _info("开始连接······");
      _isStarted.value = true;
      await _server.start();
      _info("连接成功！");
      for (var callback in _connectedCallbacks) {
        callback();
      }
      setState();
    } catch (error) {
      _info(" ${error.toString()}");
      _startTimeout();
    }
  }

  /// 日志打印前缀
  _info(String info) {
    _log.info("==$_connName==> $info");
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
    _server.onreconnected((String? connectId) {
      setState();
      _info("重连成功，connectId:$connectId");
    });
  }

  /// 监听连接
  _onClose() {
    _server.onclose((Exception? error) async {
      setState();
      if (error != null) {
        _info("关闭时发生异常:${error.toString()}");
      }
      if (_isStarted.value) {
        _startTimeout();
      }
    });
  }

  /// 重连定时器
  void _startTimeout() {
    _info("${_timeout.inSeconds}s后开始重连");
    _timer = Timer(_timeout, start);
  }
}

StoreHub? _chatHub;

StoreHub get chatHub {
  _chatHub ??= StoreHub(
      connName: "chatHub",
      url: Constant.messageHub,
      timeout: const Duration(seconds: 5));
  return _chatHub!;
}
