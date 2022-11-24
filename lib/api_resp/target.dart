import 'package:hive/hive.dart';
import 'package:orginone/api_resp/team_resp.dart';

import '../config/hive_object_id.dart';
import 'identity_resp.dart';

part 'target_resp.g.dart';

@HiveType(typeId: HiveObjectId.target)
class Target {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String typeName;
  @HiveField(4)
  String? belongId;
  @HiveField(5)
  String thingId;
  @HiveField(6)
  int status;
  @HiveField(7)
  String? createUser;
  @HiveField(8)
  String? updateUser;
  @HiveField(9)
  String? version;
  @HiveField(10)
  DateTime? createTime;
  @HiveField(11)
  DateTime? updateTime;
  @HiveField(12)
  TeamResp? team;
  @HiveField(13)
  List<IdentityResp>? givenIdentitys;

  Target(
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
    json['createTime'] = createTime;
    json['updateTime'] = updateTime;
    return json;
  }
}
