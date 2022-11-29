import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/target_type.dart';

int maxInt = 65536;

class BaseTarget {
  final Target target;

  const BaseTarget(this.target);

  /// 获取加入的组织
  Future<PageResp<Target>> getJoined({
    required String spaceId,
    required List<TargetType> joinTypeNames,
  }) async {
    var request = IDReqJoinedModel(
      id: target.id,
      typeName: target.typeName,
      joinTypeNames: joinTypeNames.map((item) => item.label).toList(),
      spaceId: spaceId,
      page: PageRequest(
        offset: 0,
        limit: maxInt,
        filter: "",
      ),
    );
    return await Kernel.getInstance.queryJoinedTargetById(request);
  }

  /// 把组织/个人拉入
  Future<void> pull({
    required TargetType targetType,
    required List<String> targetIds,
  }) async {
    var teamPull = TeamPullModel(
      id: target.id,
      teamTypes: [target.typeName],
      targetType: targetType.label,
      targetIds: targetIds,
    );
    return await Kernel.getInstance.pullAnyToTeam(teamPull);
  }

  /// 移除组织/个人
  Future<void> remove({
    required String targetType,
    required List<String> targetIds,
  }) async {
    var teamPull = TeamPullModel(
      targetType: targetType,
      targetIds: targetIds,
      teamTypes: [target.typeName],
      id: target.id,
    );
    return await Kernel.getInstance.removeAnyOfTeam(teamPull);
  }

  /// 主动退出组织/个人
  Future<void> exit({
    required String targetType,
    required String targetId,
  }) async {
    var teamPull = ExitTeamModel(
      teamTypes: [targetType],
      id: targetId,
      targetType: target.typeName,
      targetId: target.id,
    );
    return await Kernel.getInstance.exitAnyOfTeam(teamPull);
  }
}
