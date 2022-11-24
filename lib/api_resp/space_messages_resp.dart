import 'package:get/get.dart';

import 'message_target.dart';

class SpaceMessagesResp {
  final String id;
  final String name;
  final List<MessageTarget> chats;

  bool isExpand = false;

  SpaceMessagesResp(this.id, this.name, this.chats);

  SpaceMessagesResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        chats = MessageTarget.fromList(map["chats"]);

  static List<SpaceMessagesResp> fromList(List<dynamic> data) {
    List<SpaceMessagesResp> ans = [];
    for (var spaceMessagesMap in data) {
      var spaceMessagesResp = SpaceMessagesResp.fromMap(spaceMessagesMap);
      ans.add(spaceMessagesResp);
    }
    return ans;
  }

  static List<Map<String, dynamic>> toJsonList(List<SpaceMessagesResp>? data) {
    if (data == null) {
      return [];
    }
    List<Map<String, dynamic>> ans = [];
    for (var item in data) {
      ans.add(item.toJson());
    }
    return ans;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id.toString();
    json['name'] = name;
    json['chats'] = MessageTarget.toJsonList(chats);
    return json;
  }
}
