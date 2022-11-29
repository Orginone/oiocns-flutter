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

  ImMsgModel.fromJson(Map<String, dynamic> map)
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

class PageRequest {
  final int offset;
  final int limit;
  final String filter;

  PageRequest({
    required this.offset,
    required this.limit,
    required this.filter,
  });

  PageRequest.fromJson(Map<String, dynamic> map)
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
  final PageRequest page;

  IdSpaceReq({
    required this.id,
    required this.spaceId,
    required this.page,
  });

  IdSpaceReq.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        spaceId = map["spaceId"],
        page = PageRequest.fromJson(map["page"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json["page"] = page.toJson();
    return json;
  }
}

class IdReqModel {
  final String id;
  final String typeName;
  final String belongId;

  IdReqModel({
    required this.id,
    required this.typeName,
    required this.belongId,
  });

  IdReqModel.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        typeName = map["typeName"],
        belongId = map["belongId"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeName"] = typeName;
    json["belongId"] = belongId;
    return json;
  }
}

class IdReq {
  final String id;
  final PageRequest page;

  IdReq({
    required this.id,
    required this.page,
  });

  IdReq.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        page = PageRequest.fromJson(map["page"]);

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
  final PageRequest page;

  IDReqSubModel({
    required this.id,
    required this.typeNames,
    required this.subTypeNames,
    required this.page,
  });

  IDReqSubModel.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        typeNames = map["cohortName"],
        subTypeNames = map["spaceTypeName"],
        page = PageRequest.fromJson(map["page"]);

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

  ChatsReqModel.fromJson(Map<String, dynamic> map)
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

class IDReqJoinedModel {
  final String id;
  final String typeName;
  final List<String> joinTypeNames;
  final String spaceId;
  final PageRequest page;

  IDReqJoinedModel({
    required this.id,
    required this.typeName,
    required this.joinTypeNames,
    required this.spaceId,
    required this.page,
  });

  IDReqJoinedModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        typeName = json["typeName"],
        joinTypeNames = json["JoinTypeNames"],
        spaceId = json["spaceId"],
        page = PageRequest.fromJson(json["page"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeName"] = typeName;
    json["JoinTypeNames"] = joinTypeNames;
    json["spaceId"] = spaceId;
    json["page"] = page.toJson();
    return json;
  }
}

class TeamPullModel {
  final String id;
  final List<String> teamTypes;
  final List<String> targetIds;
  final String targetType;

  TeamPullModel({
    required this.id,
    required this.teamTypes,
    required this.targetIds,
    required this.targetType,
  });

  TeamPullModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamTypes = json["teamTypes"],
        targetIds = json["targetIds"],
        targetType = json["targetType"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamTypes"] = teamTypes;
    json["targetIds"] = targetIds;
    json["targetType"] = targetType;
    return json;
  }
}

class ExitTeamModel {
  final String id;
  final List<String> teamTypes;
  final String targetId;
  final String targetType;

  ExitTeamModel({
    required this.id,
    required this.teamTypes,
    required this.targetId,
    required this.targetType,
  });

  ExitTeamModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamTypes = json["teamTypes"],
        targetId = json["targetId"],
        targetType = json["targetType"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamTypes"] = teamTypes;
    json["targetId"] = targetId;
    json["targetType"] = targetType;
    return json;
  }
}

class TargetModel {
  String? id;
  String? name;
  String? code;
  String? typeName;
  String? belongId;
  String? teamName;
  String? teamCode;
  String? teamRemark;
  String? thingId;

  TargetModel({
    this.id,
    this.name,
    this.code,
    this.typeName,
    this.belongId,
    this.teamName,
    this.teamCode,
    this.teamRemark,
    this.thingId,
  });

  TargetModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        typeName = json["typeName"],
        belongId = json["belongId"],
        teamName = json["teamName"],
        teamCode = json["teamCode"],
        teamRemark = json["teamRemark"],
        thingId = json["thingId"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["typeName"] = typeName;
    json["belongId"] = belongId;
    json["teamName"] = teamName;
    json["teamCode"] = teamCode;
    json["teamRemark"] = teamRemark;
    json["thingId"] = thingId;
    return json;
  }
}

class JoinTeamModel {
  final String id;
  final String teamType;
  final String targetId;
  final String targetType;

  JoinTeamModel({
    required this.id,
    required this.teamType,
    required this.targetId,
    required this.targetType,
  });

  JoinTeamModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamType = json["teamType"],
        targetId = json["targetId"],
        targetType = json["targetType"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamType"] = teamType;
    json["targetId"] = targetId;
    json["targetType"] = targetType;
    return json;
  }
}
