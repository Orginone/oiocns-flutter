class StringUtil {
  static String getPrefixChars(String target, {required int count}) {
    if (target.isEmpty) return target;
    return target
        .substring(0, target.length >= count ? count : 1)
        .toUpperCase();
  }
}
