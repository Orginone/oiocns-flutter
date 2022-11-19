import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

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
  Function? connectedCallback;

  StoreHub._({
    required String connName,
    required String url,
    required Duration timeout,
  })  : _connName = connName,
        _timeout = timeout,
        _server = HubConnectionBuilder()
            .withUrl(
              url,
              options: HttpConnectionOptions(
                headers: MessageHeaders()
                  ..setHeaderValue("Content-Type", "application/json"),
              ),
            )
            .build()
          ..keepAliveIntervalInMilliseconds = 3000
          ..serverTimeoutInMilliseconds = 8000,
        _isStop = true.obs,
        _state = HubConnectionState.Disconnected.obs;

  Rx<HubConnectionState> get state => _state;

  setState() => _state.value = _server.state ?? HubConnectionState.Disconnected;

  /// 是否未连接
  bool isDisConnected() {
    return _server.state! != HubConnectionState.Connected;
  }

  /// 是否已连接
  bool isConnected() {
    return _server.state! == HubConnectionState.Connected;
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
  start({Function? callback}) async {
    try {
      if (state.value != HubConnectionState.Disconnected) {
        return;
      }
      _info("开始连接");
      _isStop.value = false;
      await _server.start();
      setState();
      _info("连接成功");
    } catch (error) {
      _info("连接时发生异常: ${error.toString()}");
      _connTimeout(callback: callback);
      rethrow;
    }
    if (callback != null) {
      connectedCallback = callback;
      await callback();
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
    _server.onreconnecting(({Exception? error}) {
      setState();
      if (error != null) {
        _info("重连中发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 重连成功回调
  _onReconnected() {
    _server.onreconnecting(({Exception? error}) {
      setState();
      if (error != null) {
        _info("重连后发生异常: ${error.toString()}");
        return;
      }
    });
  }

  /// 监听连接
  _onClose() {
    _server.onclose(({Exception? error}) async {
      setState();
      if (error != null) {
        _info("关闭时发生异常:${error.toString()}");
      }
      if (_isStop.value) {
        return;
      }
      _connTimeout(callback: connectedCallback);
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

StoreHub? _chatHub;
StoreHub? _anyStoreHub;
StoreHub? _storeHub;

StoreHub get chatHub {
  _chatHub ??= StoreHub._(
      connName: "chatHub",
      url: Constant.hub,
      timeout: const Duration(seconds: 5))
    .._init();
  return _chatHub!;
}

StoreHub get anyStoreHub {
  _anyStoreHub ??= StoreHub._(
      connName: "anyStoreHub",
      url: Constant.anyStore,
      timeout: const Duration(seconds: 5))
    .._init();
  return _anyStoreHub!;
}

StoreHub get storeHub {
  _storeHub ??= StoreHub._(
      connName: "storeHub",
      url: Constant.store,
      timeout: const Duration(seconds: 5))
    .._init();
  return _storeHub!;
}
