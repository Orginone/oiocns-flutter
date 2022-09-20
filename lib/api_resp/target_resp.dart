import 'package:hive/hive.dart';
import 'package:orginone/api_resp/team_resp.dart';

import '../config/hive_object_id.dart';
import '../model/db_model.dart';
import '../util/date_util.dart';
import 'identity_resp.dart';

part 'target_resp.g.dart';

@HiveType(typeId: HiveObjectId.target)
class TargetResp {
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
  String createUser;
  @HiveField(8)
  String updateUser;
  @HiveField(9)
  String? version;
  @HiveField(10)
  DateTime? createTime;
  @HiveField(11)
  DateTime? updateTime;
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
        createTime = CustomDateUtil.parse(map["createTime"]),
        updateTime = CustomDateUtil.parse(map["updateTime"]),
        team = TeamResp.fromMap(map["team"]),
        givenIdentitys = map["givenIdentitys"] != null
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
}
