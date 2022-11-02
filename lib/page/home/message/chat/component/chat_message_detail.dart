import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/bucket_api.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../component/a_font.dart';
import '../../../../../component/unified_colors.dart';
import '../../../../../component/unified_edge_insets.dart';
import '../../../../../component/unified_text_style.dart';
import '../../../../../config/constant.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../logic/authority.dart';
import '../../../../../util/encryption_util.dart';
import '../../../../../util/string_util.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除");

  const DetailFunc(this.name);

  final String name;
}

double defaultWidth = 10.w;

class ChatMessageDetail extends GetView<ChatController> {
  final Logger log = Logger("ChatMessageDetail");

  final MessageDetailResp detail;
  final bool isMy;
  final bool isMultiple;
  final MsgType msgType;

  ChatMessageDetail({
    required this.detail,
    required this.isMy,
    required this.isMultiple,
    Key? key,
  })  : msgType = EnumMap.messageTypeMap[detail.msgType] ?? MsgType.unknown,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];
    switch (msgType) {
      case MsgType.text:
      case MsgType.image:
      case MsgType.voice:
        children.add(_getAvatar());
        children.add(_getChat(context));
        break;
      case MsgType.recall:
        var messageItem = controller.messageItem;
        var nameMap = controller.messageController.orgChatCache.nameMap;
        String msgBody = StringUtil.getDetailRecallBody(
          item: messageItem,
          detail: detail,
          nameMap: nameMap,
        );
        children.add(Text(msgBody, style: AFont.instance.size16Black9));
        break;
      default:
        break;
    }

    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Row(
        textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: msgType == MsgType.recall
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 目标名称
  String targetName() {
    OrgChatCache orgChatCache = controller.messageController.orgChatCache;
    return orgChatCache.nameMap[detail.fromId];
  }

  // 获取头像
  Widget _getAvatar() {
    TargetResp userInfo = auth.userInfo;
    return TextAvatar(
      avatarName: StringUtil.getAvatarName(
        avatarName: isMy ? userInfo.team?.name ?? "" : targetName(),
        type: TextAvatarType.chat,
      ),
      textStyle: text16WhiteBold,
      radius: 9999,
    );
  }

  /// 获取会话
  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (isMultiple && !isMy) {
      content.add(Container(
        margin: left10,
        child: Text(targetName(), style: text12),
      ));
    }

    TargetResp userInfo = auth.userInfo;

    Widget body;
    var textDirection =
        detail.fromId == userInfo.id ? TextDirection.rtl : TextDirection.ltr;
    switch (msgType) {
      case MsgType.text:
        body = _detail(
            textDirection: textDirection,
            body: Text(
              detail.msgBody ?? "",
              style: AFont.instance.size22Black3W500,
            ),
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 10.w,
              bottom: 10.w,
            ));
        break;
      case MsgType.image:
        body = _image(textDirection: textDirection);
        break;
      case MsgType.voice:
        body = _voice(textDirection: textDirection);
        break;
      default:
        body = Container();
    }

    // 添加长按手势
    double x = 0, y = 0;
    String spaceId = controller.spaceId;
    String sessionId = controller.messageItemId;
    var chat = GestureDetector(
      onPanDown: (position) {
        x = position.globalPosition.dx;
        y = position.globalPosition.dy;
      },
      onLongPress: () async {
        List<DetailFunc> items = [];
        if (isMy && detail.createTime != null) {
          var diff = detail.createTime!.difference(DateTime.now());
          if (diff.inSeconds.abs() < 2 * 60) {
            items.add(DetailFunc.recall);
          }
        }
        TargetResp userInfo = auth.userInfo;
        if (spaceId == userInfo.id) {
          items.add(DetailFunc.remove);
        }
        if (items.isEmpty) {
          return;
        }
        var top = y - 50;
        var right = MediaQuery.of(context).size.width - x;
        final result = await showMenu<DetailFunc>(
          context: context,
          position: RelativeRect.fromLTRB(x, top, right, 0),
          items: items.map((item) {
            return PopupMenuItem(
              value: item,
              child: Text(item.name),
            );
          }).toList(),
        );
        if (result != null) {
          controller.detailFuncCallback(result, spaceId, sessionId, detail);
        }
      },
      child: body,
    );
    content.add(chat);

    return Container(
      margin: isMy ? right2 : left2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }

  /// 会话详情
  Widget _detail({
    required TextDirection textDirection,
    required Widget body,
    BoxConstraints? constraints,
    Clip? clipBehavior,
    EdgeInsets? padding,
  }) {
    return Container(
      constraints: constraints ?? BoxConstraints(maxWidth: 350.w),
      padding: padding ?? EdgeInsets.all(defaultWidth),
      margin: textDirection == TextDirection.ltr
          ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
          : EdgeInsets.only(right: defaultWidth),
      decoration: BoxDecoration(
        color: isMy ? UnifiedColors.tinyLightBlue : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
        boxShadow: const [
          //阴影效果
          BoxShadow(
            offset: Offset(0, 2), //阴影在X轴和Y轴上的偏移
            color: Colors.black12, //阴影颜色
            blurRadius: 3.0, //阴影程度
            spreadRadius: 0, //阴影扩散的程度 取值可以正数,也可以是负数
          ),
        ],
      ),
      clipBehavior: clipBehavior ?? Clip.none,
      child: body,
    );
  }

  /// 图片详情
  Widget _image({required TextDirection textDirection}) {
    /// 解析参数
    Map<String, dynamic> msgBody = jsonDecode(detail.msgBody ?? "{}");
    String path = msgBody["path"];
    double width = double.parse(msgBody["width"].toString());
    double height = double.parse(msgBody["height"].toString());

    /// 限制大小
    late BoxConstraints boxConstraints;
    if (width > height) {
      boxConstraints = BoxConstraints(maxWidth: 120.w);
    } else {
      boxConstraints = BoxConstraints(maxHeight: 120.h);
    }

    path = EncryptionUtil.encodeURLString(path);
    String params =
        "shareDomain=${BucketApi.shareDomain}&prefix=$path&preview=True";
    String url = "${Constant.bucket}/Download?$params";

    Map<String, String> headers = {
      "Authorization": HiveUtil().accessToken,
    };
    return _detail(
      constraints: boxConstraints,
      textDirection: textDirection,
      body: CachedNetworkImage(imageUrl: url, httpHeaders: headers),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.zero,
    );
  }

  /// 语音详情
  Widget _voice({required TextDirection textDirection}) {
    // 解析参数
    Map<String, dynamic> msgMap = jsonDecode(detail.msgBody ?? "{}");
    String path = msgMap["path"] ?? "";
    int milliseconds = msgMap["milliseconds"] ?? 0;

    // 初始化语音输入
    controller.playStatusMap.putIfAbsent(
        detail.id,
        () => VoiceDetail(
              resp: detail,
              status: VoiceStatus.stop.obs,
              initProgress: milliseconds,
              progress: milliseconds.obs,
              path: path,
            ));

    return _detail(
      padding: EdgeInsets.all(6.w),
      textDirection: textDirection,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (detail.msgBody == null) {
                Fluttertoast.showToast(msg: "未获取到文件信息，无法播放！");
                return;
              }

              Map<String, dynamic> body = jsonDecode(detail.msgBody!);
              String path = body["path"];
              File cachedFile = await BucketApi.getCachedFile(path);

              // 播放文件
              var voicePlay = controller.playStatusMap[detail.id]!;
              var status = voicePlay.status;
              if (status.value == VoiceStatus.stop) {
                controller.startPlayVoice(detail.id, cachedFile);
              } else {
                controller.stopPrePlayVoice();
              }
            },
            child: Obx(() {
              var voicePlay = controller.playStatusMap[detail.id]!;
              var status = voicePlay.status;
              return status.value == VoiceStatus.stop
                  ? const Icon(Icons.play_arrow, color: Colors.black)
                  : const Icon(Icons.stop, color: Colors.black);
            }),
          ),
          Container(margin: EdgeInsets.only(left: 5.w)),
          Expanded(
            child: SizedBox(
              height: 12.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    var voicePlay = controller.playStatusMap[detail.id]!;
                    var status = voicePlay.status;
                    if (status.value == VoiceStatus.stop) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.circle, size: 12.h),
                      );
                    } else {
                      return AlignTransition(
                        alignment: controller.animation!,
                        child: Icon(Icons.circle, size: 12.h),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          Container(margin: EdgeInsets.only(left: 5.w)),
          Obx(() {
            var voicePlay = controller.playStatusMap[detail.id]!;
            var progress = voicePlay.progress;
            return Text(StringUtil.getMinusShow(progress.value ~/ 1000));
          })
        ],
      ),
    );
  }
}
