class MessageTarget {
  String id;
  String label;
  String? photo;
  String name;
  String? remark;
  String typeName;
  DateTime? msgTime;
  String? msgType;
  String? msgBody;
  String? spaceId;
  int? noRead;
  int? personNum;
  String? showTxt;
  bool? isTop;
  bool? isInterruption;

  MessageTarget.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        label = map["label"],
        photo = map["photo"],
        name = map["name"],
        remark = map["remark"],
        typeName = map["typeName"],
        msgTime = DateTime.parse(map["msgTime"]),
        msgType = map["msgType"],
        msgBody = map["msgBody"],
        spaceId = map["spaceId"],
        noRead = map["noRead"],
        personNum = map["personNum"],
        showTxt = map["showTxt"],
        isTop = map["isTop"],
        isInterruption = map["isInterruption"];

  static List<MessageTarget> fromList(List<dynamic>? data) {
    if (data == null) {
      return [];
    }
    List<MessageTarget> ans = [];
    for (Map<String, dynamic> item in data) {
      MessageTarget chatResp = MessageTarget.fromMap(item);
      ans.add(chatResp);
    }
    return ans;
  }

  static List<Map<String, dynamic>>? toJsonList(List<MessageTarget>? data) {
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
    json['photo'] = photo;
    json['name'] = name;
    json['remark'] = remark;
    json['typeName'] = typeName;
    json['msgTime'] = msgTime?.toString();
    json['msgType'] = msgType;
    json['msgBody'] = msgBody;
    json["spaceId"] = spaceId;
    json["noRead"] = noRead;
    json["personNum"] = personNum;
    json["showTxt"] = showTxt;
    json["isTop"] = isTop;
    json["isInterruption"] = isInterruption;
    return json;
  }
}
