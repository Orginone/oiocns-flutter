import 'message_target.dart';

class ChatGroup {
  final String id;
  final String name;
  final List<MessageTarget> chats;

  bool isExpand = false;

  ChatGroup(this.id, this.name, this.chats);

  ChatGroup.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        chats = MessageTarget.fromList(map["chats"]);

  static List<ChatGroup> fromList(List<dynamic> data) {
    List<ChatGroup> ans = [];
    for (var spaceMessagesMap in data) {
      var spaceMessagesResp = ChatGroup.fromMap(spaceMessagesMap);
      ans.add(spaceMessagesResp);
    }
    return ans;
  }

  static List<Map<String, dynamic>> toJsonList(List<ChatGroup>? data) {
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
