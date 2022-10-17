import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/util/date_util.dart';

import 'message_item_resp.dart';

class OrgChatCache {
  String? key;
  String? name;
  DateTime? updateTime;
  List<SpaceMessagesResp> chats;
  Map<String, dynamic> nameMap;
  List<MessageItemResp> openChats;
  MessageItemResp? target;
  MessageDetailResp? messageDetail;

  OrgChatCache.empty()
      : chats = [],
        nameMap = {},
        openChats = [];

  factory OrgChatCache(Map<String, dynamic> map) {
    if (map["UpdateTime"] != null) {
      map["UpdateTime"] = DateTime.parse(map["UpdateTime"]);
    }
    if (map["chats"] != null) {
      map["chats"] = SpaceMessagesResp.fromList(map["chats"]);
    }
    if (map["openChats"] != null) {
      map["openChats"] = MessageItemResp.fromList(map["openChats"]);
    }
    if (map["lastMsg"] != null) {
      Map<String, dynamic> lastMsg = map["lastMsg"];
      if (lastMsg["chat"] != null) {
        map["target"] = MessageItemResp.fromMap(lastMsg["chat"]);
      }
      if (lastMsg["data"] != null) {
        map["messageDetail"] = MessageDetailResp.fromMap(lastMsg["data"]);
      }
    }
    return OrgChatCache._fromMap(map);
  }

  OrgChatCache._fromMap(Map<String, dynamic> map)
      : key = map["Key"],
        name = map["Name"],
        updateTime = map["UpdateTime"],
        chats = map["chats"],
        openChats = map["openChats"],
        nameMap = map["nameMap"],
        target = map["target"],
        messageDetail = map["messageDetail"];
}
