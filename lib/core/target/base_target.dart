import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/target_type.dart';

int maxInt = 65536;

class BaseTarget {
  final Target target;

  const BaseTarget(this.target);

  Future<PageResp<Target>> getJoined({
    required String spaceId,
    required List<TargetType> joinTypeNames,
  }) async {
    var request = IDReqJoinedModel(
      id: target.id,
      typeName: [target.typeName],
      joinTypeNames: joinTypeNames.map((item) => item.label).toList(),
      spaceId: spaceId,
      page: PageRequest(
        offset: 0,
        limit: maxInt,
        filter: "",
      ),
    );
    return await kernelApi.queryJoinedTargetById(request);
  }

  Future<void> pull({
    required TargetType targetType,
    required List<String> targetIds,
  }) async {
    var teamPull = TeamPullModel(
      targetType: targetType.label,
      targetIds: targetIds,
      teamTypes: [target.typeName],
      id: target.id,
    );
    return await kernelApi.pullAnyToTeam(teamPull);
  }
}
