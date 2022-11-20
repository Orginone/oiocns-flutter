import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/conn_holder.dart';
import 'package:orginone/api/server.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/encryption_util.dart';

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

class ProxyChatServer implements ChatServer, ConnServer {
  final RealChatServer _instance;

  ProxyChatServer(this._instance);

  final Rx<bool> _isAuthed = false.obs;

  @override
  Future<void> start() async {
    await chatHub.start(callback: () async {
      await tokenAuth();
    });
  }

  @override
  Future<void> stop() async {
    _isAuthed.value = false;
    await chatHub.stop();
  }

  /// 鉴权
  @override
  tokenAuth() async {
    if (chatHub.isDisConnected()) {
      throw Exception("聊天服务未连接,无法授权!");
    }
    var accessToken = getAccessToken;
    var methodName = SendEvent.TokenAuth.name;
    await chatHub.invoke(methodName, args: [accessToken]);
    _isAuthed.value = true;
  }

  @override
  Future<List<SpaceMessagesResp>> getChats() {
    checkAuthed();
    return _instance.getChats();
  }

  @override
  Future<List<MessageDetailResp>> getHistoryMsg({
    required TargetType typeName,
    required String spaceId,
    required String sessionId,
    required int offset,
    required int limit,
  }) {
    checkAuthed();
    return _instance.getHistoryMsg(
      typeName: typeName,
      spaceId: spaceId,
      sessionId: sessionId,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<String> getName(String personId) {
    checkAuthed();
    return _instance.getName(personId);
  }

  @override
  Future<PageResp<TargetResp>> getPersons({
    required String cohortId,
    required int limit,
    required int offset,
  }) {
    checkAuthed();
    return _instance.getPersons(
      cohortId: cohortId,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ApiResp> recallMsg(MessageDetailResp msg) {
    checkAuthed();
    return _instance.recallMsg(msg);
  }

  @override
  void rsvCallback(List<dynamic> params) {
    checkAuthed();
    _instance.rsvCallback(params);
  }

  @override
  Future<ApiResp> send({
    required String spaceId,
    required String itemId,
    required String msgBody,
    required MsgType msgType,
  }) {
    checkAuthed();
    return _instance.send(
      spaceId: spaceId,
      itemId: itemId,
      msgBody: msgBody,
      msgType: msgType,
    );
  }

  @override
  checkAuthed() {
    if (!_isAuthed.value) {
      Fluttertoast.showToast(msg: "未连接聊天服务器");
      throw Exception("未连接聊天服务器");
    }
  }

  /// 定义事件
  void _initEvents() {
    chatHub.on(ReceiveEvent.RecvMsg.name, (params) {
      rsvCallback(params ?? []);
    });
    chatHub.on(ReceiveEvent.ChatRefresh.name, (params) {
      if (Get.isRegistered<MessageController>()) {
        var messageController = Get.find<MessageController>();
        messageController.refreshCharts();
      }
    });
  }
}

class RealChatServer implements ChatServer {
  final Logger log = Logger("RealChatServer");

  RealChatServer._();

  /// 发送消息
  @override
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
    var sendName = SendEvent.SendMsg.name;
    dynamic apiResp = await chatHub.invoke(sendName, args: args);
    return ApiResp.fromJson(apiResp);
  }

  /// 获取聊天对话
  @override
  Future<List<SpaceMessagesResp>> getChats() async {
    String key = SendEvent.GetChats.name;
    Map<String, dynamic> chats = await chatHub.invoke(key);
    ApiResp resp = ApiResp.fromJson(chats);

    List<dynamic> groups = resp.data["groups"];
    return groups.map((item) {
      SpaceMessagesResp messagesResp = SpaceMessagesResp.fromMap(item);
      for (var chat in messagesResp.chats) {
        chat.spaceId = messagesResp.id;
      }
      return messagesResp;
    }).toList();
  }

  /// 获取名称
  @override
  Future<String> getName(String personId) async {
    var key = SendEvent.GetName.name;
    var args = [personId];
    Map<String, dynamic> nameRes = await chatHub.invoke(key, args: args);
    ApiResp resp = ApiResp.fromJson(nameRes);
    return resp.data;
  }

  /// 获取历史消息
  @override
  Future<List<MessageDetailResp>> getHistoryMsg({
    required TargetType typeName,
    required String spaceId,
    required String sessionId,
    required int offset,
    required int limit,
  }) async {
    String event = SendEvent.QueryFriendMsg.name;
    String idName = "friendId";
    if (typeName == TargetType.person) {
      event = SendEvent.QueryCohortMsg.name;
      idName = "cohortId";
    }
    Map<String, dynamic> params = {
      "limit": 30,
      idName: sessionId,
      "offset": offset,
      "spaceId": spaceId
    };
    Map<String, dynamic> res = await chatHub.invoke(event, args: [params]);
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

  /// 撤销消息
  @override
  Future<ApiResp> recallMsg(MessageDetailResp msg) async {
    var name = SendEvent.RecallMsg.name;
    dynamic res = await chatHub.invoke(name, args: [msg]);
    return ApiResp.fromJson(res);
  }

  /// 获取人员
  @override
  Future<PageResp<TargetResp>> getPersons({
    required String cohortId,
    required int limit,
    required int offset,
  }) async {
    String event = SendEvent.GetPersons.name;
    Map<String, dynamic> params = {
      "cohortId": cohortId,
      "limit": limit,
      "offset": offset
    };
    dynamic res = await chatHub.invoke(event, args: [params]);

    ApiResp apiResp = ApiResp.fromJson(res);
    return PageResp.fromMap(apiResp.data, TargetResp.fromMap);
  }

  /// 接收回调
  @override
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
}

final ProxyChatServer chatServer = ProxyChatServer(RealChatServer._())
  .._initEvents();
