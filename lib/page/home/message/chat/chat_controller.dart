import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/bucket_api.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/core/ui/message/chat_message_detail.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/api/hub/chat_server.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/util/api_exception.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:uuid/uuid.dart';

class Detail {
  final MessageDetail resp;

  const Detail.fromResp(this.resp);

  /// 构造工厂
  factory Detail(MessageDetail resp) {
    MsgType msgType = EnumMap.messageTypeMap[resp.msgType] ?? MsgType.unknown;
    Map<String, dynamic> msgMap = jsonDecode(resp.msgBody ?? "{}");
    switch (msgType) {
      case MsgType.file:
        // 文件
        String fileName = msgMap["fileName"] ?? "";
        String path = msgMap["path"] ?? "";
        String size = msgMap["size"] ?? "";
        return FileDetail(
          fileName: fileName,
          resp: resp,
          status: FileStatus.local.obs,
          progress: 0.0.obs,
          path: path,
          size: size,
        );
      case MsgType.voice:
        // 语音
        int milliseconds = msgMap["milliseconds"] ?? 0;
        List<dynamic> rowBytes = msgMap["bytes"] ?? [];
        List<int> tempBytes = rowBytes.map((byte) => byte as int).toList();
        return VoiceDetail(
          resp: resp,
          status: VoiceStatus.stop.obs,
          initProgress: milliseconds,
          progress: milliseconds.obs,
          bytes: Uint8List.fromList(tempBytes),
        );
      default:
        return Detail.fromResp(resp);
    }
  }
}

/// 播放状态
enum VoiceStatus { stop, playing }

/// 语音播放类
class VoiceDetail extends Detail {
  final Rx<VoiceStatus> status;
  final int initProgress;
  final RxInt progress;
  final Uint8List bytes;

  const VoiceDetail({
    required MessageDetail resp,
    required this.status,
    required this.initProgress,
    required this.progress,
    required this.bytes,
  }) : super.fromResp(resp);
}

/// 文件状态
enum FileStatus { local, uploading, pausing, stopping, uploaded, synced }

/// 文件上传状态类
class FileDetail extends Detail {
  final String fileName;
  final Rx<FileStatus> status;
  final RxDouble progress;
  final String path;
  final String size;

  const FileDetail({
    required MessageDetail resp,
    required this.fileName,
    required this.status,
    required this.progress,
    required this.path,
    required this.size,
  }) : super.fromResp(resp);
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
  late MessageTarget messageItem;
  late String spaceId;
  late String messageItemId;

  // 观测对象
  late RxList<Detail> _details;

