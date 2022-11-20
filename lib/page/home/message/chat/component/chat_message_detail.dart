import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/bucket_api.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_edge_insets.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/api/chat_server.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/string_util.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除");

  const DetailFunc(this.label);

  final String label;
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
    bool isCenter = false;
    switch (msgType) {
      case MsgType.text:
      case MsgType.image:
      case MsgType.voice:
        children.add(_getAvatar());
        children.add(_getChat(context));
        break;
      case MsgType.pull:
        String msgBody = detail.msgBody ?? "{}";
        Map<String, dynamic> body = jsonDecode(msgBody);
        children.add(
          Container(
            alignment: Alignment.center,
            width: 400.w,
            child: Text(body["remark"], style: AFont.instance.size18Black9),
          ),
        );
        isCenter = true;
        break;
      case MsgType.createCohort:
      case MsgType.exitCohort:
      case MsgType.deleteCohort:
      case MsgType.updateCohortName:
        children.add(
          Container(
            alignment: Alignment.center,
            child: Text(
              detail.msgBody ?? "",
              style: AFont.instance.size18Black9,
            ),
          ),
        );
        isCenter = true;
        break;
      case MsgType.recall:
        var messageItem = controller.messageItem;
        var nameMap = controller.messageController.orgChatCache.nameMap;
        String msgBody = StringUtil.getDetailRecallBody(
          item: messageItem,
          detail: detail,
          nameMap: nameMap,
        );
        children.add(Text(msgBody, style: AFont.instance.size18Black9));
        isCenter = true;
        break;
      default:
        break;
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Row(
        textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment:
            isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 目标名称
  String targetName() {
    OrgChatCache orgChatCache = controller.messageController.orgChatCache;
    if (!orgChatCache.nameMap.containsKey(detail.fromId)) {
      chatServer.getName(detail.fromId).then((name) {
        orgChatCache.nameMap[detail.fromId] = name;
      });
    }
    return orgChatCache.nameMap[detail.fromId] ?? "";
  }

  /// 获取头像
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
        child: Text(targetName(), style: AFont.instance.size16Black3),
      ));
    }

    Widget body;
    var mySend = detail.fromId == auth.userId;
    var rtl = TextDirection.rtl;
    var ltr = TextDirection.ltr;
    var textDirection = mySend ? rtl : ltr;

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
        if (spaceId == auth.userId) {
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
              child: Text(item.label),
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
      boxConstraints = BoxConstraints(maxWidth: 200.w);
    } else {
      boxConstraints = BoxConstraints(maxHeight: 200.h);
    }

    path = EncryptionUtil.encodeURLString(path);
    String params =
        "shareDomain=${BucketApi.defaultShareDomain}&prefix=$path&preview=True";
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
    // 初始化语音输入
    controller.playStatusMap
        .putIfAbsent(detail.id, () => Detail(detail) as VoiceDetail);

    var voicePlay = controller.playStatusMap[detail.id]!;
    var seconds = voicePlay.initProgress ~/ 1000;
    seconds = seconds > 60 ? 60 : seconds;

    return _detail(
      textDirection: textDirection,
      body: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (voicePlay.bytes.isEmpty) {
                Fluttertoast.showToast(msg: "未获取到语音，播放失败！");
                return;
              }

              if (voicePlay.status.value == VoiceStatus.stop) {
                controller.startPlayVoice(detail.id, voicePlay.bytes);
              } else {
                controller.stopPrePlayVoice();
              }
            },
            child: Obx(() {
              var status = voicePlay.status;
              return status.value == VoiceStatus.stop
                  ? const Icon(Icons.play_arrow, color: Colors.black)
                  : const Icon(Icons.stop, color: Colors.black);
            }),
          ),
          Padding(padding: EdgeInsets.only(left: 5.w)),
          SizedBox(
            height: 12.h,
            width: 60.w + seconds * 2.w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: UnifiedColors.lineLight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.w),
                      ),
                    ),
                  ),
                ),
                Obx(() {
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
          Padding(padding: EdgeInsets.only(left: 10.w)),
          Obx(() {
            var progress = voicePlay.progress;
            return Text(
              StringUtil.getMinusShow(progress.value ~/ 1000),
              style: AFont.instance.size22Black3,
            );
          })
        ],
      ),
    );
  }
}
