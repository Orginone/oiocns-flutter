import 'package:get/get.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/chat/chat_impl.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';

class StringUtil {
  static String getPrefixChars(String target, {required int count}) {
    if (target.isEmpty) return target;
    return target
        .substring(0, target.length >= count ? count : 1)
        .toUpperCase();
  }

  static String getAvatarName({
    required String avatarName,
    required TextAvatarType type,
  }) {
    switch (type) {
      case TextAvatarType.space:
      case TextAvatarType.avatar:
        return StringUtil.getPrefixChars(avatarName, count: 1);
      case TextAvatarType.chat:
        return StringUtil.getPrefixChars(avatarName, count: 2);
    }
  }

  static String getDetailRecallBody({
    required MessageTarget item,
    required MessageDetail detail,
    required String name,
  }) {
    var userInfo = auth.userInfo;
    String msgBody = "撤回了一条消息";
    var targetType = EnumMap.targetTypeMap[item.typeName];
    if (userInfo.id == detail.fromId) {
      msgBody = "您$msgBody";
    } else if (targetType == TargetType.person) {
      msgBody = "对方$msgBody";
    } else {
      msgBody = "$name$msgBody";
    }
    return msgBody;
  }

  /// 分:秒显示
  static String getMinusShow(int seconds) {
    int minus = seconds ~/ 60;
    int remainder = seconds % 60;
    String prefix = "", suffix = "";
    if (minus < 10) {
      prefix = "0$minus";
    } else if (minus < 100) {
      prefix = "$minus";
    } else {
      prefix = "99";
    }
    if (remainder < 10) {
      suffix = "0$remainder";
    } else {
      suffix = "$remainder";
    }
    return "$prefix:$suffix";
  }

  static String getStrFirstUpperChar(String? str) {
    if (str == null || str.isEmpty) return "";
    if (str.length == 1) return str.toUpperCase();
    return str.substring(0, 1).toUpperCase();
  }

  static String formatStr(String? str) {
    if (str == null) return '';
    if (str.trim().isEmpty) return '';
    return str;
  }

  static String showTxt(IChat chat, MessageDetail? detail) {
    if (detail == null) {
      return "";
    }

    var type = EnumMap.messageTypeMap[detail.msgType] ?? MsgType.text;
    var messageCtrl = Get.find<MessageController>();

    var name = messageCtrl.getName(detail.fromId);
    var showTxt = "";
    if (chat is PersonChat) {
      if (detail.fromId != auth.userId) {
        showTxt = "对方：";
      }
    } else {
      showTxt = "$name:";
    }
    switch (type) {
      case MsgType.text:
        return "$showTxt${detail.showTxt}";
      case MsgType.recall:
        return "$showTxt撤回了一条消息";
      case MsgType.image:
        return "$showTxt[图片]";
      case MsgType.video:
        return "$showTxt[视频]";
      case MsgType.voice:
        return "$showTxt[语音]";
      case MsgType.file:
        return "$showTxt[文件]";
      case MsgType.pull:
        return detail.showTxt;
      case MsgType.read:
        return "";
    }
  }

  /// size 单位为字节
  static String formatFileSize(int size){
    return "${(size * 1.0 / 1024 / 1024).toStringAsFixed(1)}M";
  }
}
