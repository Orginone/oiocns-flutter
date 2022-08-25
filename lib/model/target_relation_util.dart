import 'package:orginone/util/hive_util.dart';

import '../api_resp/user_resp.dart';
import 'db_model.dart';

class TargetRelationUtil {
  static Future<List<TargetRelation>> getAllItems() async {
    UserResp userResp = HiveUtil().getValue(Keys.user);
    String querySQL =
        "SELECT TargetRelation.* FROM UserSpaceRelation LEFT JOIN TargetRelation ON UserSpaceRelation.targetId = "
        "TargetRelation.activeTargetId WHERE UserSpaceRelation.account = ${userResp.account} ORDER BY TargetRelation.priority";
    return TargetRelation.fromMapList(
        await TargetRelationManager().execDataTable(querySQL));
  }

  static Future<TargetRelation?> getItem(int spaceId, int itemId) async {
    return await TargetRelation()
        .select()
        .activeTargetId
        .equals(spaceId)
        .and
        .passiveTargetId
        .equals(itemId)
        .toSingle();
  }
}
