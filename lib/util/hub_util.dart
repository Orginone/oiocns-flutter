import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/collection_api.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:signalr_core/signalr_core.dart';

import '../api_resp/api_resp.dart';
import '../api_resp/message_detail_resp.dart';
import '../api_resp/target_resp.dart';
import '../api/constant.dart';
import '../page/home/message/message_controller.dart';
import 'errors.dart';
import 'hive_util.dart';

enum ReceiveEvent { RecvMsg }

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

class HubUtil {
  final Logger log = Logger("HubUtil");

  HubUtil._();

  static final HubUtil _instance = HubUtil._();

  factory HubUtil() {
    _instance.state ??= _instance._server.state.obs;
    return _instance;
  }

  final HubConnection _server =
      HubConnectionBuilder().withUrl(Constant.hub).build();
  Rx<HubConnectionState?>? state;

  final Map<String, void Function(List<dynamic>?)> events = {};

  void _initOnReconnecting() {
    _server.onreconnecting((exception) {
      setStatus();
      log.info("================== 正在重新连接 HUB  =========================");
      log.info("==> reconnecting");
      if (exception != null) {
        log.info("==> $exception");
      }
    });
  }

  void _initOnReconnected() {
    _server.onreconnected((id) {
      setStatus();
      log.info("==> reconnected success");
      log.info("================== 重新连接 HUB 成功 =========================");
    });
  }

  void _connTimer() {
    Duration duration = const Duration(seconds: 30);
    Timer.periodic(duration, (timer) async {
      await tryConn();
      setStatus();
      if (isConn()) {
        timer.cancel();
      }
    });
  }

  void _initOnClose() {
    _server.onclose((error) {
      setStatus();
      _connTimer();
    });
  }

  void _initEvents() {
    events[ReceiveEvent.RecvMsg.name] = (params) {
      // 消息页面每时都在接收
      var messageController = Get.find<MessageController>();
      messageController.onReceiveMessage(params ?? []);
    };
  }

  void _initCallback() {
    for (var element in ReceiveEvent.values) {
      void Function(List<dynamic>?) event = events[element.name]!;
      _server.on(element.name, event);
    }
  }

  Future<dynamic> _auth(String accessToken) async {
    checkConn();
    return _server.invoke(SendEvent.TokenAuth.name, args: [accessToken]);
  }

  Future<dynamic> disconnect() async {
    await _server.stop();
    setStatus();
    log.info("===> 已断开和聊天服务器的连接。");
  }

  Future<List<SpaceMessagesResp>> getChats() async {
    checkConn();
    String key = SendEvent.GetChats.name;
    Map<String, dynamic> chats = await _server.invoke(key);
    ApiResp resp = ApiResp.fromMap(chats);

    List<dynamic> groups = resp.data["groups"];
    List<SpaceMessagesResp> messageGroups =
        groups.map((item) => SpaceMessagesResp.fromMap(item)).toList();
    return messageGroups;
  }

  Future<String> getName(String personId) async {
    checkConn();
    String key = SendEvent.GetName.name;
    Map<String, dynamic> nameRes = await _server.invoke(key, args: [personId]);
    ApiResp resp = ApiResp.fromMap(nameRes);
    return resp.data;
  }

