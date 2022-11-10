import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:signalr_core/signalr_core.dart';

enum SendEvent {
  tokenAuth("TokenAuth");

  final String keyWork;

  const SendEvent(this.keyWork);
}

class ConnHolder {
  static final Logger _log = Logger("ConnHolder");
  final String _connName;
  final HubConnection _server;
  final Rx<HubConnectionState> _state;
  final Duration _timeout;
  final RxBool _isStop;

  ConnHolder._({
    required String connName,
    required String url,
    required Duration timeout,
  })  : _connName = connName,
        _timeout = timeout,
        _server = HubConnectionBuilder().withUrl(url).build()
          ..keepAliveIntervalInMilliseconds = 3000
          ..serverTimeoutInMilliseconds = 8000,
        _isStop = true.obs,
        _state = HubConnectionState.disconnected.obs;

  Rx<HubConnectionState> get state => _state;

  setState() => _state.value = _server.state ?? HubConnectionState.disconnected;

  /// 是否未连接
  bool isDisConnected() {
    return _server.state! != HubConnectionState.connected;
  }

  /// 是否已连接
  bool isConnected() {
    return _server.state! == HubConnectionState.connected;
  }

  /// 调用
  dynamic invoke(String event, {List<dynamic>? args}) {
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
      stop();
      rethrow;
    }
  }

  /// 开始连接
  start({Function? callback}) async {
    try {
      _info("开始连接");
      _isStop.value = false;
      await _server.start();
      setState();
      if (callback != null) {
        await callback();
      }
      _info("连接成功");
    } catch (error) {
      _info("连接时发生异常: ${error.toString()}");
      _connTimeout();
      rethrow;
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
    _server.onreconnecting((error) {
      setState();
      if (error != null) {
        _info("重连中发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 重连成功回调
  _onReconnected() {
    _server.onreconnecting((error) {
      setState();
      if (error != null) {
        _info("重连后发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 监听连接
  _onClose() {
    _server.onclose((error) async {
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
  void _connTimeout({Function? callback}) {
    Timer(_timeout, () async {
      _info("重连时间间隔: ${_timeout.inSeconds}s");
      await start(callback: callback);
    });
  }
}

final ConnHolder chatConn = ConnHolder._(
  connName: "ChatConn",
  url: Constant.hub,
  timeout: const Duration(seconds: 5),
).._init();

final ConnHolder storeConn = ConnHolder._(
  connName: "StoreConn",
  url: Constant.anyStore,
  timeout: const Duration(seconds: 5),
).._init();
