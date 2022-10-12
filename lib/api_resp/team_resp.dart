import 'package:hive/hive.dart';

import '../config/hive_object_id.dart';
import '../util/date_util.dart';

part 'team_resp.g.dart';

@HiveType(typeId: HiveObjectId.team)
class TeamResp {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String targetId;
  @HiveField(4)
  String? authId;
  @HiveField(5)
  String? remark;
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

  TeamResp(
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

  TeamResp.copyWith(TeamResp teamResp)
      : id = teamResp.id,
        name = teamResp.name,
        code = teamResp.code,
        targetId = teamResp.targetId,
        authId = teamResp.authId,
        remark = teamResp.remark,
        status = teamResp.status,
        createUser = teamResp.createUser,
        updateUser = teamResp.updateUser,
        version = teamResp.version,
        createTime = teamResp.createTime,
        updateTime = teamResp.updateTime;

  TeamResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        code = map["code"],
        targetId = map["targetId"],
        authId = map["authId"],
        remark = map["remark"],
        status = map["status"],
        createUser = map["createUser"],
        updateUser = map["updateUser"],
        version = map["version"],
        createTime = CustomDateUtil.parse(map["createTime"]),
        updateTime =  CustomDateUtil.parse(map["updateTime"]);

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
