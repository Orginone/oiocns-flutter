import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/hive_util.dart';

import '../../api_resp/api_resp.dart';
import 'conn_holder.dart';

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

class StoreServer {
  final Logger log = Logger("AnyStoreUtil");

  StoreServer._();

  final ConnHolder _conn = storeConn;
  final Map<String, Function> subscriptionMap = {};
  final Rx<bool> isAuthed = false.obs;

  Future<void> start() async {
    await _conn.start();
    await _auth();
    await _resubscribed();
  }
  
  Future<void> stop() async {
    subscriptionMap.clear();
    isAuthed.value = false;
    await _conn.stop();
  }

  /// 鉴权
  Future<void> _auth() async {
    if (_conn.isConnected()) {
      var accessToken = HiveUtil().accessToken;
      var name = SendEvent.TokenAuth.name;
      var domain = Domain.user.name;
      await _conn.invoke(name, args: [accessToken, domain]);
      isAuthed.value = true;
    } else {
      throw Exception("未连接,无法授权!");
    }
  }

  /// 获取
  Future<ApiResp> get(String key, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Get.name;
      var args = [key, domain];
      dynamic data = await _conn.invoke(name, args: args);
      return ApiResp.fromJson(data);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 设置
  Future<ApiResp> set(String key, dynamic setData, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Set.name;
      var args = [key, setData, domain];
      dynamic res = await _conn.invoke(name, args: args);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 刪除
  Future<ApiResp> delete(String key, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Delete.name;
      dynamic res = await _conn.invoke(name, args: [key, domain]);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 插入
  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Insert.name;
      var args = [collName, data, domain];
      dynamic res = await _conn.invoke(name, args: args);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 更新
  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Update.name;
      var args = [collName, update, domain];
      dynamic res = await _conn.invoke(name, args: args);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 刪除
  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    if (isAuthed.value) {
      var name = SendEvent.Remove.name;
      var args = [collName, match, domain];
      dynamic res = await _conn.invoke(name, args: args);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 聚合
  Future<ApiResp> aggregate(String collName, dynamic opt, String domain) async {
    if (isAuthed.value) {
      var aggregateName = SendEvent.Aggregate.name;
      var args = [collName, opt, domain];
      dynamic res = await _conn.invoke(aggregateName, args: args);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接存储服务器");
    throw Exception("未连接存储服务器");
  }

  /// 设置订阅事件
  void _onUpdated() {
    _conn.on(ReceiveEvent.Updated.name, (arguments) {
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

  /// 订阅
  subscribing(SubscriptionKey key, String domain, Function callback) async {
    var fullKey = "${key.name}|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (isAuthed.value) {
      subscriptionMap[fullKey] = callback;
      var name = SendEvent.Subscribed.name;
      dynamic res = await _conn.invoke(name, args: [key.name, domain]);
      ApiResp apiResp = ApiResp.fromJson(res);
      if (apiResp.success) {
        callback(apiResp.data);
      }
      log.info("====> 订阅 ${key.name} 成功！");
    }
  }

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain) async {
    var fullKey = "${key.name}|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    if (isAuthed.value) {
      var name = SendEvent.UnSubscribed.name;
      await _conn.invoke(name, args: [key.name, domain]);
      subscriptionMap.remove(fullKey);
    }
  }

  /// 重新订阅
  _resubscribed() async {
    if (isAuthed.value) {
      subscriptionMap.forEach((fullKey, callback) async {
        var key = fullKey.split("|")[0];
        var domain = fullKey.split("|")[1];
        var name = SendEvent.Subscribed.name;
        dynamic res = await _conn.invoke(name, args: [key, domain]);

        ApiResp apiResp = ApiResp.fromJson(res);
        if (apiResp.success) {
          callback(apiResp.data);
        }
        log.info("====> 重新订阅 $key 事件成功");
      });
    }
  }
}

final StoreServer storeServer = StoreServer._().._onUpdated();
