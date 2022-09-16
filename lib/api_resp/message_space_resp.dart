import '../model/db_model.dart';
import 'message_item_resp.dart';

class SpaceMessagesResp {
  int id;
  String name;
  List<MessageItemResp> chats;
  bool isExpand;

  SpaceMessagesResp(this.id, this.name, this.chats, {this.isExpand = false});

  SpaceMessagesResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        chats = MessageItemResp.fromList(map["chats"]),
        isExpand = false;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['chats'] = chats;
    return json;
  }

  Target toTarget() {
    var target = Target();
    target.id = id;
    target.name = name;
    return target;
  }
}
