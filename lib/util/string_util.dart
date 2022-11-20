import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/enumeration/enum_map.dart';

import '../api_resp/message_item_resp.dart';
import '../component/text_avatar.dart';
import '../enumeration/target_type.dart';
import '../logic/authority.dart';

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
    required MessageItemResp item,
    required MessageDetailResp detail,
    required Map<String, dynamic> nameMap,
  }) {
    var userInfo = auth.userInfo;
    String msgBody = "撤回了一条消息";
    var targetType = EnumMap.targetTypeMap[item.typeName];
    if (userInfo.id == detail.fromId) {
      msgBody = "您$msgBody";
    } else if (targetType == TargetType.person) {
      msgBody = "对方$msgBody";
    } else {
      String name = nameMap[detail.fromId];
      msgBody = "$name$msgBody";
    }
    return msgBody;
  }

  static String getRecallBody(MessageItemResp item, MessageDetailResp detail) {
    var userInfo = auth.userInfo;
    String msgBody = "撤回了一条消息";
    var targetType = EnumMap.targetTypeMap[item.typeName];
    if (targetType == TargetType.person) {
      if (userInfo.id == detail.fromId) {
        msgBody = "您$msgBody";
      } else {
        msgBody = "对方$msgBody";
      }
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
}
