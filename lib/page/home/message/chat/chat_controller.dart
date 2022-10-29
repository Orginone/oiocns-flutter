import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/bucket_api.dart';
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
import '../../../../logic/authority.dart';
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
    closeChats();
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

    // 初始化老数据个数，查询聊天记录的个数
    await getTotal();
    await getHistoryMsg();
    titleName.value = getTitleName();
    update();

    // 处理缓存
    openChats();
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

  closeChats() async {
    // 关闭会话时去除当前的
    var orgChatCache = messageController.orgChatCache;
    orgChatCache.openChats = orgChatCache.openChats
        .where((chat) => chat.spaceId != spaceId || chat.id != messageItemId)
        .toList();

    HubUtil().cacheChats(orgChatCache);
  }

  void openChats() async {
    // 打开的会话不存在就加入
    OrgChatCache orgChatCache = messageController.orgChatCache;
    orgChatCache.openChats = orgChatCache.openChats
        .where((item) => item.id != messageItemId || item.spaceId != spaceId)
        .toList();
    orgChatCache.openChats.add(messageItem);

    // 加入近期会话
    orgChatCache.recentChats ??= [];
    bool has = false;
    for (var item in orgChatCache.recentChats!) {
      if (item.spaceId == spaceId && item.id == messageItemId) {
        has = true;
      }
    }
    if (!has) {
      orgChatCache.recentChats!.add(messageItem);
      messageController.sortingItems(orgChatCache.recentChats!);
    }

    // 加入自己
    messageItem.noRead = 0;
    messageController.update();

    HubUtil().cacheChats(messageController.orgChatCache);
  }

  Future<int> getTotal() async {
    if (messageItem.typeName != TargetType.person.name) {
      var page = await HubUtil().getPersons(messageItemId, 1, 0);
      return page.total;
    }
    return 0;
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getHistoryMsg({bool isCacheNameMap = false}) async {
    String typeName = messageItem.typeName;

    var insertPointer = messageDetails.length;
    List<MessageDetailResp> newDetails = await HubUtil()
        .getHistoryMsg(spaceId, messageItemId, typeName, insertPointer, 15);

    Map<String, dynamic> nameMap = messageController.orgChatCache.nameMap;
    for (MessageDetailResp detail in newDetails) {
      messageDetails.insert(insertPointer, detail);
      if (!nameMap.containsKey(detail.fromId)) {
        var name = await HubUtil().getName(detail.fromId);
        nameMap[detail.fromId] = name;
      }
    }
    if (isCacheNameMap) {
      HubUtil().cacheChats(messageController.orgChatCache);
    }
  }

  /// 发送消息至聊天页面
  void sendOneMessage(String value, {MsgType? msgType}) {
    if (messageItemId == "-1") return;

    // toId 和 spaceId 都要是字符串类型
    if (value.isNotEmpty) {
      var messageDetail = {
        "toId": messageItemId,
        "spaceId": spaceId,
        "msgType": msgType?.name ?? MsgType.text.name,
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
    Image imageCompo = Image.memory(await file.readAsBytes());
    imageCompo.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (imageInfo, synchronousCall) async {
          TargetResp userInfo = auth.userInfo;
          String prefix = "chat_${userInfo.id}_${messageItem.id}_image";
          log.info("====> prefix:$prefix");
          String encodedPrefix = EncryptionUtil.encodeURLString(prefix);

          try {
            await BucketApi.create(prefix: encodedPrefix);
          } catch (error) {
            log.warning("====> 创建目录失败：$error");
          }
          var filePath = file.path;
          var fileName = file.name;

          await BucketApi.uploadChunk(
            prefix: encodedPrefix,
            filePath: filePath,
            fileName: fileName,
          );

          Map<String, dynamic> body = {
            "width": imageInfo.image.width,
            "height": imageInfo.image.height,
            "path": "$prefix/$fileName",
          };

          sendOneMessage(jsonEncode(body), msgType: MsgType.image);
        },
      ),
    );
  }

  /// 语音录制完成并发送
  void sendVoice(String fileName, String filePath, int milliseconds) async {
    TargetResp userInfo = auth.userInfo;
    String prefix = "chat_${userInfo.id}_${messageItem.id}_voice";
    log.info("====> prefix:$prefix");
    String encodedPrefix = EncryptionUtil.encodeURLString(prefix);

    try {
      await BucketApi.create(prefix: encodedPrefix);
    } catch (error) {
      log.warning("====> 创建目录失败：$error");
    }
    await BucketApi.upload(
      prefix: encodedPrefix,
      filePath: filePath,
      fileName: fileName,
    );

    Map<String, dynamic> msgBody = {
      "path": "$prefix/$fileName",
      "milliseconds": milliseconds
    };
    sendOneMessage(jsonEncode(msgBody), msgType: MsgType.voice);
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
      itemName = "$itemName(${messageItem.personNum ?? 0})";
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
  startPlayVoice(String id, File file) async {
    await stopPrePlayVoice();

    // 动画效果
    _currentVoicePlay = playStatusMap[id];
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _currentVoicePlay!.initProgress),
    );
    animation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.linear,
    ));
    animationController!.forward();

    // 监听进度
    _soundPlayer ??= await FlutterSoundPlayer().openPlayer();
    _soundPlayer!.setSubscriptionDuration(const Duration(milliseconds: 50));
    _mt = _soundPlayer!.onProgress!.listen((event) {
      _currentVoicePlay!.progress.value = event.position.inMilliseconds;
    });
    _soundPlayer!
        .startPlayer(
            fromDataBuffer: file.readAsBytesSync(),
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
