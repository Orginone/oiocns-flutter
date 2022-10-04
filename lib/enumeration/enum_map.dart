import 'message_type.dart';

class EnumMap {
  static Map<String, MsgType> messageTypeMap = MsgType.values.asNameMap();

  ///string转枚举类型
  static T? enumFromString<T>(Iterable<T> values, String value) {
    try {
      return values.firstWhere((type) => type.toString().split('.').last == value);
    } catch(e) {
      return null;
    }
  }
}
