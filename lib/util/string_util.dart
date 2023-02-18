import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/index.dart';
import 'package:orginone/dart/core/chat/chat.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/chat/message_page.dart';

class StringUtil {
  static String getDetailRecallBody({
    required ChatModel item,
    required String fromId,
    required String name,
    required String userId,
  }) {
    String msgBody = "撤回了一条消息";
    if (userId == fromId) {
      msgBody = "您$msgBody";
    } else if (item.typeName == TargetType.person.label) {
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

  static String showTxt({
    required IChat chat,
    required String msgType,
    required String fromId,
    required String showTxt,
    required String name,
    required String userId,
  }) {
    var prefix = "";
    if (chat is PersonChat) {
      if (fromId != userId) {
        prefix = "对方：";
      }
    } else {
      prefix = "$name:";
    }
    if (msgType == MessageType.text.label) {
      return "$prefix$showTxt";
    } else if (msgType == MessageType.recall.label) {
      return "$showTxt撤回了一条消息";
    } else if (msgType == MessageType.image.label) {
      return "$prefix[图片]";
    } else if (msgType == MessageType.video.label) {
      return "$prefix[视频]";
    } else if (msgType == MessageType.voice.label) {
      return "$prefix[语音]";
    }
    return "";
  }

  /// size 单位为字节
  static String formatFileSize(int size) {
    return "${(size * 1.0 / 1024 / 1024).toStringAsFixed(1)}M";
  }
}
