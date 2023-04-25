import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';

var targetMap = <String, TargetShare>{};

appendTarget(List<XTarget> targets) {
  if (targets.isEmpty) {
    return;
  }
  for (var value in targets) {
    if (!targetMap.containsKey(value.id)) {
      targetMap[value.id] = TargetShare(
        name: value.team?.name ?? "",
        typeName: value.typeName,
      );
    }
  }
}

appendShare(String id, TargetShare share) {
  if (!targetMap.containsKey(id)) {
    targetMap[id] = share;
  }
}

TargetShare findTargetShare(String targetId) {
  if (!targetMap.containsKey(targetId)) {
    kernelApi.queryTargetById(IdArrayReq(ids: [targetId])).then((res) {
      if (res.success) {
        appendTarget(res.data?.result ?? []);
      }
    });
  }
  if (targetMap.containsKey(targetId)) {
    return targetMap[targetId]!;
  }
  return TargetShare(
    name: '奥集能平台',
    typeName: '平台',
    avatar: orginoneAvatar(),
  );
}
