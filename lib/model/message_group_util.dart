import 'package:orginone/util/hive_util.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../api_resp/user_resp.dart';
import 'db_model.dart';

class MessageGroupUtil {
  static UserResp userResp = HiveUtil().getValue(Keys.user);

  static Future<int> count(int groupId) async {
    return await MessageGroup()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(userResp.account)
        .and
        .id
        .equals(groupId)
        .page(1, 1)
        .toCount();
  }

  static Future<BoolResult> updateExpand(int id, bool isExpand) async {
    String updateSQL =
        "UPDATE MessageGroup SET isExpand = $isExpand WHERE account = ${userResp.account} AND id = $id";
    return await MessageGroupManager().execSQL(updateSQL);
  }

  static Future<MessageGroup?> getGroupById(int id) async {
    return await MessageGroup()
        .select()
        .account
        .equals(userResp.account)
        .and
        .id
        .equals(id)
        .toSingle();
  }

  static Future<List<MessageGroup>> getAllGroup() async {
    return await MessageGroup()
        .select()
        .account
        .equals(userResp.account)
        .toList();
  }
}
