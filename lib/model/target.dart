import 'package:hive/hive.dart';
import 'package:orginone/model/team.dart';

import '../config/hive_object_id.dart';

part 'target.g.dart';

@HiveType(typeId: HiveObjectId.target)
class Target {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String typeName;
  @HiveField(4)
  int thingId;
  @HiveField(5)
  int status;
  @HiveField(6)
  int createUser;
  @HiveField(7)
  int updateUser;
  @HiveField(8)
  int version;
  @HiveField(9)
  DateTime createTime;
  @HiveField(10)
  DateTime updateTime;
  @HiveField(11)
  Team team;

  Target(
      this.id,
      this.name,
      this.code,
      this.typeName,
      this.thingId,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime,
      this.team);

  Target.fromJson(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        code = map["code"],
        typeName = map["typeName"],
        thingId = int.parse(map["thingId"]),
        status = map["status"],
        createUser = int.parse(map["createUser"]),
        updateUser = int.parse(map["updateUser"]),
        version = int.parse(map["version"]),
        createTime = DateTime.parse(map["createTime"]),
        updateTime = DateTime.parse(map["updateTime"]),
        team = Team.fromJson(map["team"]);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['code'] = code;
    json['typeName'] = typeName;
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
