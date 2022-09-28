import 'message_type.dart';

class EnumMap {
  static Map<String, MessageType> messageTypeMap = typeMapFunc(MessageType.values);

  static Map<String, E> typeMapFunc<E>(List<E> enumerations) {
    var map = <String, E>{};
    for (var value in enumerations) {
      var name = value.toString();
      map[name] = value;
    }
    return map;
  }

  ///string转枚举类型
  static T? enumFromString<T>(Iterable<T> values, String value) {
    try {
      return values.firstWhere((type) => type.toString().split('.').last == value);
    } catch(e) {
      return null;
    }
  }
}
