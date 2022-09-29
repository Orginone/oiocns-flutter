import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:signalr_core/signalr_core.dart';

import '../api/constant.dart';
import '../api_resp/api_resp.dart';
import '../api_resp/message_detail_resp.dart';
import '../api_resp/message_item_resp.dart';
import '../api_resp/target_resp.dart';
import '../enumeration/target_type.dart';
import '../page/home/message/message_controller.dart';
import 'hive_util.dart';

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

class HubUtil {
  final Logger log = Logger("HubUtil");

  HubUtil._();

  static final HubUtil _instance = HubUtil._();

  factory HubUtil() {
    return _instance;
  }

  HubConnection? _server;
  bool isStop = true;
  final Rx<HubConnectionState> state = HubConnectionState.disconnected.obs;
  final Map<String, void Function(List<dynamic>?)> events = {};

  // 发送消息
  Future<void> sendMsg(Map<String, dynamic> messageDetail) async {
    if (isConn()) {
      var args = <Object>[messageDetail];
      var sendName = SendEvent.SendMsg.name;
      await _server!.invoke(sendName, args: args);
    } else {
      Fluttertoast.showToast(msg: "未连接聊天服务器!");
      throw Exception("未连接聊天服务器!");
    }
  }

  Future<List<SpaceMessagesResp>> getChats() async {
    if (isConn()) {
      String key = SendEvent.GetChats.name;
      Map<String, dynamic> chats = await _server!.invoke(key);
      ApiResp resp = ApiResp.fromMap(chats);

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
    return [];
  }

  Future<String> getName(String personId) async {
    if (isConn()) {
      var key = SendEvent.GetName.name;
      var args = [personId];
      Map<String, dynamic> nameRes = await _server!.invoke(key, args: args);
      ApiResp resp = ApiResp.fromMap(nameRes);
      return resp.data;
    }
    return "";
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
      await AnyStoreUtil().insert("chat-message", update, Domain.user.name);
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
      await AnyStoreUtil().insert(collName, data, Domain.user.name);
    }
  }

  Future<dynamic> cacheChats(OrgChatCache orgChatCache) async {
    Map<String, dynamic> setData = {
      "operation": "replaceAll",
      "data": {
        "name": "我的消息",
        "chats": SpaceMessagesResp.toJsonList(orgChatCache.chats),
        "nameMap": orgChatCache.nameMap,
        "openChats": MessageItemResp.toJsonList(orgChatCache.openChats),
        "lastMsg": {
          "chat": orgChatCache.target?.toJson(),
          "data": orgChatCache.messageDetail?.toJson()
        }
      }
    };
    await AnyStoreUtil().set(StoreKey.orgChat.name, setData, Domain.user.name);
  }

