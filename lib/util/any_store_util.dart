import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../api_resp/api_resp.dart';
import '../api/constant.dart';
import 'hive_util.dart';

enum SendEvent { TokenAuth, Subscribed, UnSubscribed }

enum ReceiveEvent { Updated }

enum SubscriptionKey { orgChat }

class AnyStoreUtil {
  final Logger log = Logger("AnyStoreUtil");

  AnyStoreUtil._();

  static final AnyStoreUtil _instance = AnyStoreUtil._();

  factory AnyStoreUtil() {
    _instance.state ??= _instance._connServer.state.obs;
    return _instance;
  }

  final HubConnection _connServer =
      HubConnectionBuilder().withUrl(Constant.anyStore).build();
  Rx<HubConnectionState?>? state;
  Map<String, Function> subscriptionMap = {};

  final Map<String, void Function(List<dynamic>?)> events = {};

  void _onUpdated() {
    _connServer.on(ReceiveEvent.Updated.name, (arguments) {
      if (arguments == null) {
        return;
      }
      String key = arguments[0];
      dynamic data = arguments[1];
      subscriptionMap.forEach((fullKey, callback) {
        if (fullKey.split("|")[0] == key) {
          callback(data);
        }
      });
    });
  }

  void _initOnReconnecting() {
    _connServer.onreconnecting((exception) {
      log.info("================== 正在重新连接 AnyStore =========================");
      log.info("==> reconnecting");
      if (exception != null) {
        log.info("==> $exception");
      }
      tryConn();
    });
  }

  void _initOnReconnected() {
    _connServer.onreconnected((id) {
      tryConn();
      log.info("==> reconnected success");
      log.info("================== 重新连接 AnyStore 成功 =========================");
    });
  }

  void _connTimer() {
    Duration duration = const Duration(seconds: 30);
    Timer.periodic(duration, (timer) async {
      await tryConn();
      if (isConn()) {
        timer.cancel();
      }
    });
  }

  void _subscribingTimer(
      SubscriptionKey key, String domain, Function callback) {
    Duration duration = const Duration(seconds: 10);
    Timer.periodic(duration, (timer) async {
      await subscribing(key, domain, callback);
      if (isConn()) {
        timer.cancel();
      }
    });
  }

  void _initOnClose() {
    _connServer.onclose((error) {
      state!.value = HubConnectionState.disconnected;
      _connTimer();
    });
  }

  Future<dynamic> _auth(String accessToken) async {
    return _connServer.invoke(SendEvent.TokenAuth.name, args: [accessToken]);
  }

  Future<dynamic> disconnect() async {
    await _connServer.stop();
  }

  /// 订阅
  subscribing(SubscriptionKey key, String domain, Function callback) async {
    var fullKey = "$key|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (!isConn()) {
      _subscribingTimer(key, domain, callback);
      return;
    }
    subscriptionMap[fullKey] = callback;
    dynamic res = await _connServer
        .invoke(SendEvent.Subscribed.name, args: [key, domain]);
    ApiResp apiResp = ApiResp.fromMap(res);
    if (apiResp.success) {
      callback(apiResp.data);
    }
  }

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain) async {
    var fullKey = "$key|$domain";
    if (!subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (isConn()) {
      await _connServer
          .invoke(SendEvent.UnSubscribed.name, args: [key, domain]);
      subscriptionMap.remove(fullKey);
    }
  }

  //初始化连接
  Future<dynamic> tryConn() async {
    log.info("================== 连接 AnyStore =========================");
    var state = _connServer.state;
    switch (state) {
      case HubConnectionState.disconnected:
        log.info("==> connecting");
        try {
          // 定义事件和回调函数
          _initOnReconnecting();
          _initOnReconnected();
          _initOnClose();
          _onUpdated();

          // 开启连接，鉴权
          await _connServer.start();
          await _auth(HiveUtil().accessToken);
          this.state!.value = HubConnectionState.connected;

          log.info("==> connected success");
          log.info("========== 连接 AnyStore 成功 =============");
        } catch (error) {
          error.printError();
          EasyLoading.showToast("连接聊天服务器失败!");
          log.info("========== 连接 AnyStore 失败 =============");
          _connTimer();
        }
        break;
      default:
        log.info("==> 当前连接状态为：$state");
        this.state!.value = state;
        break;
    }
  }

  // 判断是否处于连接当中
  bool isConn() {
    return _connServer.state == HubConnectionState.connected;
  }
}
