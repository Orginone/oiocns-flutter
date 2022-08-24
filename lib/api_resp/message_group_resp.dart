import 'package:json_annotation/json_annotation.dart';

import '../model/db_model.dart';

part 'message_group_resp.g.dart';

@JsonSerializable()
class MessageGroupResp {
  int id;
  String name;
  List<dynamic> chats;

  MessageGroupResp(this.id, this.name, this.chats);

  MessageGroupResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        chats = map["chats"];

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
