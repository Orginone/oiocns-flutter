class ValidUtil {
  static String? isEmpty(String fieldName, String? value) {
    if (value?.isEmpty ?? true) {
      return "$fieldName不能为空";
    }
    return null;
  }
}
