class ImMsgModel {
  final String spaceId;
  final String fromId;
  final String toId;
  final String msgType;
  final String msgBody;

  ImMsgModel({
    required this.spaceId,
    required this.fromId,
    required this.toId,
    required this.msgType,
    required this.msgBody,
  });

  ImMsgModel.fromMap(Map<String, dynamic> map)
      : spaceId = map["spaceId"],
        fromId = map["fromId"],
        toId = map["toId"],
        msgType = map["msgType"],
        msgBody = map["msgBody"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["fromId"] = fromId;
    json["toId"] = toId;
    json["msgType"] = msgType;
    json["msgBody"] = msgBody;
    return json;
  }
}

class PageModel {
  final int offset;
  final int limit;
  final String filter;

  PageModel({
    required this.offset,
    required this.limit,
    required this.filter,
  });

  PageModel.fromMap(Map<String, dynamic> map)
      : offset = map["offset"],
        limit = map["limit"],
        filter = map["filter"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["offset"] = offset;
    json["limit"] = limit;
    json["filter"] = filter;
    return json;
  }
}

class IdSpaceReq {
  final String id;
  final String spaceId;
  final PageModel page;

  IdSpaceReq({
    required this.id,
    required this.spaceId,
    required this.page,
  });

  IdSpaceReq.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        spaceId = map["spaceId"],
        page = PageModel.fromMap(map["page"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json["page"] = page.toJson();
    return json;
  }
}

class IdReq {
  final String id;
  final PageModel page;

  IdReq({
    required this.id,
    required this.page,
  });

  IdReq.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        page = PageModel.fromMap(map["page"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["page"] = page.toJson();
    return json;
  }
}

class IDReqSubModel {
  final String id;
  final List<String> typeNames;
  final List<String> subTypeNames;
  final PageModel page;

  IDReqSubModel({
    required this.id,
    required this.typeNames,
    required this.subTypeNames,
    required this.page,
  });

  IDReqSubModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        typeNames = map["cohortName"],
        subTypeNames = map["spaceTypeName"],
        page = PageModel.fromMap(map["page"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeNames"] = typeNames;
    json["subTypeNames"] = subTypeNames;
    json["page"] = page.toJson();
    return json;
  }
}

class ChatsReqModel {
  final String spaceId;
  final String cohortName;
  final String spaceTypeName;

  ChatsReqModel({
    required this.spaceId,
    required this.cohortName,
    required this.spaceTypeName,
  });

  ChatsReqModel.fromMap(Map<String, dynamic> map)
      : spaceId = map["spaceId"],
        cohortName = map["cohortName"],
        spaceTypeName = map["spaceTypeName"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["cohortName"] = cohortName;
    json["spaceTypeName"] = spaceTypeName;
    return json;
  }
}
