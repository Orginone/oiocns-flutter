import 'package:orginone/dart/core/enum.dart';

class EnumMap {
  static var messageMap = mapping(MessageType.values, (e) => e.label);

  static Map<String, E> mapping<E>(List<E> enums, Function(E) keyGetter) {
    var map = <String, E>{};
    for (var value in enums) {
      var name = keyGetter(value);
      map[name] = value;
    }
    return map;
  }
}

enum LoadStatusX {
  loading,
  error,
  success,
  empty,
}

enum FormStatus {
  view,
  create,
  update,
}
