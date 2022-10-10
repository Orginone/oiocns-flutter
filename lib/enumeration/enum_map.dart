import 'package:orginone/enumeration/target_type.dart';

import 'message_type.dart';

class EnumMap {
  static Map<String, MsgType> messageTypeMap = MsgType.values.asNameMap();
  static Map<String, TargetType> targetTypeMap = typeMapFunc(
    TargetType.values,
    TargetType.getName,
  );

  ///string转枚举类型
  static T? enumFromString<T>(Iterable<T> values, String value) {
    try {
      return values
          .firstWhere((type) => type.toString().split('.').last == value);
    } catch (e) {
      return null;
    }
  }

  static Map<String, E> typeMapFunc<E>(List<E> enums, Function keyGetter) {
    var map = <String, E>{};
    for (var value in enums) {
      var name = keyGetter(value);
      map[name] = value;
    }
    return map;
  }
}
