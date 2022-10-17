import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/chat/component/chat_message_detail.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/hub_util.dart';
import 'package:uuid/uuid.dart';

import '../../../../api_resp/api_resp.dart';
import '../../../../api_resp/message_item_resp.dart';
import '../../../../api_resp/target_resp.dart';
import '../../../../enumeration/message_type.dart';
import '../../../../enumeration/target_type.dart';
import '../message_controller.dart';

/// 播放状态
enum PlayStatus { stop, playing }

/// 语音播放器状态类
class VoicePlay {
  final MessageDetailResp detailResp;
  final Rx<PlayStatus> status;
  final int initProgress;
  final RxInt progress;
  final String path;

  const VoicePlay({
    required this.detailResp,
    required this.status,
    required this.initProgress,
    required this.progress,
    required this.path,
  });
}

class ChatController extends GetxController with GetTickerProviderStateMixin {
  // 日志
  var log = Logger("ChatController");

  // 控制信息
  var homeController = Get.find<HomeController>();
  var messageController = Get.find<MessageController>();
  var messageScrollController = ScrollController();
  var messageScrollKey = "1024".obs;
  var uuid = const Uuid();
  var resizeToAvoidBottomInset = true.obs;

  // 当前所在的群组
  late MessageItemResp messageItem;
  late String spaceId;
  late String messageItemId;

  // 当前群所有人
  late RxString titleName;
  late Map<String, TargetResp> personMap;
  late Map<String, String> personNameMap;
  late List<TargetResp> personList;

  // 观测对象
  late List<MessageDetailResp> messageDetails;

