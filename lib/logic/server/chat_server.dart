import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/logic/server/store_server.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/hive_util.dart';

import 'conn_holder.dart';

enum ReceiveEvent { RecvMsg, ChatRefresh }

enum SendEvent {
  TokenAuth,
  GetChats,
  SendMsg,
  GetPersons,
  RecallMsg,
  QueryFriendMsg,
  QueryCohortMsg,
  GetName
}

String collName = "chat-message";

class ChatServer {
  final Logger log = Logger("HubUtil");

  ChatServer._();

  final ConnHolder _conn = chatConn;
  final Rx<bool> isAuthed = false.obs;

  Future<void> start() async {
    await _conn.start();
    await _auth();
  }

  Future<void> stop() async {
    isAuthed.value = true;
    await _conn.stop();
  }

  /// 鉴权
  _auth() async {
    if (_conn.isConnected()) {
      var accessToken = HiveUtil().accessToken;
      var methodName = SendEvent.TokenAuth.name;
      await _conn.invoke(methodName, args: [accessToken]);
      isAuthed.value = true;
    } else {
      throw Exception("未连接,无法授权!");
    }
  }

  /// 发送消息
  Future<void> sendMsg({
    required String spaceId,
    required String messageItemId,
    required String msgBody,
    required MsgType msgType,
  }) async {
    if (isAuthed.value) {
      if (messageItemId == "-1") return;

      var messageDetail = {
        "spaceId": spaceId,
        "toId": messageItemId,
        "msgType": msgType.name,
        "msgBody": EncryptionUtil.deflate(msgBody)
      };
      try {
        var args = <Object>[messageDetail];
        var sendName = SendEvent.SendMsg.name;
        await _conn.invoke(sendName, args: args);
      } catch (error) {
        Fluttertoast.showToast(msg: "消息发送失败");
        rethrow;
      }
    }
  }

  /// 获取聊天对话
  Future<List<SpaceMessagesResp>> getChats() async {
    if (isAuthed.value) {
      String key = SendEvent.GetChats.name;
      Map<String, dynamic> chats = await _conn.invoke(key);
      ApiResp resp = ApiResp.fromJson(chats);

      List<dynamic> groups = resp.data["groups"];
      List<SpaceMessagesResp> messageGroups = groups.map((item) {
        SpaceMessagesResp messagesResp = SpaceMessagesResp.fromMap(item);
        for (var chat in messagesResp.chats) {
          chat.spaceId = messagesResp.id;
        }
        return messagesResp;
      }).toList();
      return messageGroups;
    }
    Fluttertoast.showToast(msg: "未连接聊天服务器");
    throw Exception("未连接聊天服务器");
  }

  /// 获取名称
  Future<String> getName(String personId) async {
    if (isAuthed.value) {
      var key = SendEvent.GetName.name;
      var args = [personId];
      Map<String, dynamic> nameRes = await _conn.invoke(key, args: args);
      ApiResp resp = ApiResp.fromJson(nameRes);
      return resp.data;
    }
    Fluttertoast.showToast(msg: "未连接聊天服务器");
    throw Exception("未连接聊天服务器");
  }

  /// 缓存聊天记录
  Future<dynamic> cacheMsg(String sessionId, MessageDetailResp detail) async {
    if (detail.msgType == MsgType.recall.name) {
      Map<String, dynamic> update = {
        "match": {"chatId": detail.id},
        "update": {
          "_set_": {"msgBody": detail.msgBody, "msgType": detail.msgType}
        },
        "options": {}
      };
      ApiResp ans = await storeServer.insert(
        "chat-message",
        update,
        Domain.user.name,
      );
      log.info("ans:${ans.toJson()}");
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
      storeServer.insert(collName, data, Domain.user.name);
    }
  }

