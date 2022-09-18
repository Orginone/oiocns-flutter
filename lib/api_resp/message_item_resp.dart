import '../util/date_util.dart';

class MessageItemResp {
  int id;
  String name;
  String label;
  String remark;
  String typeName;
  DateTime msgTime;
  int? spaceId;
  int? noRead;
  int? personNum;
  String? msgBody;

  MessageItemResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        label = map["label"],
        remark = map["remark"],
        typeName = map["typeName"],
        msgTime = CustomDateUtil.parse(map["msgTime"]),
        spaceId = map["spaceId"] != null ? int.parse(map["spaceId"]) : null,
        noRead = map["noRead"],
        personNum = map["personNum"],
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
