import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/util/date_util.dart';

import '../model/db_model.dart';
import 'message_item_resp.dart';

class OrgChatCache {
  String? key;
  String? name;
  DateTime? updateTime;
  List<SpaceMessagesResp>? chats;
  Map<int, String>? nameMap;
  MessageItemResp? target;
  MessageDetail? messageDetail;

  static MapEntry<int, String> _entry(String idStr, dynamic nameStr) {
    return MapEntry(int.parse(idStr), nameStr);
  }

  factory OrgChatCache(Map<String, dynamic> map) {
    if (map["UpdateTime"] != null) {
      map["UpdateTime"] = CustomDateUtil.parse(map["UpdateTime"]);
    }
    if (map["chats"] != null) {
      map["chats"] = SpaceMessagesResp.fromList(map["chats"]);
    }
    if (map["nameMap"] != null) {
      Map<String, dynamic> nameMap = map["nameMap"];
      map["nameMap"] = nameMap.map(_entry);
    }
    if (map["lastMsg"] != null) {
      Map<String, dynamic> lastMsg = map["lastMsg"];
      if (lastMsg["chat"] != null) {
        map["target"] = MessageItemResp.fromMap(lastMsg["chat"]);
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
        nameMap = map["nameMap"],
        target = map["target"],
        messageDetail = map["messageDetail"];
}
