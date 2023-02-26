import 'package:orginone/dart/base/model.dart';

var targetMap = <String, TargetShare>{};

appendShare(String id, TargetShare share) {
  if (!targetMap.containsKey(id)) {
    targetMap[id] = share;
  }
}

TargetShare findTargetShare(String targetId) {
  TargetShare result = TargetShare(name: '奥集能平台', typeName: '平台');
  if (targetMap.containsKey(targetId)) {
    result = targetMap[targetId]!;
  }
  return result;
}
