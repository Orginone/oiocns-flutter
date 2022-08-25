import 'package:orginone/util/hive_util.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../api_resp/user_resp.dart';
import 'db_model.dart';

class MessageDetailUtil {
  static UserResp userResp = HiveUtil().getValue(Keys.user);

  // 获取最新一条信息
  static Future<MessageDetail?> latestDetail(
      int spaceId, int messageItemId) async {
    return await MessageDetail()
        .select(columnsToSelect: ["msgBody", "createTime"])
        .account
        .equals(userResp.account)
        .and
        .spaceId
        .equals(spaceId)
        .and
        .toId
        .equals(messageItemId)
        .orderByDesc("seqId")
        .page(1, 1)
        .toSingle();
  }

  // 获取没有阅读的信息的个数
  static Future<int> notReadMessageCount(int messageItemId) async {
    return await MessageDetail()
        .select(columnsToSelect: ["COUNT(id)"])
        .account
        .equals(userResp.account)
        .and
        .toId
        .equals(messageItemId)
        .and
        .isRead
        .equals(false)
        .toCount();
  }

  // 阅读所有消息
  static Future<BoolResult> messageItemRead(int messageItemId) async {
    String updateSql =
        "UPDATE MessageDetail SET isRead = 1 WHERE toId =$messageItemId AND account = ${userResp.account}";
    return await MessageDetailManager().execSQL(updateSql);
  }

  // 获取一个聊天的所有消息
  static Future<int> getTotalCount(
      int spaceId, int messageItemId, String typeName) async {
    String countSQL = "SELECT COUNT(id) number FROM MessageDetail WHERE "
        "spaceId = $spaceId AND "
        "(fromId = $messageItemId OR toId = $messageItemId) AND "
        "account = ${userResp.account} AND "
        "typeName = '$typeName'";
    var res = await MessageDetailManager().execDataTable(countSQL);
    return int.tryParse(res[0]["number"]!.toString())!;
  }

  // 获取一个聊天的所有消息
  static Future<List<Map<String, dynamic>>> pageData(int offset, int limit,
      int spaceId, int messageItemId, String typeName) async {
    String querySQL = "SELECT * FROM messageDetail WHERE "
        "spaceId = $spaceId AND "
        "(fromId = $messageItemId OR toId = $messageItemId) AND "
        "account = ${userResp.account} AND "
        "typeName = '$typeName'"
        "LIMIT $limit OFFSET $offset";

    return await MessageDetailManager().execDataTable(querySQL);
  }

  // 获取一个聊天的所有消息
  static Future<List<Map<String, dynamic>>> myPageData(int offset, int limit,
      int spaceId, int messageItemId, String typeName) async {
    String querySQL = "SELECT * FROM messageDetail WHERE "
        "spaceId = $spaceId AND "
        "(fromId = $messageItemId AND toId = $messageItemId) AND "
        "account = ${userResp.account} AND "
        "typeName = '$typeName'"
        "LIMIT $limit OFFSET $offset";

    return await MessageDetailManager().execDataTable(querySQL);
  }

  // 获取一个聊天的所有消息
  static Future<MessageDetail?> getById(int id) async {
    return await MessageDetail()
        .select()
        .account
        .equals(userResp.account)
        .and
        .id
        .equals(id)
        .toSingle();
  }
}
