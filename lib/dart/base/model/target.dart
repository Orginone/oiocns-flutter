import 'package:orginone/dart/base/model/identity_resp.dart';
import 'package:orginone/dart/base/model/team_resp.dart';

class Target {
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

  Target({
    required this.id,
    required this.name,
    required this.code,
    required this.typeName,
    this.belongId,
    required this.thingId,
    required this.status,
    this.createUser,
    this.updateUser,
    this.version,
    this.createTime,
    this.updateTime,
    this.team,
    this.givenIdentitys,
  });

  Target.copyWith(Target targetResp)
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

  Target.fromMap(Map<String, dynamic> map)
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

  static List<Target> fromList(List<dynamic> list) {
    List<Target> ans = [];
    if (list.isEmpty) return ans;

    for (var one in list) {
      if (one == null) continue;
      ans.add(Target.fromMap(one));
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
    json['createTime'] = createTime.toString();
    json['updateTime'] = updateTime.toString();
    return json;
  }
}
