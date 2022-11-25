import 'dart:async';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/hub/store_hub.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/util/encryption_util.dart';

enum ReceiveEvent {
  receiveMsg("RecvMsg"),
  chatRefresh("ChatRefresh");

  final String keyWord;

  const ReceiveEvent(this.keyWord);
}

enum SendEvent {
  tokenAuth("TokenAuth"),
  getChats("GetChats"),
  sendMsg("SendMsg"),
  getPersons("GetPersons"),
  recallMsg("RecallMsg"),
  queryFriendMsg("QueryFriendMsg"),
  queryCohortMsg("QueryCohortMsg"),
  getName("GetName");

  final String keyWord;

  const SendEvent(this.keyWord);
}

class RealChatServer {
  final Logger log = Logger("RealChatServer");
  final StoreHub _chatHub;

  RealChatServer._(this._chatHub);

  Future<void> start() async {
    _chatHub.addConnectedCallback(tokenAuth);
    await _chatHub.start();
  }

  Future<void> stop() async {
    await _chatHub.stop();
  }

  /// 鉴权
  tokenAuth() async {
    var accessToken = getAccessToken;
    var methodName = SendEvent.tokenAuth.keyWord;
    await _chatHub.invoke(methodName, args: [accessToken]);
  }

  /// 发送消息
  Future<ApiResp> send({
    required String spaceId,
    required String itemId,
    required String msgBody,
    required MsgType msgType,
  }) async {
    var messageDetail = {
      "spaceId": spaceId,
      "toId": itemId,
      "msgType": msgType.name,
      "msgBody": EncryptionUtil.deflate(msgBody)
    };
    var args = <Object>[messageDetail];
    var sendName = SendEvent.sendMsg.keyWord;
    dynamic apiResp = await _chatHub.invoke(sendName, args: args);
    return ApiResp.fromJson(apiResp);
  }

  /// 获取聊天对话
  Future<List<ChatGroup>> getChats() async {
    String key = SendEvent.getChats.keyWord;
    Map<String, dynamic> chats = await _chatHub.invoke(key);
    ApiResp resp = ApiResp.fromJson(chats);

    List<dynamic> groups = resp.data["groups"];
    return groups.map((item) {
      ChatGroup messagesResp = ChatGroup.fromMap(item);
      for (var chat in messagesResp.chats) {
        chat.spaceId = messagesResp.id;
      }
      return messagesResp;
    }).toList();
  }

  /// 获取名称
  Future<String> getName(String personId) async {
    var key = SendEvent.getName.keyWord;
    var args = [personId];
    Map<String, dynamic> nameRes = await _chatHub.invoke(key, args: args);
    ApiResp resp = ApiResp.fromJson(nameRes);
    return resp.data;
  }

  /// 获取历史消息
  Future<List<MessageDetail>> getHistoryMsg({
    required TargetType typeName,
    required String spaceId,
    required String sessionId,
    required int offset,
    required int limit,
  }) async {
    String event = SendEvent.queryFriendMsg.keyWord;
    String idName = "friendId";
    if (typeName == TargetType.person) {
      event = SendEvent.queryCohortMsg.keyWord;
      idName = "cohortId";
    }
    Map<String, dynamic> params = {
      "limit": 30,
      idName: sessionId,
      "offset": offset,
      "spaceId": spaceId
    };
    Map<String, dynamic> res = await _chatHub.invoke(event, args: [params]);
    var apiResp = ApiResp.fromJson(res);
    Map<String, dynamic> data = apiResp.data;
    if (data["result"] == null) {
      return [];
    }
    List<dynamic> details = data["result"];
    return details.reversed.map((item) {
      var detail = MessageDetail.fromMap(item);
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      return detail;
    }).toList();
  }

  /// 撤销消息
  Future<ApiResp> recallMsg(MessageDetail msg) async {
    var name = SendEvent.recallMsg.keyWord;
    dynamic res = await _chatHub.invoke(name, args: [msg]);
    return ApiResp.fromJson(res);
  }

  /// 获取人员
  Future<PageResp<Target>> getPersons({
    required String cohortId,
    required int limit,
    required int offset,
  }) async {
    String event = SendEvent.getPersons.keyWord;
    Map<String, dynamic> params = {
      "cohortId": cohortId,
      "limit": limit,
      "offset": offset
    };
    dynamic res = await _chatHub.invoke(event, args: [params]);

    ApiResp apiResp = ApiResp.fromJson(res);
    return PageResp.fromMap(apiResp.data, Target.fromMap);
  }

  /// 接收回调
  rsvCallback(List<dynamic> params) {
    if (Get.isRegistered<MessageController>()) {
      var messageController = Get.find<MessageController>();
      var count = messageController.orgChatCache.chats.length;
      if (count > 0) {
        messageController.onReceiveMessage(params);
        return;
      }
    }
    Timer(const Duration(seconds: 1), () {
      rsvCallback(params);
    });
  }

  /// 定义事件
  void _initEvents() {
    chatHub.on(ReceiveEvent.receiveMsg.name, (params) {
      rsvCallback(params ?? []);
    });
    chatHub.on(ReceiveEvent.chatRefresh.name, (params) {
      if (Get.isRegistered<MessageController>()) {
        var messageController = Get.find<MessageController>();
        messageController.refreshCharts();
      }
    });
  }
}

final RealChatServer chatServer = RealChatServer._(chatHub).._initEvents();
