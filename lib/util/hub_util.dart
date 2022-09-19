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

enum SendEvent { TokenAuth, GetChats, SendMsg, GetPersons, RecallMsg }

String collName = "chat-message";

class HubUtil {
  final Logger log = Logger("HubUtil");

  HubUtil._();

  static final HubUtil _instance = HubUtil._();

  factory HubUtil() {
    _instance.state ??= _instance._connServer.state.obs;
    return _instance;
  }

  final HubConnection _connServer =
      HubConnectionBuilder().withUrl(Constant.hub).build();
  Rx<HubConnectionState?>? state;

  final Map<String, void Function(List<dynamic>?)> events = {};

  void _initOnReconnecting() {
    _connServer.onreconnecting((exception) {
      setStatus();
      log.info("================== 正在重新连接 HUB  =========================");
      log.info("==> reconnecting");
      if (exception != null) {
        log.info("==> $exception");
      }
    });
  }

  void _initOnReconnected() {
    _connServer.onreconnected((id) {
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
    _connServer.onclose((error) {
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
      _connServer.on(element.name, event);
    }
  }

  Future<dynamic> _auth(String accessToken) async {
    checkConn();
    return _connServer.invoke(SendEvent.TokenAuth.name, args: [accessToken]);
  }

  Future<dynamic> disconnect() async {
    await _connServer.stop();
    setStatus();
    log.info("===> 已断开和聊天服务器的连接。");
  }

  Future<dynamic> getChats() async {
    checkConn();
    return await _connServer.invoke(SendEvent.GetChats.name);
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
            format: "yyyy/MM/dd hh:mm:ss")
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
        "nameMap": orgChatCache.nameMap?.map(OrgChatCache.outEntry),
        "openChats": SpaceMessagesResp.toJsonList(orgChatCache.openChats),
        "lastMsg": {
          "chat": orgChatCache.target?.toJson(),
          "data": orgChatCache.messageDetail?.toJson()
        }
      }
    };
    await AnyStoreUtil().set(StoreKey.orgChat.name, setData, Domain.user.name);
  }

  Future<dynamic> recallMsg(String id) async {
    checkConn();
    return await _connServer.invoke(SendEvent.RecallMsg.name, args: [
      {
        "ids": [id]
      }
    ]);
  }

  Future<List<TargetResp>> getPersons(String id, int limit, int offset) async {
    checkConn();
    Map params = {"cohortId": id, "limit": limit, "offset": offset};
    dynamic res =
        await _connServer.invoke(SendEvent.GetPersons.name, args: [params]);

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

    var state = _connServer.state;
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
          await _connServer.start();
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
    state!.value = _connServer.state;
  }

  // 判断是否处于连接当中
  bool isConn() {
    return _connServer.state == HubConnectionState.connected;
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
    return await _connServer
        .invoke(SendEvent.SendMsg.name, args: <Object>[messageDetail]);
  }
}