  // 语音播放器
  FlutterSoundPlayer? _soundPlayer;
  StreamSubscription? _mt;
  AnimationController? animationController;
  Animation<AlignmentGeometry>? animation;
  Map<String, VoicePlay> playStatusMap = {};
  VoicePlay? _currentVoicePlay;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
    var orgChatCache = messageController.orgChatCache;
    var openChats = orgChatCache.openChats
        .where((chat) => chat.spaceId != spaceId || chat.id != messageItemId)
        .toList();
    orgChatCache.openChats = openChats;
    HubUtil().cacheChats(orgChatCache);
  }

  // 初始化
  Future<void> init() async {
    // 获取参数
    Map<String, dynamic> args = Get.arguments;
    messageItem = args["messageItem"];
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];
    titleName = messageItem.name.obs;

    // 清空所有聊天记录
    messageDetails = [];
    personNameMap = {};
    personMap = {};
    personList = [];

    // 初始化老数据个数，查询聊天记录的个数
    await getPersons();
    await getHistoryMsg();
    titleName.value = getTitleName();
    update();

    // 处理缓存
    orgChatHandler();
  }

  // 消息接收函數
  void onReceiveMsg(
    String spaceId,
    String sessionId,
    MessageDetailResp? detail,
  ) {
    if (spaceId != this.spaceId && sessionId != messageItemId) {
      return;
    }
    if (detail == null) {
      return;
    }
    log.info("会话页面接收到一条新的数据${detail.toJson()}");
    if (detail.msgType == "recall") {
      for (var oldDetail in messageDetails) {
        if (oldDetail.id == detail.id) {
          oldDetail.msgBody = detail.msgBody;
          oldDetail.msgType = detail.msgType;
          oldDetail.createTime = detail.createTime;
          break;
        }
      }
    } else {
      int has = messageDetails.where((item) => item.id == detail.id).length;
      if (has == 0) {
        detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
        messageDetails.insert(0, detail);
      }
    }
    updateAndToBottom();
  }

  void orgChatHandler() {
    // 不存在就加入
    OrgChatCache orgChatCache = messageController.orgChatCache;
    orgChatCache.openChats = orgChatCache.openChats
        .where((item) => item.id != messageItemId || item.spaceId != spaceId)
        .toList();
    orgChatCache.openChats.add(messageItem);

    // 加入所有人员群缓存
    orgChatCache.nameMap.addAll(personNameMap);

    // 加入自己
    messageItem.noRead = 0;
    messageItem.personNum = personMap.length;
    messageController.update();

    HubUtil().cacheChats(messageController.orgChatCache);
  }

  /// 查询群成员信息
  Future<Map<String, String>> getPersons() async {
    if (messageItem.typeName == TargetType.person.name) {
      var name = await HubUtil().getName(messageItemId);
      personNameMap[messageItemId] = name;
      return personNameMap;
    }
    int offset = 0;
    int limit = 100;
    while (true) {
      List<TargetResp> persons = await HubUtil().getPersons(
        messageItemId,
        limit,
        offset,
      );
      personList.addAll(persons);
      if (persons.isEmpty) {
        break;
      }
      for (var person in persons) {
        personMap[person.id] = person;
        var typeName = person.typeName;
        typeName = typeName == TargetType.person.name ? "" : "[$typeName]";
        personNameMap[person.id] = "${person.team?.name}$typeName";
      }
      offset += limit;
      if (persons.length < limit) {
        break;
      }
    }
    return personNameMap;
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getHistoryMsg() async {
    String typeName = messageItem.typeName;

    var insertPointer = messageDetails.length;
    List<MessageDetailResp> newDetails = await HubUtil()
        .getHistoryMsg(spaceId, messageItemId, typeName, insertPointer, 15);

    for (MessageDetailResp detail in newDetails) {
      messageDetails.insert(insertPointer, detail);
    }
  }

  /// 发送消息至聊天页面
  void sendOneMessage(String value) {
    if (messageItemId == "-1") return;

    // toId 和 spaceId 都要是字符串类型
    if (value.isNotEmpty) {
      var messageDetail = {
        "toId": messageItemId,
        "spaceId": spaceId,
        "msgType": MsgType.text.name,
        "msgBody": EncryptionUtil.deflate(value)
      };
      try {
        log.info("====> 发送的消息信息：$messageDetail");
        HubUtil().sendMsg(messageDetail);
      } catch (error) {
        error.printError();
      }
    }
  }

  /// 相册选择照片后回调
  void imagePicked(XFile file) async {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    Image imageCompo = Image.memory(await file.readAsBytes());
    imageCompo.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (imageInfo, synchronousCall) {
          Map<String, dynamic> body = {
            "width": imageInfo.image.width,
            "height": imageInfo.image.height,
            "path": file.path
          };
          messageDetails.insert(
              0,
              MessageDetailResp(
                id: "${DateTime.now().millisecondsSinceEpoch}",
                spaceId: userInfo.id,
                fromId: userInfo.id,
                toId: messageItem.id,
                msgType: MsgType.image.name,
                msgBody: jsonEncode(body),
              ));
          updateAndToBottom();
        },
      ),
    );
  }

  /// 语音录制完成并发送
  void sendVoice(String path, int seconds) {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    Map<String, dynamic> msgBody = {"path": path, "seconds": seconds};
    messageDetails.insert(
        0,
        MessageDetailResp(
          id: "${DateTime.now().millisecondsSinceEpoch}",
          spaceId: userInfo.id,
          fromId: userInfo.id,
          toId: messageItem.id,
          msgType: MsgType.voice.name,
          msgBody: jsonEncode(msgBody),
        ));
    updateAndToBottom();
  }

  /// 滚动到页面底部
  void updateAndToBottom() {
    if (messageScrollController.positions.isNotEmpty &&
        messageScrollController.offset != 0) {
      messageScrollKey.value = uuid.v4();
    }
    update();
  }

  /// 获取顶部群名称
  String getTitleName() {
    String itemName = messageItem.name;
    if (messageItem.typeName != TargetType.person.name) {
      itemName = "$itemName(${personList.length})";
    }
    return itemName;
  }

  /// 会话函数
  detailFuncCallback(
    DetailFunc func,
    String spaceId,
    String sessionId,
    MessageDetailResp detail,
  ) async {
    switch (func) {
      case DetailFunc.recall:
        ApiResp apiResp = await HubUtil().recallMsg(detail);
        if (apiResp.success) {
          Fluttertoast.showToast(msg: "撤回成功！");
        }
        break;
      case DetailFunc.remove:
        await HubUtil().deleteMsg(detail.id);
        messageDetails =
            messageDetails.where((item) => item.id != detail.id).toList();
        update();
        break;
    }
  }

  /// 开始播放
  startPlayVoice(String id) async {
    await stopPrePlayVoice();

    // 动画效果
    _currentVoicePlay = playStatusMap[id];
    var progress = _currentVoicePlay!.progress.value;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: progress),
    );
    animation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.linear,
    ));

    // 监听进度
    _soundPlayer ??= await FlutterSoundPlayer().openPlayer();
    _soundPlayer!.setSubscriptionDuration(const Duration(milliseconds: 50));
    _mt = _soundPlayer!.onProgress!.listen((event) {
      _currentVoicePlay!.progress.value = event.position.inSeconds;
    });
    _soundPlayer!
        .startPlayer(
            fromDataBuffer: File(_currentVoicePlay!.path).readAsBytesSync(),
            whenFinished: () => stopPrePlayVoice())
        .catchError((error) => stopPrePlayVoice());

    // 重新开始播放
    _currentVoicePlay!.status.value = PlayStatus.playing;
  }

  /// 停止播放
  stopPrePlayVoice() async {
    if (_currentVoicePlay != null) {
      // 改状态
      _currentVoicePlay!.status.value = PlayStatus.stop;
      _currentVoicePlay!.progress.value = _currentVoicePlay!.initProgress;

      // 关闭播放
      await _soundPlayer?.stopPlayer();
      _mt?.cancel();
      _mt = null;
      _soundPlayer = null;

      // 关闭动画
      animation = null;
      animationController?.stop();
      animationController?.dispose();
      animationController = null;

      // 空引用
      _currentVoicePlay = null;
    }
  }
}