  RxList<Detail> get details => _details;

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
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];
    messageItem = messageController.getMsgItem(spaceId, messageItemId);

    // 清空所有聊天记录
    _details = <Detail>[].obs;

    // 初始化老数据个数，查询聊天记录的个数
    await getHistoryMsg();

    // 处理缓存
    openChats();
  }

  // 消息接收函數
  void onReceiveMsg(
    String spaceId,
    String sessionId,
    MessageDetail? detail,
  ) {
    if (spaceId != this.spaceId && sessionId != messageItemId) {
      return;
    }
    if (detail == null) {
      return;
    }

    messageItem = messageController.getMsgItem(spaceId, messageItemId);

    log.info("会话页面接收到一条新的数据${detail.toJson()}");
    if (detail.msgType == MsgType.recall.name) {
      for (var oldDetail in _details) {
        var resp = oldDetail.resp;
        if (resp.id == detail.id) {
          resp.msgBody = detail.msgBody;
          resp.msgType = detail.msgType;
          resp.createTime = detail.createTime;
          break;
        }
      }
      return;
    }

    /// 插入会话
    int has = _details
        .map((item) => item.resp)
        .where((item) => item.id == detail.id)
        .length;
    if (has == 0) {
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      _details.insert(0, Detail.fromResp(detail));
      updateAndToBottom();
    }
  }

  closeChats() async {
    // 关闭会话时去除当前的
    var orgChatCache = messageController.orgChatCache;
    orgChatCache.openChats = orgChatCache.openChats
        .where((chat) => chat.spaceId != spaceId || chat.id != messageItemId)
        .toList();

    Kernel.getInstance.anyStore.cacheChats(orgChatCache);
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
    orgChatCache.recentChats!.removeWhere((item) {
      return item.spaceId == spaceId && item.id == messageItemId;
    });
    orgChatCache.recentChats!.add(messageItem);
    messageController.sortingItems(orgChatCache.recentChats!);

    // 加入自己
    messageItem.noRead = 0;
    messageController.update();

    Kernel.getInstance.anyStore.cacheChats(messageController.orgChatCache);
  }

  /// 下拉时刷新旧的聊天记录
  Future<void> getHistoryMsg({bool isCacheNameMap = false}) async {
    var typeMap = EnumMap.targetTypeMap;
    var typeName = messageItem.typeName;
    if (!typeMap.containsKey(messageItem.typeName)) {
      throw ApiException("未知的会话类型！");
    }

    var insertPointer = _details.length;
    late List<MessageDetail> newDetails;
    if (auth.userId == spaceId) {
      newDetails = await Kernel.getInstance.anyStore.getUserSpaceHistoryMsg(
        typeName: typeMap[typeName]!,
        sessionId: messageItemId,
        offset: insertPointer,
        limit: 15,
      );
    } else {
      newDetails = await chatServer.getHistoryMsg(
        spaceId: spaceId,
        sessionId: messageItemId,
        typeName: typeMap[typeName]!,
        offset: insertPointer,
        limit: 15,
      );
    }

    Map<String, dynamic> nameMap = messageController.orgChatCache.nameMap;
    for (MessageDetail detail in newDetails) {
      _details.insert(insertPointer, Detail.fromResp(detail));
      if (!nameMap.containsKey(detail.fromId)) {
        var name = await chatServer.getName(detail.fromId);
        nameMap[detail.fromId] = name;
      }
    }
    if (isCacheNameMap) {
      Kernel.getInstance.anyStore.cacheChats(messageController.orgChatCache);
    }
  }

  /// 相册选择照片后回调
  void imagePicked(XFile file) async {
    Image imageCompo = Image.memory(await file.readAsBytes());
    imageCompo.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (imageInfo, synchronousCall) async {
          String encodedPrefix = EncryptionUtil.encodeURLString("");

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
            "path": fileName,
          };

          await chatServer.send(
            spaceId: spaceId,
            itemId: messageItemId,
            msgBody: jsonEncode(body),
            msgType: MsgType.image,
          );
        },
      ),
    );
  }

  /// 语音录制完成并发送
  void filePicked(String fileName, String filePath) async {
    // TargetResp userInfo = auth.userInfo;
    // String prefix = "chat_${userInfo.id}_${messageItem.id}_voice";
    // log.info("====> prefix:$prefix");
    // String encodedPrefix = EncryptionUtil.encodeURLString(prefix);
    //
    // try {
    //   await BucketApi.create(prefix: encodedPrefix);
    // } catch (error) {
    //   log.warning("====> 创建目录失败：$error");
    // }
    // await BucketApi.upload(
    //   prefix: encodedPrefix,
    //   filePath: filePath,
    //   fileName: fileName,
    // );
    //
    // Map<String, dynamic> msgBody = {
    //   "path": "$prefix/$fileName",
    // };
    // sendOneMessage(jsonEncode(msgBody), msgType: MsgType.voice);
  }

  /// 滚动到页面底部
  void updateAndToBottom() {
    if (messageScrollController.positions.isNotEmpty &&
        messageScrollController.offset != 0) {
      messageScrollKey.value = uuid.v4();
    }
    update();
  }

  /// 会话函数
  detailFuncCallback(
    DetailFunc func,
    String spaceId,
    String sessionId,
    MessageDetail detail,
  ) async {
    switch (func) {
      case DetailFunc.recall:
        ApiResp apiResp = await chatServer.recallMsg(detail);
        if (apiResp.success) {
          Fluttertoast.showToast(msg: "撤回成功！");
        }
        break;
      case DetailFunc.remove:
        await Kernel.getInstance.anyStore.deleteMsg(detail.id);
        _details.removeWhere((item) => item.resp.id == detail.id);
        break;
    }
  }
}
