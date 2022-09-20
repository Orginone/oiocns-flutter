import '../util/date_util.dart';

class MessageItemResp {
  String id;
  String label;
  String name;
  String remark;
  String typeName;
  DateTime? msgTime;
  String? msgType;
  String? msgBody;
  String? spaceId;
  int? noRead;
  int? personNum;
  String? showText;

  MessageItemResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        label = map["label"],
        name = map["name"],
        remark = map["remark"],
        typeName = map["typeName"],
        msgTime = CustomDateUtil.parse(map["msgTime"]),
        msgType = map["msgType"],
        msgBody = map["msgBody"],
        spaceId = map["spaceId"],
        noRead = map["noRead"],
        personNum = map["personNum"],
        showText = map["showText"];

  static List<MessageItemResp> fromList(List<dynamic>? data) {
    if (data == null) {
      return [];
    }
    List<MessageItemResp> ans = [];
    for (dynamic item in data) {
      MessageItemResp chatResp = MessageItemResp.fromMap(item);
      ans.add(chatResp);
    }
    return ans;
  }

  static List<Map<String, dynamic>>? toJsonList(List<MessageItemResp>? data) {
    if (data == null) {
      return null;
    }
    List<Map<String, dynamic>> ans = [];
    for (var item in data) {
      ans.add(item.toJson());
    }
    return ans;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['label'] = label;
    json['name'] = name;
    json['remark'] = remark;
    json['typeName'] = typeName;
    json['msgTime'] = msgTime?.toString();
    json['msgType'] = msgType;
    json['msgBody'] = msgBody;
    json["spaceId"] = spaceId;
    json["noRead"] = noRead;
    json["personNum"] = personNum;
    json["showText"] = showText;
    return json;
  }
}