  Future<void> clearHistoryMsg(String? spaceId, String sessionId) async {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    spaceId = spaceId ?? userInfo.id;
    if (userInfo.id == spaceId) {
      // 清空会话
      Map<String, dynamic> match = {"sessionId": sessionId};
      await AnyStoreUtil().remove(collName, match, Domain.user.name);
    }
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
      var store = AnyStoreUtil();
      var domain = Domain.user.name;
      ApiResp apiResp = await store.aggregate(collName, options, domain);
      List<dynamic> details = apiResp.data ?? [];
      List<MessageDetailResp> ans = [];
      for (var item in details) {
        item["id"] = item["chatId"];
        ans.insert(0, MessageDetailResp.fromMap(item));
      }
      return ans;
    } else {
      if (isConn()) {
        String event = SendEvent.QueryFriendMsg.name;
        String idName = "friendId";
        if (typeName != TargetType.person.name) {
          event = SendEvent.QueryCohortMsg.name;
          idName = "cohortId";
        }
        Map<String, dynamic> params = {
          "limit": 30,
          idName: sessionId,
          "offset": offset,
          "spaceId": spaceId
        };
        Map<String, dynamic> res = await _server!.invoke(event, args: [params]);
        var apiResp = ApiResp.fromMap(res);
        Map<String, dynamic> data = apiResp.data;
        if (data["result"] == null) {
          return [];
        }
        List<dynamic> details = data["result"];
        return details.reversed
            .map((item) => MessageDetailResp.fromMap(item))
            .toList();
      }
      return [];
    }
  }

  Future<ApiResp> recallMsg(String id) async {
    if (isConn()) {
      Map<String, dynamic> params = {
        "ids": [id]
      };
      var name = SendEvent.RecallMsg.name;
      dynamic res = await _server!.invoke(name, args: [params]);
      return ApiResp.fromMap(res);
    }
    return ApiResp.empty();
  }

  Future<List<TargetResp>> getPersons(String id, int limit, int offset) async {
    if (isConn()) {
      String event = SendEvent.GetPersons.name;
      Map<String, dynamic> params = {
        "cohortId": id,
        "limit": limit,
        "offset": offset
      };
      dynamic res = await _server!.invoke(event, args: [params]);

      ApiResp apiResp = ApiResp.fromMap(res);
      var targetList = apiResp.data["result"];
      if (targetList == null) {
        return [];
      }

      List<TargetResp> temp = [];
      for (var target in targetList) {
        var targetResp = TargetResp.fromMap(target);
        temp.add(targetResp);
      }
      return temp;
    }
    return [];
  }

  //初始化连接
  Future<dynamic> tryConn() async {
    if (_server != null) {
      return;
    }
    log.info("================== 连接 HUB =========================");
    _server = HubConnectionBuilder().withUrl(Constant.hub).build();
    isStop = false;
    var state = _server!.state;
    switch (state) {
      case HubConnectionState.disconnected:
        log.info("====> connecting");
        try {
          // 定义事件和回调函数
          _initOnReconnecting();
          _initOnReconnected();
          _initOnClose();
          _initEvents();
          _initCallback();

          // 开启连接，鉴权
          await _server!.start();
          await _auth(HiveUtil().accessToken);

          log.info("====> connected success");
          log.info("================== 连接 HUB 成功 =========================");
        } catch (error) {
          error.printError();
          Fluttertoast.showToast(msg: "连接聊天服务器失败!");
          log.info("================== 连接 HUB 失败 =========================");
          _connTimeout();
        }
        break;
      default:
        log.info("====> 当前连接状态为：$state");
        break;
    }
    // 设置可观测状态
    setStatus();
  }

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
    events[ReceiveEvent.RecvMsg.name] = (params) {
      _rsvCallback(params ?? []);
    };
    events[ReceiveEvent.ChatRefresh.name] = (params) {
      if (Get.isRegistered<MessageController>()) {
        var messageController = Get.find<MessageController>();
        messageController.refreshCharts();
      }
    };
  }

  /// 函数回调
  void _initCallback() {
    if (_server == null) {
      return;
    }
    for (var element in ReceiveEvent.values) {
      void Function(List<dynamic>?) event = events[element.name]!;
      _server!.on(element.name, event);
    }
  }

  /// 鉴权
  Future<dynamic> _auth(String accessToken) async {
    if (isConn()) {
      String name = SendEvent.TokenAuth.name;
      await _server!.invoke(name, args: [accessToken]);
    }
  }

  /// 断开连接
  Future<dynamic> disconnect() async {
    if (_server == null) {
      return;
    }
    isStop = true;
    try {
      await _server!.stop();
      setStatus();
      _server = null;
      events.clear();

      log.info("===> 已断开和聊天服务器的连接。");
    } catch (error) {
      isStop = false;
    }
  }

  /// 重连定时器
  void _connTimeout() {
    log.info("====> 5s 后，hub 开始重新连接");
    Duration duration = const Duration(seconds: 5);
    Timer(duration, () async {
      _server?.stop();
      _server = null;
      await tryConn();
    });
  }

  /// 重连中回调
  void _initOnReconnecting() {
    if (_server == null) {
      return;
    }
    _server!.onreconnecting((exception) {
      setStatus();
      log.info("================== 正在重新连接 HUB  =========================");
      log.info("====> reconnecting");
      if (exception != null) {
        log.info("====> $exception");
      }
    });
  }

  /// 重连成功回调
  void _initOnReconnected() {
    if (_server == null) {
      return;
    }
    _server!.onreconnected((id) {
      setStatus();
      log.info("====> reconnected success");
      log.info("================== 重新连接 HUB 成功 =========================");
    });
  }

  /// 关闭回调
  void _initOnClose() {
    if (_server == null) {
      return;
    }
    _server!.onclose((error) {
      log.info("====> hub 连接被关闭了");
      setStatus();
      if (!isStop) {
        _connTimeout();
      }
    });
  }

  /// 设置状态
  setStatus() {
    state.value = _server?.state ?? HubConnectionState.disconnected;
  }

  /// 判断是否处于连接当中
  bool isConn() {
    if (_server == null) {
      return false;
    }
    return _server!.state == HubConnectionState.connected;
  }
}
