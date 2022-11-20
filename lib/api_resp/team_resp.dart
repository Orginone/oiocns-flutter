class TeamResp {
  String id;
  String name;
  String code;
  String targetId;
  String? authId;
  String? remark;
  int status;
  String? createUser;
  String? updateUser;
  String? version;
  DateTime? createTime;
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
