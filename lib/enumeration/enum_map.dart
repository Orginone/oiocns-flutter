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
}
