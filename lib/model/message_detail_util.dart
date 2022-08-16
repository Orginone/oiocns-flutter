import 'db_model.dart';
import 'message_detail.dart';

class MessageDetailUtil {
  // 获取最新一条信息
  static Future<MessageDetail?> latestDetail(
      String account, int messageItemId) async {
    return await MessageDetail()
        .select(columnsToSelect: ["msgBody", "createTime"])
        .toId
        .equals(messageItemId)
        .orderByDesc("seqId")
        .page(1, 1)
        .toSingle();
  }

  // 获取没有阅读的信息的个数
  static Future<int> notReadMessageCount(
      String account, int messageItemId) async {
    return await MessageDetail()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(account)
        .and
        .fromId
        .equals(messageItemId)
        .and
        .isRead
        .equals(false)
        .toCount();
  }
}
