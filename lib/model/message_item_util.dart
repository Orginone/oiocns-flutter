import 'package:orginone/util/hive_util.dart';

import '../api_resp/user_resp.dart';
import 'db_model.dart';

class MessageItemUtil {
  static UserResp userResp = HiveUtil().getValue(Keys.user);

  static Future<int> count(int messageItemId, String label) async {
    return await MessageItem()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(userResp.account)
        .and
        .id
        .equals(messageItemId)
        .and
        .label
        .equals(label)
        .page(1, 1)
        .toCount();
  }

  static Future<List<MessageItem>> getAllItems(String account) async {
    return await MessageItem().select().account.equals(account).toList();
  }
}
