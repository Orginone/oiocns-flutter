import 'dart:convert';

import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/public/enums.dart';

class StringUtil {
  static RegExp imgReg = RegExp(r'\$IMG\[(.*?)\]');

  static RegExp urlReg = RegExp(r'(?:https?:\/\/|www\.)[^\s]+');
  static String getDetailRecallBody({
    required String fromId,
    required String name,
    required String userId,
  }) {
    String msgBody = "撤回了一条消息";
    if (userId == fromId) {
      msgBody = "您$msgBody";
    } else {
      msgBody = "$name$msgBody";
    }
    return msgBody;
  }

  static String imgLabelMsgConversion(String text) {
    String newText = text.replaceAllMapped(RegExp(r'\$IMG\[(.*?)\]'), (match) {
      return '[图片]';
    });
    return newText;
  }

  static String msgConversion(IMessage msg, String currentUserId) {
    String showTxt = '';
    var messageType = msg.msgType;
    if (messageType == MessageType.text.label) {
      var userIds = msg.mentions ?? [];
      if (userIds.isNotEmpty && userIds.contains(currentUserId)) {
        showTxt = "有人@你";
      } else {
        showTxt = "$showTxt${msg.msgBody ?? ""}";
        showTxt = StringUtil.imgLabelMsgConversion(showTxt);
      }
    } else if (messageType == MessageType.recall.label) {
      showTxt = "$showTxt撤回了一条消息";
    } else if (messageType == MessageType.image.label) {
      showTxt = "$showTxt[图片]";
    } else if (messageType == MessageType.video.label) {
      showTxt = "$showTxt[视频]";
    } else if (messageType == MessageType.voice.label) {
      showTxt = "$showTxt[语音]";
    } else if (messageType == MessageType.file.label) {
      showTxt = "$showTxt[文件]";
    }

    return showTxt;
  }

  static dynamic getImageUrl(String text) {
    dynamic imageUrl;
    if (imgReg.hasMatch(text)) {
      dynamic imageUrl = imgReg.allMatches(text).first.group(1)!;
      if (imageUrl.contains('base64')) {
        imageUrl = imageUrl.split("/").last;
        imageUrl = base64Decode(imageUrl);
      } else {
        imageUrl = "${Constant.host}/$imageUrl";
      }
    }
    return imageUrl;
  }

  static String replaceAllImageLabel(String text) {
    String newText = text.replaceAllMapped(imgReg, (match) {
      if (match.group(0)?.contains('http') ?? false) {
        String url = match.group(1)!;
        String domainRemoved =
            url.replaceAll(RegExp(r"https?:\/\/[^\/]+\/"), "");
        return "\$IMG[$domainRemoved]";
      }
      return match.group(0) ?? "";
    });
    return newText;
  }

  static String resetImageLabel(String text) {
    String newText = text.replaceAllMapped(imgReg, (match) {
      if (match.group(0)?.contains('base64') ?? false) {
        return match.group(0) ?? "";
      }
      return "\$IMG[${Constant.host}/${match.group(1)}]";
    });
    return newText;
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

  /// size 单位为字节
  static String formatFileSize(int size) {
    return "${(size * 1.0 / 1024 / 1024).toStringAsFixed(1)}M";
  }

  /// 判断文本是否为json字符串
  static bool isJson(String str) {
    bool isJsonStr = false;

    try {
      jsonDecode(str);
      isJsonStr = true;
    } catch (e) {}
    return isJsonStr;
  }
}
