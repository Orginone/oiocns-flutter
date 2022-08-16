import 'message_item.dart';

class MessageItemUtil {
  static Future<int> count(String account, int messageItemId) async {
    return await MessageItem()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(account)
        .and
        .id
        .equals(messageItemId)
        .page(1, 1)
        .toCount();
  }

  static Future<List<MessageItem>> getAllItems(String account) async {
    return await MessageItem().select().account.equals(account).toList();
  }
}
