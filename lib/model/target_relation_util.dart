import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/util/hive_util.dart';

import '../api_resp/user_resp.dart';
import 'db_model.dart';

class TargetRelationUtil {
  static Future<List<TargetRelation>> getSpaces() async {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    return TargetRelation()
        .select()
        .activeTargetId
        .equals(userInfo.id)
        .toList();
  }

  static Future<List<TargetRelation>> getAllItems() async {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    String querySQL = "SELECT target.* FROM TargetRelation space "
        "LEFT JOIN TargetRelation target ON space.passiveTargetId = target.activeTargetId "
        " WHERE space.activeTargetId = ${userInfo.id} ORDER BY target.priority DESC";
    return TargetRelation.fromMapList(
        await TargetRelationManager().execDataTable(querySQL));
  }

  static Future<TargetRelation?> getItem(String spaceId, String itemId) async {
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
