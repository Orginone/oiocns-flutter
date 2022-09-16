import 'package:common_utils/common_utils.dart';

class MessageItemResp {
  int id;
  String name;
  String label;
  String? remark;
  String typeName;
  DateTime? msgTime;
  int? spaceId;
  int noRead;
  int? personNum;
  String? msgBody;

  MessageItemResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        label = map["label"],
        remark = map["remark"],
        typeName = map["typeName"],
        msgTime = map.containsKey("msgTime")
            ? DateTime.tryParse(map["msgTime"])
            : null,
        spaceId =
            map.containsKey("spaceId") ? int.tryParse(map["spaceId"]) : null,
        noRead =
            map.containsKey("noRead") ? int.tryParse(map["noRead"]) ?? 0 : 0,
        personNum = map.containsKey("personNum")
            ? int.tryParse(map["personNum"]) ?? 0
            : 0,
        msgBody = map["msgBody"];

  static List<MessageItemResp> fromList(List<dynamic> data) {
    List<MessageItemResp> ans = [];
    for (dynamic item in data) {
      MessageItemResp chatResp = MessageItemResp.fromMap(item);
      ans.add(chatResp);
    }
    return ans;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    return json;
  }
}
