import 'package:hive/hive.dart';

import '../config/hive_object_id.dart';

part 'team.g.dart';

@HiveType(typeId: HiveObjectId.team)
class Team {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  int targetId;
  @HiveField(4)
  int authId;
  @HiveField(5)
  String remark;
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

  Team(
      this.id,
      this.name,
      this.code,
      this.targetId,
      this.authId,
      this.remark,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime);

  Team.fromJson(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        code = map["code"],
        targetId = int.parse(map["targetId"]),
        authId = int.parse(map["authId"]),
        remark = map["remark"],
        status = map["status"],
        createUser = int.parse(map["createUser"]),
        updateUser = int.parse(map["updateUser"]),
        version = int.parse(map["version"]),
        createTime = DateTime.parse(map["createTime"]),
        updateTime = DateTime.parse(map["updateTime"]);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['code'] = code;
    json['targetId'] = targetId;
    json['authId'] = authId;
    json['remark'] = remark;
    json['status'] = status;
    json['createUser'] = createUser;
    json['updateUser'] = updateUser;
    json['version'] = version;
    json['createTime'] = createTime;
    json['updateTime'] = updateTime;
    return json;
  }
}
