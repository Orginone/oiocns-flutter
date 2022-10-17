import 'package:orginone/util/date_util.dart';

class MessageDetailResp {
  String id;
  String? spaceId;
  String fromId;
  String toId;
  String msgType;
  String? msgBody;
  String? createUser;
  String? updateUser;
  DateTime? createTime;
  DateTime? updateTime;

  MessageDetailResp({
    required this.id,
    required this.spaceId,
    required this.fromId,
    required this.toId,
    required this.msgType,
    this.msgBody,
    this.createUser,
    this.updateUser,
    this.createTime,
    this.updateTime,
  });

  MessageDetailResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        spaceId = map["spaceId"],
        fromId = map["fromId"],
        toId = map["toId"],
        msgType = map["msgType"],
        msgBody = map["msgBody"],
        createUser = map["createUser"],
        updateUser = map["updateUser"],
        createTime = map["createTime"] != null
            ? CustomDateUtil.parse(map["createTime"])
            : null,
        updateTime = map["updateTime"] != null
            ? CustomDateUtil.parse(map["updateTime"])
            : null;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['spaceId'] = spaceId;
    json["fromId"] = fromId;
    json["toId"] = toId;
    json["msgType"] = msgType;
    json["msgBody"] = msgBody;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["createTime"] = createTime?.toString();
    json["updateTime"] = updateTime?.toString();
    return json;
  }
}
