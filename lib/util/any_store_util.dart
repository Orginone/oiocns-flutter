import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../config/constant.dart';
import '../api_resp/api_resp.dart';
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
    return _instance;
  }

  HubConnection? _server;
  bool _isAuthed = false;
  bool _isStop = true;
  final Rx<HubConnectionState> state = HubConnectionState.disconnected.obs;
  final Map<String, Function> subscriptionMap = {};
  final Map<String, void Function(List<dynamic>?)> events = {};

  /// 获取
  Future<ApiResp> get(String key, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Get.name;
      var args = [key, domain];
      dynamic data = await _server!.invoke(name, args: args);
      return ApiResp.fromMap(data);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 设置
  Future<ApiResp> set(String key, dynamic setData, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Set.name;
      var args = [key, setData, domain];
      dynamic res = await _server!.invoke(name, args: args);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 刪除
  Future<ApiResp> delete(String key, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Delete.name;
      dynamic res = await _server!.invoke(name, args: [key, domain]);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 插入
  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Insert.name;
      var args = [collName, data, domain];
      dynamic res = await _server!.invoke(name, args: args);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 更新
  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Update.name;
      var args = [collName, update, domain];
      dynamic res = await _server!.invoke(name, args: args);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 刪除
  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    if (_isAuthed) {
      var name = SendEvent.Remove.name;
      var args = [collName, match, domain];
      dynamic res = await _server!.invoke(name, args: args);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 聚合
  Future<ApiResp> aggregate(String collName, dynamic opt, String domain) async {
    if (_isAuthed) {
      var aggregateName = SendEvent.Aggregate.name;
      var args = [collName, opt, domain];
      dynamic res = await _server!.invoke(aggregateName, args: args);
      return ApiResp.fromMap(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器!");
    throw Exception("未连接存储服务器!");
  }

  /// 设置订阅事件
  void _onUpdated() {
    if (_server == null) {
      return;
    }
    _server!.on(ReceiveEvent.Updated.name, (arguments) {
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

  /// 重连回调
  void _initOnReconnecting() {
    if (_server == null) {
      return;
    }
    _server!.onreconnecting((exception) {
      setState();
      log.info("================== 正在重新连接 AnyStore =========================");
      log.info("====> reconnecting");
      if (exception != null) {
        log.info("====> $exception");
      }
    });
  }

  /// 重连成功后回调
  void _initOnReconnected() {
    if (_server == null) {
      return;
    }
    _server!.onreconnected((id) {
      setState();
      log.info("====> reconnected success");
      log.info("================== 重新连接 AnyStore 成功 =========================");
    });
  }

  /// 重连定时器
  void _connTimeout() {
    log.info("====> 5s 后，anyStore 开始重新连接");
    Duration duration = const Duration(seconds: 5);
    Timer(duration, () async {
      await disconnect();
      await tryConn();
    });
  }

  /// 重连事件
  void _initOnClose() {
    if (_server == null) {
      return;
    }
    _server!.onclose((error) {
      log.info("====> anyStore 连接被关闭了");
      setState();
      if (!_isStop) {
        _connTimeout();
      }
    });
  }

  /// 鉴权
  Future<dynamic> _auth(String accessToken) async {
    if (isConn()) {
      var name = SendEvent.TokenAuth.name;
      var domain = Domain.user.name;
      return _server!.invoke(name, args: [accessToken, domain]);
    }
  }

  /// 断开连接
  Future<dynamic> disconnect() async {
    if (_server == null) {
      return;
    }

    _isStop = true;
    _isAuthed = false;
    subscriptionMap.clear();
    events.clear();
    await _server!.stop();
    _server = null;
    setState();

    log.info("===> 已断开和存储服务器的连接。");
  }

  /// 订阅
  subscribing(SubscriptionKey key, String domain, Function callback) async {
    var fullKey = "${key.name}|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (_isAuthed) {
      subscriptionMap[fullKey] = callback;
      var name = SendEvent.Subscribed.name;
      dynamic res = await _server!.invoke(name, args: [key.name, domain]);
      ApiResp apiResp = ApiResp.fromMap(res);
      if (apiResp.success) {
        callback(apiResp.data);
      }
      log.info("====> 订阅 ${key.name} 成功！");
    }
  }

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain) async {
    var fullKey = "${key.name}|$domain";
    if (!subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (_isAuthed) {
      var name = SendEvent.UnSubscribed.name;
      await _server!.invoke(name, args: [key.name, domain]);
      subscriptionMap.remove(fullKey);
    }
  }

  /// 重新订阅
  _resubscribed() async {
    if (_isAuthed) {
      subscriptionMap.forEach((fullKey, callback) async {
        var key = fullKey.split("|")[0];
        var domain = fullKey.split("|")[1];
        var name = SendEvent.Subscribed.name;
        dynamic res = await _server!.invoke(name, args: [key, domain]);

        ApiResp apiResp = ApiResp.fromMap(res);
        if (apiResp.success) {
          callback(apiResp.data);
        }
        log.info("====> 重新订阅 $key 事件成功");
      });
    }
  }

  //初始化连接
  Future<dynamic> tryConn() async {
    if (_server != null) {
      return;
    }
    log.info("================== 连接 AnyStore ==================");
    _server = HubConnectionBuilder().withUrl(Constant.anyStore).build();
    _server!.keepAliveIntervalInMilliseconds = 3000;
    _server!.serverTimeoutInMilliseconds = 8000;
    _isStop = false;
    var state = _server!.state;
    switch (state) {
      case HubConnectionState.disconnected:
        log.info("====> connecting");
        try {
          // 定义事件和回调函数
          _initOnReconnecting();
          _initOnReconnected();
          _initOnClose();
          _onUpdated();

          // 开启连接，鉴权
          await _server!.start();
          await _auth(HiveUtil().accessToken);
          _isAuthed = true;

          // 重新订阅
          _resubscribed();

          log.info("====> connected success");
          log.info("================== 连接 AnyStore 成功 ==================");
        } catch (error) {
          error.printError();
          Fluttertoast.showToast(msg: "连接本地存储服务失败!");
          log.info("================== 连接 AnyStore 失败 ==================");
          _connTimeout();
        }
        break;
      default:
        log.info("====> 当前连接状态为：$state");
        break;
    }
    setState();
  }

  /// 设置状态
  setState() {
    state.value = _server?.state ?? HubConnectionState.disconnected;
  }

  /// 判断是否处于连接当中
  bool isConn() {
    if (_server == null) {
      return false;
    }
    return _server!.state == HubConnectionState.connected;
  }
}
