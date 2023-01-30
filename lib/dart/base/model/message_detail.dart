class MessageDetail {
  String id;
  String? spaceId;
  String fromId;
  String toId;
  String msgType;
  String msgBody;
  String? createUser;
  String? updateUser;
  DateTime? createTime;
  DateTime? updateTime;
  String showTxt;
  bool allowEdit;

  MessageDetail({
    required this.id,
    required this.spaceId,
    required this.fromId,
    required this.toId,
    required this.msgType,
    required this.msgBody,
    this.createUser,
    this.updateUser,
    this.createTime,
    this.updateTime,
    required this.showTxt,
    required this.allowEdit,
  });

  MessageDetail.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        spaceId = map["spaceId"],
        fromId = map["fromId"],
        toId = map["toId"],
        msgType = map["msgType"],
        msgBody = map["msgBody"],
        createUser = map["createUser"],
        updateUser = map["updateUser"],
        createTime = map["createTime"] != null
            ? DateTime.parse(map["createTime"])
            : null,
        updateTime = map["updateTime"] != null
            ? DateTime.parse(map["updateTime"])
            : null,
        showTxt = map["showTxt"] ?? "",
        allowEdit = map["allowEdit"] ?? false;

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
    json["showTxt"] = showTxt;
    json["allowEdit"] = allowEdit;
    return json;
  }
}
