import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'db_model.dart';

class MessageGroupUtil {
  static Future<int> count(String account, int groupId) async {
    return await MessageGroup()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(account)
        .and
        .id
        .equals(groupId)
        .page(1, 1)
        .toCount();
  }

  static Future<BoolResult> updateExpand(
      String account, int id, bool ixExpand) async {
    String updateSQL =
        "UPDATE MessageGroup SET isExpand = ${ixExpand.toString()} WHERE account = $account AND id = $id}";
    return await MessageGroupManager().execSQL(updateSQL);
  }

  static Future<List<MessageGroup>> getAllGroup(String account) async {
    return await MessageGroup().select().account.equals(account).toList();
  }
}
