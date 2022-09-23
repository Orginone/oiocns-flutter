import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../api_resp/api_resp.dart';
import '../api/constant.dart';
import 'errors.dart';
import 'hive_util.dart';

enum SendEvent {
  TokenAuth,
  Subscribed,
  UnSubscribed,
  Get,
  Set,
  Delete,
  Insert,
  Update,
  Remove,
  Aggregate
}

enum ReceiveEvent { Updated }

enum SubscriptionKey { orgChat }

enum StoreKey { orgChat }

enum Domain { user }

class AnyStoreUtil {
  final Logger log = Logger("AnyStoreUtil");

  AnyStoreUtil._();

  static final AnyStoreUtil _instance = AnyStoreUtil._();

  factory AnyStoreUtil() {
    _instance.state ??= _instance._server.state.obs;
    return _instance;
  }

  final HubConnection _server =
      HubConnectionBuilder().withUrl(Constant.anyStore).build();
  Rx<HubConnectionState?>? state;
  Map<String, Function> subscriptionMap = {};
  bool _connTimerLock = false;
  bool _subscribingTimerLock = false;

  final Map<String, void Function(List<dynamic>?)> events = {};

  Future<ApiResp> get(String key, String domain) async {
    checkConn();
    dynamic data = _server.invoke(SendEvent.Get.name, args: [key, domain]);
    return ApiResp.fromMap(data);
  }

  Future<void> set(String key, dynamic setData, String domain) async {
    checkConn();
    await _server.invoke(SendEvent.Set.name, args: [key, setData, domain]);
  }

  Future<ApiResp> delete(String key, String domain) async {
    checkConn();
    dynamic res = _server.invoke(SendEvent.Delete.name, args: [key, domain]);
    return ApiResp.fromMap(res);
  }

  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    checkConn();
    dynamic res = await _server.invoke(SendEvent.Insert.name, args: [collName, data, domain]);
    return ApiResp.fromMap(res);
  }

  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    checkConn();
    dynamic res = await _server.invoke(SendEvent.Update.name, args: [collName, update, domain]);
    return ApiResp.fromMap(res);
  }

  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    checkConn();
    dynamic res = await _server.invoke(SendEvent.Remove.name, args: [collName, match, domain]);
    return ApiResp.fromMap(res);
  }

  Future<dynamic> aggregate(String collName, dynamic opt, String domain) async {
    checkConn();
    var aggregateName = SendEvent.Aggregate.name;
    dynamic res = await _server.invoke(aggregateName, args: [collName, opt, domain]);
    return ApiResp.fromMap(res).data;
  }

  void _onUpdated() {
    _server.on(ReceiveEvent.Updated.name, (arguments) {
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
    _server.onreconnecting((exception) {
      setState();
      log.info("================== 正在重新连接 AnyStore =========================");
      log.info("==> reconnecting");
      if (exception != null) {
        log.info("==> $exception");
      }
    });
  }

  void _initOnReconnected() {
    _server.onreconnected((id) {
      setState();
      log.info("==> reconnected success");
      log.info("================== 重新连接 AnyStore 成功 =========================");
    });
  }

  void _connTimer() {
    if (_connTimerLock) {
      return;
    }
    _connTimerLock = true;
    Duration duration = const Duration(seconds: 30);
    Timer.periodic(duration, (timer) async {
      await tryConn();
      setState();
      if (isConn()) {
        timer.cancel();
        _connTimerLock = false;
      }
    });
  }

  void _subscribingTimer(
      SubscriptionKey key, String domain, Function callback) {
    if (_subscribingTimerLock) {
      return;
    }
    _subscribingTimerLock = true;
    Duration duration = const Duration(seconds: 10);
    Timer.periodic(duration, (timer) async {
      log.info("=====> 尝试重新订阅中");
      await subscribing(key, domain, callback);
      if (isConn()) {
        timer.cancel();
        _subscribingTimerLock = false;
      }
    });
  }

  void _initOnClose() {
    _server.onclose((error) {
      setState();
      _connTimer();
    });
  }

  Future<dynamic> _auth(String accessToken) async {
    checkConn();
    return _server.invoke(SendEvent.TokenAuth.name,
        args: [accessToken, Domain.user.name]);
  }

  Future<dynamic> disconnect() async {
    await _server.stop();
    setState();
    log.info("===> 已断开和存储服务器的连接。");
  }

  /// 订阅
  subscribing(SubscriptionKey key, String domain, Function callback) async {
    var fullKey = "${key.name}|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (!isConn()) {
      _subscribingTimer(key, domain, callback);
      return;
    }
    subscriptionMap[fullKey] = callback;
    dynamic res = await _server
        .invoke(SendEvent.Subscribed.name, args: [key.name, domain]);
    ApiResp apiResp = ApiResp.fromMap(res);
    if (apiResp.success) {
      callback(apiResp.data);
    }
  }

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain) async {
    checkConn();
    var fullKey = "${key.name}|$domain";
    if (!subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (isConn()) {
      await _server
          .invoke(SendEvent.UnSubscribed.name, args: [key.name, domain]);
      subscriptionMap.remove(fullKey);
    }
  }

  //初始化连接
  Future<dynamic> tryConn() async {
    log.info("================== 连接 AnyStore =========================");
    var state = _server.state;
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
          await _server.start();
          await _auth(HiveUtil().accessToken);
          setState();

          log.info("==> connected success");
          log.info("========== 连接 AnyStore 成功 =============");
        } catch (error) {
          error.printError();
          EasyLoading.showToast("连接本地存储服务失败!");
          log.info("========== 连接 AnyStore 失败 =============");
          _connTimer();
          rethrow;
        }
        break;
      default:
        log.info("==> 当前连接状态为：$state");
        break;
    }
  }

  checkConn() {
    if (!isConn()) {
      var errorMsg = "未连接存储服务器!";
      EasyLoading.showToast(errorMsg);
      throw ServerError(errorMsg);
    }
  }

  setState() {
    state!.value = _server.state;
  }

  // 判断是否处于连接当中
  bool isConn() {
    return _server.state == HubConnectionState.connected;
  }
}
