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
}

class IdReq {
  final String id;
  final PageModel page;

  IdReq({
    required this.id,
    required this.page,
  });
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
