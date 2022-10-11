import 'package:html/parser.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/util/hive_util.dart';

import '../api_resp/message_item_resp.dart';
import '../component/text_avatar.dart';
import '../enumeration/target_type.dart';

class StringUtil {
  static String getPrefixChars(String target, {required int count}) {
    if (target.isEmpty) return target;
    return target
        .substring(0, target.length >= count ? count : 1)
        .toUpperCase();
  }

  static String removeHtml(String? target) {
    if (target == null) {
      return "";
    }
    var document = parse(target);
    return parse(document.body?.text).documentElement?.text ?? "";
  }

  static String getAvatarName({
    required String avatarName,
    required TextAvatarType type,
  }) {
    switch (type) {
      case TextAvatarType.space:
        return StringUtil.getPrefixChars(avatarName, count: 1);
      case TextAvatarType.chat:
        return StringUtil.getPrefixChars(avatarName, count: 2);
      case TextAvatarType.avatar:
        return StringUtil.getPrefixChars(avatarName, count: 1);
    }
  }

  static String getDetailRecallBody(
    MessageItemResp item,
    MessageDetailResp detail,
    Map<String, dynamic> nameMap,
  ) {
    var userInfo = HiveUtil().getValue(Keys.userInfo);
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
    var userInfo = HiveUtil().getValue(Keys.userInfo);
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
}