  /// 缓存会话
  Future<dynamic> cacheChats(OrgChatCache orgChatCache) async {
    Map<String, dynamic> setData = {
      "operation": "replaceAll",
      "data": {
        "name": "我的消息",
        "chats": SpaceMessagesResp.toJsonList(orgChatCache.chats)
            .where((item) => item["id"] == "topping")
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
    storeServer.set(StoreKey.orgChat.name, setData, Domain.user.name);
  }

  /// 清空消息
  Future<void> clearHistoryMsg(String? spaceId, String sessionId) async {
    TargetResp userInfo = auth.userInfo;
    spaceId = spaceId ?? userInfo.id;
    if (userInfo.id == spaceId) {
      // 清空会话
      Map<String, dynamic> match = {"sessionId": sessionId};
      storeServer.remove(collName, match, Domain.user.name);
    }
  }

  /// 删除消息
  Future<void> deleteMsg(String chatId) async {
    Map<String, dynamic> match = {"chatId": chatId};
    storeServer.remove(collName, match, Domain.user.name);
  }

  /// 获取历史消息
  Future<List<MessageDetailResp>> getHistoryMsg(String? spaceId,
      String sessionId, String typeName, int offset, int limit) async {
    // 默认我的空间
    TargetResp userInfo = auth.userInfo;
    spaceId = spaceId ?? userInfo.id;
    if (userInfo.id == spaceId) {
      Map<String, dynamic> match = {"sessionId": sessionId};
      if (typeName == TargetType.person.name) {
        match["spaceId"] = userInfo.id;
      }
      // 如果是个人空间从本地存储拿数据
      Map<String, dynamic> options = {
        "match": match,
        "sort": {"createTime": -1},
        "skip": offset,
        "limit": limit
      };
      var store = storeServer;
      var domain = Domain.user.name;
      ApiResp apiResp = await store.aggregate(collName, options, domain);
      List<dynamic> details = apiResp.data ?? [];
      List<MessageDetailResp> ans = [];
      for (var item in details) {
        item["id"] = item["chatId"];
        var detail = MessageDetailResp.fromMap(item);
        detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
        ans.insert(0, detail);
      }
      return ans;
    } else {
      if (isAuthed.value) {
        String event = SendEvent.QueryFriendMsg.name;
        String idName = "friendId";
        if (typeName == TargetType.person.name) {
          event = SendEvent.QueryCohortMsg.name;
          idName = "cohortId";
        }
        Map<String, dynamic> params = {
          "limit": 30,
          idName: sessionId,
          "offset": offset,
          "spaceId": spaceId
        };
        Map<String, dynamic> res = await _conn.invoke(event, args: [params]);
        var apiResp = ApiResp.fromJson(res);
        Map<String, dynamic> data = apiResp.data;
        if (data["result"] == null) {
          return [];
        }
        List<dynamic> details = data["result"];
        return details.reversed.map((item) {
          var detail = MessageDetailResp.fromMap(item);
          detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
          return detail;
        }).toList();
      }
      Fluttertoast.showToast(msg: "未连接聊天服务器");
      throw Exception("未连接聊天服务器");
    }
  }

  /// 撤销消息
  Future<ApiResp> recallMsg(MessageDetailResp msg) async {
    if (isAuthed.value) {
      var name = SendEvent.RecallMsg.name;
      dynamic res = await _conn.invoke(name, args: [msg]);
      return ApiResp.fromJson(res);
    }
    Fluttertoast.showToast(msg: "未连接聊天服务器");
    throw Exception("未连接聊天服务器");
  }

  /// 获取人员
  Future<PageResp<TargetResp>> getPersons(
    String id,
    int limit,
    int offset,
  ) async {
    if (isAuthed.value) {
      String event = SendEvent.GetPersons.name;
      Map<String, dynamic> params = {
        "cohortId": id,
        "limit": limit,
        "offset": offset
      };
      dynamic res = await _conn.invoke(event, args: [params]);

      ApiResp apiResp = ApiResp.fromJson(res);
      return PageResp.fromMap(apiResp.data, TargetResp.fromMap);
    }
    Fluttertoast.showToast(msg: "未连接聊天服务器");
    throw Exception("未连接聊天服务器");
  }

  /// 接收回调
  _rsvCallback(List<dynamic> params) {
    if (Get.isRegistered<MessageController>()) {
      var messageController = Get.find<MessageController>();
      var count = messageController.orgChatCache.chats.length;
      if (count > 0) {
        messageController.onReceiveMessage(params);
        return;
      }
    }
    Timer(const Duration(seconds: 1), () {
      _rsvCallback(params);
    });
  }

  /// 定义事件
  void _initEvents() {
    _conn.on(ReceiveEvent.ChatRefresh.name, (params) {
      _rsvCallback(params ?? []);
    });
    _conn.on(ReceiveEvent.ChatRefresh.name, (params) {
      if (Get.isRegistered<MessageController>()) {
        var messageController = Get.find<MessageController>();
        messageController.refreshCharts();
      }
    });
  }
}

final ChatServer chatServer = ChatServer._().._initEvents();
