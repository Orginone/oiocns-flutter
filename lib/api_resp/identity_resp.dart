class IdentityResp {
  int id;
  String name;
  String code;
  String remark;
  int authId;
  int belongId;
  int status;
  int createUser;
  int updateUser;
  int version;
  DateTime createTime;
  DateTime updateTime;

  IdentityResp(
      this.id,
      this.name,
      this.code,
      this.authId,
      this.belongId,
      this.remark,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime);

  IdentityResp.copyWith(IdentityResp identityResp)
      : id = identityResp.id,
        name = identityResp.name,
        code = identityResp.code,
        authId = identityResp.authId,
        belongId = identityResp.belongId,
        remark = identityResp.remark,
        status = identityResp.status,
        createUser = identityResp.createUser,
        updateUser = identityResp.updateUser,
        version = identityResp.version,
        createTime = identityResp.createTime,
        updateTime = identityResp.updateTime;

  IdentityResp.fromMap(Map<String, dynamic> map)
      : id = int.parse(map["id"]),
        name = map["name"],
        code = map["code"],
        authId = int.parse(map["authId"]),
        belongId = int.parse(map["belongId"]),
        remark = map["remark"] ?? "",
        status = map["status"],
        createUser = int.parse(map["createUser"]),
        updateUser = int.parse(map["updateUser"]),
        version = int.parse(map["version"]),
        createTime = DateTime.parse(map["createTime"]),
        updateTime = DateTime.parse(map["updateTime"]);

  static List<IdentityResp> fromList(List<dynamic> list) {
    List<IdentityResp> ans = [];
    if (list.isEmpty) return ans;

    for (var one in list) {
      if (one == null) continue;
      ans.add(IdentityResp.fromMap(one));
    }
    return ans;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['code'] = code;
    json['authId'] = authId;
    json['belongId'] = belongId;
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
