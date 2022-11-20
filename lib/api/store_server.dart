import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/server.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/util/encryption_util.dart';

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

String collName = "chat-message";

class ProxyStoreServer implements ConnServer, StoreServer {
  final RealStoreServer _instance;

  ProxyStoreServer(this._instance);

  final Rx<bool> _isAuthed = false.obs;

  @override
  Future<void> start() async {
    await anyStoreHub.start(callback: () async {
      await tokenAuth();
      await _instance._resubscribed();
    });
  }

  @override
  Future<void> stop() async {
    _instance.subscriptionMap.clear();
    _isAuthed.value = false;
    await anyStoreHub.stop();
  }

  /// 鉴权
  @override
  Future<void> tokenAuth() async {
    if (anyStoreHub.isDisConnected()) {
      throw Exception("存储服务未连接,无法授权!");
    }
    var accessToken = getAccessToken;
    var name = SendEvent.TokenAuth.name;
    var domain = Domain.user.name;
    try {
      await anyStoreHub.invoke(name, args: [accessToken, domain]);
      _isAuthed.value = true;
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResp> cacheMsg(String sessionId, MessageDetailResp detail) {
    checkAuthed();
    return _instance.cacheMsg(sessionId, detail);
  }

  @override
  checkAuthed() {
    if (!_isAuthed.value) {
      Fluttertoast.showToast(msg: "未连接聊天服务器");
      throw Exception("未连接聊天服务器");
    }
  }

  @override
  Future<ApiResp> cacheChats(OrgChatCache orgChatCache) {
    checkAuthed();
    return _instance.cacheChats(orgChatCache);
  }

  @override
  Future<ApiResp> clearHistoryMsg(String sessionId) {
    checkAuthed();
    return _instance.clearHistoryMsg(sessionId);
  }

  @override
  Future<ApiResp> deleteMsg(String chatId) {
    checkAuthed();
    return _instance.deleteMsg(chatId);
  }

  @override
  Future<ApiResp> aggregate(String collName, opt, String domain) {
    checkAuthed();
    return _instance.aggregate(collName, opt, domain);
  }

  @override
  Future<ApiResp> delete(String key, String domain) {
    checkAuthed();
    return _instance.delete(key, domain);
  }

  @override
  Future<ApiResp> get(String key, String domain) {
    checkAuthed();
    return _instance.get(key, domain);
  }

  @override
  Future<ApiResp> insert(String collName, data, String domain) {
    checkAuthed();
    return _instance.insert(collName, data, domain);
  }

  @override
  Future<ApiResp> remove(String collName, match, String domain) {
    checkAuthed();
    return _instance.remove(collName, match, domain);
  }

  @override
  Future<ApiResp> set(String key, setData, String domain) {
    checkAuthed();
    return _instance.set(key, setData, domain);
  }

  @override
  Future<ApiResp> update(String collName, update, String domain) {
    checkAuthed();
    return _instance.update(collName, update, domain);
  }

  @override
  Future<List<MessageDetailResp>> getUserSpaceHistoryMsg({
    required TargetType typeName,
    required String sessionId,
    required int offset,
    required int limit,
  }) {
    checkAuthed();
    return _instance.getUserSpaceHistoryMsg(
      typeName: typeName,
      sessionId: sessionId,
      offset: offset,
      limit: limit,
    );
  }

  @override
  subscribing(SubscriptionKey key, String domain, Function callback) {
    checkAuthed();
    _instance.subscribing(key, domain, callback);
  }

  @override
  unsubscribing(SubscriptionKey key, String domain) {
    checkAuthed();
    _instance.unsubscribing(key, domain);
  }

  /// 设置订阅事件
  void _onUpdated() {
    anyStoreHub.on(ReceiveEvent.Updated.name, (arguments) {
      if (arguments == null) {
        return;
      }
      String key = arguments[0];
      dynamic data = arguments[1];
      _instance.subscriptionMap.forEach((fullKey, callback) {
        if (fullKey.split("|")[0] == key) {
          callback(data);
        }
      });
    });
  }
}

class RealStoreServer implements StoreServer {
  final Logger log = Logger("AnyStoreUtil");

  RealStoreServer._();

  final Map<String, Function> subscriptionMap = {};

  /// 获取
  @override
  Future<ApiResp> get(String key, String domain) async {
    var name = SendEvent.Get.name;
    var args = [key, domain];
    dynamic data = await anyStoreHub.invoke(name, args: args);
    return ApiResp.fromJson(data);
  }

  /// 设置
  @override
  Future<ApiResp> set(String key, dynamic setData, String domain) async {
    var name = SendEvent.Set.name;
    List<Object> args = [key, setData, domain];
    dynamic res = await anyStoreHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 刪除
  @override
  Future<ApiResp> delete(String key, String domain) async {
    var name = SendEvent.Delete.name;
    dynamic res = await anyStoreHub.invoke(name, args: [key, domain]);
    return ApiResp.fromJson(res);
  }

  /// 插入
  @override
  Future<ApiResp> insert(String collName, dynamic data, String domain) async {
    var name = SendEvent.Insert.name;
    List<Object> args = [collName, data, domain];
    dynamic res = await anyStoreHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 更新
  @override
  Future<ApiResp> update(String collName, dynamic update, String domain) async {
    var name = SendEvent.Update.name;
    List<Object> args = [collName, update, domain];
    dynamic res = await anyStoreHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 刪除
  @override
  Future<ApiResp> remove(String collName, dynamic match, String domain) async {
    var name = SendEvent.Remove.name;
    List<Object> args = [collName, match, domain];
    dynamic res = await anyStoreHub.invoke(name, args: args);
    return ApiResp.fromJson(res);
  }

  /// 聚合
  @override
  Future<ApiResp> aggregate(String collName, dynamic opt, String domain) async {
    var aggregateName = SendEvent.Aggregate.name;
    List<Object> args = [collName, opt, domain];
    dynamic res = await anyStoreHub.invoke(aggregateName, args: args);
    return ApiResp.fromJson(res);
  }

  /// 订阅
  @override
  subscribing(SubscriptionKey key, String domain, Function callback) async {
    var fullKey = "${key.name}|$domain";
    if (subscriptionMap.containsKey(fullKey)) {
      return;
    }
    subscriptionMap[fullKey] = callback;
    var name = SendEvent.Subscribed.name;
    dynamic res = await anyStoreHub.invoke(name, args: [key.name, domain]);
    ApiResp apiResp = ApiResp.fromJson(res);
    if (apiResp.success) {
      callback(apiResp.data);
    }
    log.info("====> 订阅 ${key.name} 成功！");
  }

  /// 取消订阅
  @override
  unsubscribing(SubscriptionKey key, String domain) async {
    var fullKey = "${key.name}|$domain";
    if (!subscriptionMap.containsKey(fullKey)) {
      return;
    }
    var name = SendEvent.UnSubscribed.name;
    await anyStoreHub.invoke(name, args: [key.name, domain]);
    subscriptionMap.remove(fullKey);
  }

  /// 重新订阅
  _resubscribed() async {
    subscriptionMap.forEach((fullKey, callback) async {
      var key = fullKey.split("|")[0];
      var domain = fullKey.split("|")[1];
      var name = SendEvent.Subscribed.name;
      dynamic res = await anyStoreHub.invoke(name, args: [key, domain]);

      ApiResp apiResp = ApiResp.fromJson(res);
      if (apiResp.success) {
        callback(apiResp.data);
      }
      log.info("====> 重新订阅 $key 事件成功");
    });
  }

  @override
  Future<ApiResp> cacheMsg(String sessionId, MessageDetailResp detail) {
    if (detail.msgType == MsgType.recall.name) {
      Map<String, dynamic> update = {
        "match": {"chatId": detail.id},
        "update": {
          "_set_": {"msgBody": detail.msgBody, "msgType": detail.msgType}
        },
        "options": {}
      };
      return insert("chat-message", update, Domain.user.name);
    } else {
      Map<String, dynamic> data = {
        "chatId": detail.id,
        "toId": detail.toId,
        "spaceId": detail.spaceId,
        "fromId": detail.fromId,
        "msgType": detail.msgType,
        "msgBody": detail.msgBody,
        "sessionId": sessionId,
        "createTime": DateUtil.formatDate(detail.createTime,
            format: "yyyy-MM-dd HH:mm:ss.SSS")
      };
      log.info("====> 插入一条数据：${data["createTime"]}");
      return insert(collName, data, Domain.user.name);
    }
  }

  /// 缓存会话
  @override
  Future<ApiResp> cacheChats(OrgChatCache orgChatCache) {
    Map<String, dynamic> setData = {
      "operation": "replaceAll",
      "data": {
        "name": "我的消息",
        "chats": SpaceMessagesResp.toJsonList(orgChatCache.chats)
            .where((item) => item["id"] != "topping")
            .toList(),
        "nameMap": orgChatCache.nameMap,
        "openChats": MessageItemResp.toJsonList(orgChatCache.openChats),
        "recentChats": orgChatCache.recentChats,
        "lastMsg": {
          "chat": orgChatCache.target?.toJson(),
          "data": orgChatCache.messageDetail?.toJson()
        },
      }
    };
    return set(StoreKey.orgChat.name, setData, Domain.user.name);
  }

  /// 清空消息
  @override
  Future<ApiResp> clearHistoryMsg(String sessionId) {
    Map<String, dynamic> match = {"sessionId": sessionId};
    return remove(collName, match, Domain.user.name);
  }

  /// 删除消息
  @override
  Future<ApiResp> deleteMsg(String chatId) async {
    Map<String, dynamic> match = {"chatId": chatId};
    return remove(collName, match, Domain.user.name);
  }

  @override
  Future<List<MessageDetailResp>> getUserSpaceHistoryMsg({
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
    ApiResp apiResp = await aggregate(collName, options, domain);
    List<dynamic> details = apiResp.data ?? [];
    List<MessageDetailResp> ans = [];
    for (var item in details) {
      item["id"] = item["chatId"];
      var detail = MessageDetailResp.fromMap(item);
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      ans.insert(0, detail);
    }
    return ans;
  }
}

final ProxyStoreServer storeServer = ProxyStoreServer(RealStoreServer._())
  .._onUpdated();
