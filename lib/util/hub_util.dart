import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:signalr_core/signalr_core.dart';

import '../api_resp/api_resp.dart';
import '../api_resp/target_resp.dart';
import '../config/constant.dart';
import '../page/home/message/message_controller.dart';
import 'hive_util.dart';

enum ReceiveEvent { RecvMsg }

enum SendEvent { TokenAuth, GetChats, SendMsg, GetPersons }

class HubUtil {
  HubUtil._();

  static final HubUtil _instance = HubUtil._();

  factory HubUtil() {
    return _instance;
  }

  final Logger log = Logger("HubConn");
  final HubConnection _connServer =
      HubConnectionBuilder().withUrl(Constant.hub).build();
  final Map<String, void Function(List<dynamic>?)> events = {};

  void _initEvents() {
    events[ReceiveEvent.RecvMsg.name] = (params) {
      // 消息页面每时都在接收
      var messageController = Get.find<MessageController>();
      messageController.onReceiveMessage(params ?? []);
    };
  }

  void _initCallback() {
    _connServer.onclose((error) => log.severe(error));
    for (var element in ReceiveEvent.values) {
      void Function(List<dynamic>?) event = events[element.name]!;
      _connServer.on(element.name, event);
    }
  }

  Future<dynamic> _auth(String accessToken) async {
    return _connServer.invoke(SendEvent.TokenAuth.name, args: [accessToken]);
  }

  Future<dynamic> getChats() async {
    return await _connServer.invoke(SendEvent.GetChats.name);
  }

  Future<List<TargetResp>> getPersons(int id, int limit, int offset) async {
    Map params = {"cohortId": "$id", "limit": limit, "offset": offset};
    dynamic res = await _connServer.invoke(SendEvent.GetPersons.name, args: [params]);

    ApiResp apiResp = ApiResp.fromMap(res);
    var targetList = apiResp.data["result"];

    List<TargetResp> temp = [];
    for(var target in targetList){
      var targetResp = TargetResp.fromMap(target);
      temp.add(targetResp);
    }
    return temp;
  }

  //初始化连接
  Future<dynamic> conn() async {
    log.info("================== 连接 HUB =========================");

    var state = _connServer.state;
    switch (state) {
      case HubConnectionState.disconnected:
        log.info("==> connecting");
        try {
          // 定义事件和回调函数
          _initEvents();
          _initCallback();

          // 开启连接，鉴权
          await _connServer.start();
          await _auth(HiveUtil().getValue(Keys.accessToken));

          log.info("==> connected success");
          log.info("================== 连接 HUB 成功 =========================");
        } catch (error) {
          error.printError();
          EasyLoading.showToast("连接聊天服务器失败!");
          log.info("================== 连接 HUB 失败 =========================");
        }
        break;

      case HubConnectionState.connected:
        log.info("==> 已建立与 HUB 的连接");
        break;

      default:
        log.info("==> 连接失败，当前连接状态为：$state");
        break;
    }
  }

  // 判断是否处于连接当中
  bool isConn() {
    return _connServer.state == HubConnectionState.connected;
  }

  // 发送消息
  Future<dynamic> sendMsg(Map<String, dynamic> messageDetail) async {
    if (!isConn()) {
      EasyLoading.showToast("未连接聊天服务器!");
      return;
    }
    return await _connServer
        .invoke(SendEvent.SendMsg.name, args: <Object>[messageDetail]);
  }
}
