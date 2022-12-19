import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';

import 'message_target.dart';

class OrgChatCache {
  String? key;
  String? name;
  DateTime? updateTime;
  List<ChatGroup> chats;
  Map<String, dynamic> nameMap;
  List<MessageTarget> openChats;
  MessageTarget? target;
  MessageDetail? messageDetail;
  List<MessageTarget>? recentChats;

  OrgChatCache.empty()
      : chats = [],
        nameMap = {},
        openChats = [];

  factory OrgChatCache(Map<String, dynamic> map) {
    if (map["UpdateTime"] != null) {
      map["UpdateTime"] = DateTime.parse(map["UpdateTime"]);
    }
    if (map["chats"] != null) {
      map["chats"] = ChatGroup.fromList(map["chats"]);
    }
    if (map["recentChats"] != null) {
      map["recentChats"] = MessageTarget.fromList(map["recentChats"]);
    }
    if (map["openChats"] != null) {
      map["openChats"] = MessageTarget.fromList(map["openChats"]);
    }
    if (map["lastMsg"] != null) {
      Map<String, dynamic> lastMsg = map["lastMsg"];
      if (lastMsg["chat"] != null) {
        map["target"] = MessageTarget.fromMap(lastMsg["chat"]);
      }
      if (lastMsg["data"] != null) {
        map["messageDetail"] = MessageDetail.fromMap(lastMsg["data"]);
      }
    }
    return OrgChatCache._fromMap(map);
  }

  OrgChatCache._fromMap(Map<String, dynamic> map)
      : key = map["Key"],
        name = map["Name"],
        updateTime = map["UpdateTime"],
        chats = map["chats"],
        recentChats = map["recentChats"],
        openChats = map["openChats"],
        nameMap = map["nameMap"],
        target = map["target"],
        messageDetail = map["messageDetail"];
}
