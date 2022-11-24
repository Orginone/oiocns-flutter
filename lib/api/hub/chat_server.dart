import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/hub/store_hub.dart';
import 'package:orginone/api/hub/server.dart';
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
    _instance._chatHub.addConnectedCallback(tokenAuth);
    await _instance._chatHub.start();
  }

  @override
  Future<void> stop() async {
    _isAuthed.value = false;
    await _instance._chatHub.stop();
  }

  /// 鉴权
  @override
  tokenAuth() async {
    if (_instance._chatHub.isDisConnected()) {
      throw Exception("聊天服务未连接,无法授权!");
    }
    var accessToken = getAccessToken;
    var methodName = SendEvent.TokenAuth.name;
    await _instance._chatHub.invoke(methodName, args: [accessToken]);
    _isAuthed.value = true;
  }

  @override
  Future<List<ChatGroup>> getChats() {
    checkAuthed();
    return _instance.getChats();
  }

  @override
  Future<List<MessageDetail>> getHistoryMsg({
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
  Future<PageResp<Target>> getPersons({
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
  Future<ApiResp> recallMsg(MessageDetail msg) {
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
  final StoreHub _chatHub;

  RealChatServer._(this._chatHub);

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
    dynamic apiResp = await _chatHub.invoke(sendName, args: args);
    return ApiResp.fromJson(apiResp);
  }

  /// 获取聊天对话
  @override
  Future<List<ChatGroup>> getChats() async {
    String key = SendEvent.GetChats.name;
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
  @override
  Future<String> getName(String personId) async {
    var key = SendEvent.GetName.name;
    var args = [personId];
    Map<String, dynamic> nameRes = await _chatHub.invoke(key, args: args);
    ApiResp resp = ApiResp.fromJson(nameRes);
    return resp.data;
  }

  /// 获取历史消息
  @override
  Future<List<MessageDetail>> getHistoryMsg({
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
  @override
  Future<ApiResp> recallMsg(MessageDetail msg) async {
    var name = SendEvent.RecallMsg.name;
    dynamic res = await _chatHub.invoke(name, args: [msg]);
    return ApiResp.fromJson(res);
  }

  /// 获取人员
  @override
  Future<PageResp<Target>> getPersons({
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
    dynamic res = await _chatHub.invoke(event, args: [params]);

    ApiResp apiResp = ApiResp.fromJson(res);
    return PageResp.fromMap(apiResp.data, Target.fromMap);
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

final ProxyChatServer chatServer = ProxyChatServer(RealChatServer._(chatHub))
  .._initEvents();