  Future<dynamic> cacheMsg(String sessionId, MessageDetailResp detail) async {
    if (detail.msgType == "recall") {
      Map<String, dynamic> update = {
        "match": {"chatId": detail.id},
        "update": {
          "_set_": {"msgBody": detail.msgBody, "msgType": detail.msgType}
        },
        "options": {}
      };
      CollectionApi.update("chat-message", update, Domain.user.name);
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
            format: "yyyy/MM/dd HH:mm:ss")
      };
      CollectionApi.insert(collName, data, Domain.user.name);
    }
  }

  Future<dynamic> cacheChats(OrgChatCache orgChatCache) async {
    Map<String, dynamic> setData = {
      "operation": "replaceAll",
      "data": {
        "name": "我的消息",
        "chats": SpaceMessagesResp.toJsonList(orgChatCache.chats),
        "nameMap": orgChatCache.nameMap,
        "openChats": SpaceMessagesResp.toJsonList(orgChatCache.openChats),
        "lastMsg": {
          "chat": orgChatCache.target?.toJson(),
          "data": orgChatCache.messageDetail?.toJson()
        }
      }
    };
    await AnyStoreUtil().set(StoreKey.orgChat.name, setData, Domain.user.name);
  }

  Future<List<MessageDetailResp>> getHistoryMsg(String? spaceId,
      String sessionId, String typeName, int offset, int limit) async {
    // 默认我的空间
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    spaceId = spaceId ?? userInfo.id;
    if (userInfo.id == spaceId) {
      // 如果是个人空间从本地存储拿数据
      Map<String, dynamic> options = {
        "match": {
          "sessionId": sessionId,
        },
        "sort": {"createTime": -1},
        "skip": offset,
        "limit": limit
      };
      List<dynamic> details =
          await CollectionApi.aggregate(collName, options, Domain.user.name);
      List<MessageDetailResp> ans = [];
      for (var item in details) {
        item["id"] = item["chatId"];
        ans.insert(0, MessageDetailResp.fromMap(item));
      }
      return ans;
    } else {
      checkConn();
      String funcName = SendEvent.QueryFriendMsg.name;
      String idName = "friendId";
      if (typeName != "人员") {
        funcName = SendEvent.QueryCohortMsg.name;
        idName = "cohortId";
      }
      Map<String, dynamic> params = {
        "limit": 30,
        idName: sessionId,
        "offset": offset,
        "spaceId": spaceId
      };
      Map<String, dynamic> res = await _server.invoke(funcName, args: [params]);
      var apiResp = ApiResp.fromMap(res);
      Map<String, dynamic> data = apiResp.data;
      List<dynamic> details = data["result"];
      return details.map((item) => MessageDetailResp.fromMap(item)).toList();
    }
  }

  Future<dynamic> recallMsg(String id) async {
    checkConn();
    return await _server.invoke(SendEvent.RecallMsg.name, args: [
      {
        "ids": [id]
      }
    ]);
  }

  Future<List<TargetResp>> getPersons(String id, int limit, int offset) async {
    checkConn();
    Map params = {"cohortId": id, "limit": limit, "offset": offset};
    dynamic res =
        await _server.invoke(SendEvent.GetPersons.name, args: [params]);

    ApiResp apiResp = ApiResp.fromMap(res);
    var targetList = apiResp.data["result"];

    List<TargetResp> temp = [];
    for (var target in targetList) {
      var targetResp = TargetResp.fromMap(target);
      temp.add(targetResp);
    }
    return temp;
  }

  //初始化连接
  Future<dynamic> tryConn() async {
    log.info("================== 连接 HUB =========================");

    var state = _server.state;
    switch (state) {
      case HubConnectionState.disconnected:
        log.info("==> connecting");
        try {
          // 定义事件和回调函数
          _initOnReconnecting();
          _initOnReconnected();
          _initOnClose();
          _initEvents();
          _initCallback();

          // 开启连接，鉴权
          await _server.start();
          await _auth(HiveUtil().accessToken);
          setStatus();

          log.info("==> connected success");
          log.info("================== 连接 HUB 成功 =========================");
        } catch (error) {
          error.printError();
          EasyLoading.showToast("连接聊天服务器失败!");
          log.info("================== 连接 HUB 失败 =========================");
          _connTimer();
        }
        break;
      default:
        log.info("==> 当前连接状态为：$state");
        break;
    }
  }

  setStatus() {
    state!.value = _server.state;
  }

  // 判断是否处于连接当中
  bool isConn() {
    return _server.state == HubConnectionState.connected;
  }

  checkConn() {
    if (!isConn()) {
      var errorMsg = "未连接聊天服务器!";
      EasyLoading.showToast(errorMsg);
      throw ServerError(errorMsg);
    }
  }

  // 发送消息
  Future<dynamic> sendMsg(Map<String, dynamic> messageDetail) async {
    checkConn();
    return await _server
        .invoke(SendEvent.SendMsg.name, args: <Object>[messageDetail]);
  }
}
