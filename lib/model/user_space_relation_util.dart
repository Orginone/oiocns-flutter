import 'package:orginone/api_resp/user_resp.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../api_resp/target_resp.dart';
import '../util/hive_util.dart';
import 'db_model.dart';

class UserSpaceRelationUtil {
  static Future<BoolResult> updateExpand(int id, bool isExpand) async {
    UserResp userResp = HiveUtil().getValue(Keys.user);
    String updateSQL =
        "UPDATE UserSpaceRelation SET isExpand = $isExpand WHERE account = ${userResp.account} AND targetId = $id";
    return await UserSpaceRelationManager().execSQL(updateSQL);
  }

  static Future<UserSpaceRelation?> getById(int id) async {
    UserResp userResp = HiveUtil().getValue(Keys.user);
    String updateSQL =
        "SELECT * FROM UserSpaceRelation WHERE account = ${userResp.account} AND targetId = $id";

    List<Map<String, Object?>> data = await UserSpaceRelationManager().execDataTable(updateSQL);
    if (data.isEmpty) return null;

    return UserSpaceRelation.fromMap(data[0]);
  }
}
