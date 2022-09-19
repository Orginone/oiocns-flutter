import 'package:orginone/util/date_util.dart';

class MessageDetailResp {
  String id;
  String spaceId;
  String fromId;
  String toId;
  String msgType;
  String? msgBody;
  String createUser;
  String updateUser;
  DateTime createTime;
  DateTime updateTime;

  MessageDetailResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        spaceId = map["spaceId"],
        fromId = map["fromId"],
        toId = map["toId"],
        msgType = map["msgType"],
        msgBody = map["msgBody"],
        createUser = map["createUser"],
        updateUser = map["updateUser"],
        createTime = CustomDateUtil.parse(map["createTime"]),
        updateTime = CustomDateUtil.parse(map["updateTime"]);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['spaceId'] = spaceId;
    json["fromId"] = fromId;
    json["toId"] = toId;
    json["msgType"] = msgType;
    if (msgBody != null) {
      json["msgBody"] = msgBody;
    }
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["createTime"] = createTime.toString();
    json["updateTime"] = updateTime.toString();
    return json;
  }
}
