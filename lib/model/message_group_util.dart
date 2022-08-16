import 'message_group.dart';

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
}
