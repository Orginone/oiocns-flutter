import 'package:orginone/api_resp/team_resp.dart';

import 'identity_resp.dart';

class TargetResp {
  String id;
  String name;
  String code;
  String typeName;
  String? belongId;
  String thingId;
  int status;
  String? createUser;
  String? updateUser;
  String? version;
  DateTime? createTime;
  DateTime? updateTime;
  TeamResp? team;
  List<IdentityResp>? givenIdentitys;

  TargetResp(
      this.id,
      this.name,
      this.code,
      this.typeName,
      this.belongId,
      this.thingId,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime,
      this.team,
      this.givenIdentitys);

  TargetResp.copyWith(TargetResp targetResp)
      : id = targetResp.id,
        name = targetResp.name,
        code = targetResp.code,
        typeName = targetResp.typeName,
        belongId = targetResp.belongId,
        thingId = targetResp.thingId,
        status = targetResp.status,
        createUser = targetResp.createUser,
        updateUser = targetResp.updateUser,
        version = targetResp.version,
        createTime = targetResp.createTime,
        updateTime = targetResp.updateTime,
        team = targetResp.team == null
            ? null
            : TeamResp.copyWith(targetResp.team!),
        givenIdentitys = targetResp.givenIdentitys
            ?.map((item) => IdentityResp.copyWith(item))
            .toList();

  TargetResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        code = map["code"],
        typeName = map["typeName"],
        belongId = map['belongId'],
        thingId = map["thingId"],
        status = map["status"],
        createUser = map["createUser"],
        updateUser = map["updateUser"],
        version = map["version"],
        createTime = DateTime.parse(map["createTime"]),
        updateTime = DateTime.parse(map["updateTime"]),
        team = map["team"] != null ? TeamResp.fromMap(map["team"]) : null,
        givenIdentitys = map["givenIdentitys"] != null
            ? IdentityResp.fromList(map["givenIdentitys"])
            : null;

  static List<TargetResp> fromList(List<dynamic> list) {
    List<TargetResp> ans = [];
    if (list.isEmpty) return ans;

    for (var one in list) {
      if (one == null) continue;
      ans.add(TargetResp.fromMap(one));
    }
    return ans;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['code'] = code;
    json['typeName'] = typeName;
    json['belongId'] = belongId;
    json['thingId'] = thingId;
    json['status'] = status;
    json['createUser'] = createUser;
    json['updateUser'] = updateUser;
    json['version'] = version;
    json['createTime'] = createTime;
    json['updateTime'] = updateTime;
    return json;
  }
}
