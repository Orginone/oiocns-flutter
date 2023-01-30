import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/store_hub.dart';
import 'package:orginone/dart/base/model/api_resp.dart';
import 'package:orginone/dart/base/model/model.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/util/http_util.dart';
import 'package:signalr_core/signalr_core.dart';


enum SendEvent {
  tokenAuth("TokenAuth"),
  subscribed("Subscribed"),
  unSubscribed("UnSubscribed"),
  get("Get"),
  set("Set"),
  delete("Delete"),
  insert("Insert"),
  update("Update"),
  remove("Remove"),
  aggregate("Aggregate");

  final String keyWord;

  const SendEvent(this.keyWord);
}

enum ReceiveEvent {
  updated("Updated");

  final String keyWord;

  const ReceiveEvent(this.keyWord);
}

enum SubscriptionKey {
  orgChat("orgChat"),
  userChat("userchat"),
  apkFile("apkFile"),
  version("version");

  final String keyWord;

  const SubscriptionKey(this.keyWord);
}

enum StoreKey { orgChat }

enum Domain { user, all }

String collName = "chat-message";

class AnyStore {
  final Logger log = Logger("AnyStoreUtil");
  final HttpUtil _requester;
  final StoreHub _storeHub;
  final Map<String, Function(String, dynamic)> _subscription = {};

  Rx<HubConnectionState> get state => _storeHub.state;

  static AnyStore? _instance;

  static AnyStore get getInstance {
    _instance ??= AnyStore(request: HttpUtil());
    return _instance!;
  }

  AnyStore({required HttpUtil request})
      : _storeHub = StoreHub(
          connName: "anyStore",
          url: Constant.anyStoreHub,
          timeout: const Duration(seconds: 5),
        ),
        _requester = request {
    _storeHub.on(ReceiveEvent.updated.name, _onUpdated);
    _storeHub.addConnectedCallback(() async {
      await _tokenAuth();
      await _resubscribed();
    });
  }

  start() async {
    await _storeHub.start();
  }

  stop() async {
    _subscription.clear();
    await _storeHub.stop();
  }

  /// 鉴权
  Future<void> _tokenAuth() async {
    var accessToken = getAccessToken;
    var name = SendEvent.tokenAuth.name;
    var domain = Domain.user.name;
    await _storeHub.invoke(name, args: [accessToken, domain]);
  }

  /// 回调事件
  void _onUpdated(dynamic arguments) {
    log.info("订阅的信息：$arguments");
    if (arguments == null) {
      return;
    }
    String key = arguments[0];
    String domain = arguments[1];
    dynamic data = arguments[2];
    _subscription.forEach((fullKey, callback) {
      if (fullKey.split("|")[0] == key) {
        callback(domain, data);
      }
    });
  }

  /// 获取
  Future<ApiResp> get(String key, String domain) async {
    var name = SendEvent.get.keyWord;
    var args = [key, domain];
    dynamic data = await _storeHub.invoke(name, args: args);
    var resp = ApiResp.fromJson(data);
    log.info("获取返回数据：$resp");
    return resp;
  }

  /// 设置
  Future<ApiResp> set(String key, dynamic setData, String domain) async {
    var name = SendEvent.set.keyWord;
    List<Object> args = [key, setData, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    var resp = ApiResp.fromJson(res);
    log.info("设置返回数据：$resp");
    return resp;
  }

  /// 刪除
  Future<ApiResp> delete(String key, String domain) async {
    var name = SendEvent.delete.keyWord;
    dynamic res = await _storeHub.invoke(name, args: [key, domain]);
    var resp = ApiResp.fromJson(res);
    log.info("删除返回数据：$resp");
    return resp;
  }

  /// 插入
  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    var name = SendEvent.insert.keyWord;
    List<Object> args = [collName, data, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    var resp = ApiResp.fromJson(res);
    log.info("插入返回数据：$resp");
    return resp;
  }

  /// 更新
  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    var name = SendEvent.update.keyWord;
    List<Object> args = [collName, update, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    var resp = ApiResp.fromJson(res);
    log.info("更新返回数据：$resp");
    return resp;
  }

  /// 刪除
  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    var name = SendEvent.remove.keyWord;
    List<Object> args = [collName, match, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    var resp = ApiResp.fromJson(res);
    log.info("删除返回数据：$resp");
    return resp;
  }

  /// 聚合
  Future<ApiResp> aggregate({
    required String collName,
    required dynamic opt,
    required String domain,
  }) async {
    var aggregateName = SendEvent.aggregate.keyWord;
    List<Object> args = [collName, opt, domain];
    dynamic res = await _storeHub.invoke(aggregateName, args: args);
    var resp = ApiResp.fromJson(res);
    log.info("删除返回数据：$resp");
    return resp;
  }

  /// 订阅
  subscribing(
    SubscriptionKey key,
    String domain,
    Function(String, dynamic) callback,
  ) async {
    var fullKey = "${key.keyWord}|$domain";
    if (_subscription.containsKey(fullKey)) {
      return;
    }
    _subscription[fullKey] = callback;
    var name = SendEvent.subscribed.name;
    dynamic res = await _storeHub.invoke(name, args: [key.keyWord, domain]);
    ApiResp apiResp = ApiResp.fromJson(res);
    if (apiResp.success) {
      callback(domain, apiResp.data);
    }
    log.info("====> 订阅 ${key.keyWord} 成功！");
  }

  /// 取消订阅
  unsubscribing(SubscriptionKey key, String domain) async {
    var fullKey = "${key.name}|$domain";
    if (!_subscription.containsKey(fullKey)) {
      return;
    }
    var name = SendEvent.unSubscribed.name;
    await _storeHub.invoke(name, args: [key.name, domain]);
    _subscription.remove(fullKey);
  }

  /// 重新订阅
  _resubscribed() async {
    _subscription.forEach((fullKey, callback) async {
      var key = fullKey.split("|")[0];
      var domain = fullKey.split("|")[1];
      var name = SendEvent.subscribed.name;
      dynamic res = await _storeHub.invoke(name, args: [key, domain]);

      ApiResp apiResp = ApiResp.fromJson(res);
      if (apiResp.success) {
        callback(domain, apiResp.data);
      }
      log.info("====> 重新订阅 $key 事件成功");
    });
  }

  /// 取消订阅
  Future<dynamic> bucketOperate(BucketOperateModel model) async {
    if (_storeHub.isConnected()) {
      var res = await _storeHub.invoke('BucketOpreate', args: [model]);
      log.info("bucketOperate request ===> ${model.toString()}");
      log.info("bucketOperate ===> ${res.toString()}");
      return ApiResp.fromJson(res);
    }
    return await _restRequest("Bucket", 'Operate', model);
  }

  /// 清空消息
  Future<ApiResp> clearHistoryMsg(String sessionId) {
    Map<String, dynamic> match = {"sessionId": sessionId};
    return remove(collName, match, Domain.user.name);
  }

  /// 删除消息
  Future<ApiResp> deleteMsg(String chatId) async {
    Map<String, dynamic> match = {"chatId": chatId};
    return remove(collName, match, Domain.user.name);
  }

  Future<dynamic> _restRequest(
    String controller,
    String methodName,
    dynamic data,
  ) async {
    return await _requester.post(
      "/orginone/anydata/$controller/$methodName",
      data: data,
    );
  }
}
