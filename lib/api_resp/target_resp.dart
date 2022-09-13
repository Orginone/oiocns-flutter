import 'package:hive/hive.dart';
import 'package:orginone/api_resp/team_resp.dart';

import '../config/hive_object_id.dart';
import '../model/db_model.dart';
import 'identity_resp.dart';

part 'target_resp.g.dart';

@HiveType(typeId: HiveObjectId.target)
class TargetResp {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String typeName;
  @HiveField(4)
  int belongId;
  @HiveField(5)
  int thingId;
  @HiveField(6)
  int status;
  @HiveField(7)
  int createUser;
  @HiveField(8)
  int updateUser;
  @HiveField(9)
  int version;
  @HiveField(10)
  DateTime createTime;
  @HiveField(11)
  DateTime updateTime;
  @HiveField(12)
  TeamResp team;
  @HiveField(13)
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
        team = TeamResp.copyWith(targetResp.team),
        givenIdentitys = targetResp.givenIdentitys?.map((item) => IdentityResp.copyWith(item)).toList();

  TargetResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        code = map["code"],
        typeName = map["typeName"],
        belongId =
            map.containsKey('belongId') ? int.parse(map['belongId']) : -1,
        thingId = int.parse(map["thingId"]),
        status = map["status"],
        createUser = int.parse(map["createUser"]),
        updateUser = int.parse(map["updateUser"]),
        version = int.parse(map["version"]),
        createTime = DateTime.parse(map["createTime"]),
        updateTime = DateTime.parse(map["updateTime"]),
        team = TeamResp.fromMap(map["team"]),
        givenIdentitys = map.containsKey("givenIdentitys")
            ? IdentityResp.fromList(map["givenIdentitys"])
            : null;

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

  Target toTarget() {
    var target = Target();
    target.id = id;
    target.code = code;
    target.name = name;
    target.typeName = typeName;
    target.belongId = belongId;
    target.thingId = thingId;
    return target;
  }
}
