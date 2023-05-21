class StringUtil {
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
}
