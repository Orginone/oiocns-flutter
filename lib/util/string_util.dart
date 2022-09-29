import 'package:html/parser.dart';

import '../component/text_avatar.dart';

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
}
