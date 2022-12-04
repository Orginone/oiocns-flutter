import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../api_resp/api_resp.dart';
import 'store_hub.dart';

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
  apkFile("apkFile");

  final String keyWord;

  const SubscriptionKey(this.keyWord);
}

enum StoreKey { orgChat }

enum Domain { user, all }

String collName = "chat-message";

class AnyStore {
  final Logger log = Logger("AnyStoreUtil");
  final StoreHub _storeHub;
  final Map<String, Function(String, dynamic)> _subscription = {};

  Rx<HubConnectionState> get state => _storeHub.state;

  static AnyStore? _instance;

  static AnyStore get getInstance {
    _instance ??= AnyStore();
    return _instance!;
  }

  AnyStore()
      : _storeHub = StoreHub(
          connName: "anyStore",
          url: Constant.anyStoreHub,
          timeout: const Duration(seconds: 5),
        ) {
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
    var name = SendEvent.get.name;
    var args = [key, domain];
    dynamic data = await _storeHub.invoke(name, args: args);
    return ApiResp.fromJson(data);
  }

  /// 设置
  Future<ApiResp> set(String key, dynamic setData, String domain) async {
    var name = SendEvent.set.name;
    List<Object> args = [key, setData, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 刪除
  Future<ApiResp> delete(String key, String domain) async {
    var name = SendEvent.delete.name;
    dynamic res = await _storeHub.invoke(name, args: [key, domain]);
    return ApiResp.fromJson(res);
  }

  /// 插入
  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    var name = SendEvent.insert.name;
    List<Object> args = [collName, data, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 更新
  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    var name = SendEvent.update.name;
    List<Object> args = [collName, update, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 刪除
  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    var name = SendEvent.remove.name;
    List<Object> args = [collName, match, domain];
    dynamic res = await _storeHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 聚合
  Future<ApiResp> aggregate({
    required String collName,
    required dynamic opt,
    required String domain,
  }) async {
    var aggregateName = SendEvent.aggregate.name;
    List<Object> args = [collName, opt, domain];
    dynamic res = await _storeHub.invoke(aggregateName, args: args);
    return ApiResp.fromJson(res);
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

  Future<List<MessageDetail>> getUserSpaceHistoryMsg({
    required TargetType typeName,
    required String sessionId,
    required int offset,
    required int limit,
  }) async {
    Map<String, dynamic> match = {"sessionId": sessionId};
    if (typeName == TargetType.person) {
      match["spaceId"] = auth.userId;
    }
    // 如果是个人空间从本地存储拿数据
    Map<String, dynamic> options = {
      "match": match,
      "sort": {"createTime": -1},
      "skip": offset,
      "limit": limit
    };
    var domain = Domain.user.name;
    ApiResp apiResp = await aggregate(
      collName: collName,
      opt: options,
      domain: domain,
    );
    List<dynamic> details = apiResp.data ?? [];
    List<MessageDetail> ans = [];
    for (var item in details) {
      item["id"] = item["chatId"];
      var detail = MessageDetail.fromMap(item);
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      ans.insert(0, detail);
    }
    return ans;
  }
}
