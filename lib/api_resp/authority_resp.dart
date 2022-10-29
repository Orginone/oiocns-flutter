class AuthorityResp {
  String id;
  String name;
  String code;
  bool public;
  String? remark;
  String? parentId;
  String? belongId;
  int status;
  String createUser;
  String updateUser;
  String version;
  DateTime createTime;
  DateTime updateTime;

  AuthorityResp(
      this.id,
      this.name,
      this.code,
      this.public,
      this.remark,
      this.parentId,
      this.belongId,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime);

  AuthorityResp.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        code = map["code"],
        public = map["public"],
        remark = map["remark"],
        parentId = map["parentId"],
        belongId = map["belongId"],
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
    json["public"] = public;
    json['belongId'] = belongId;
    json["parentId"] = parentId;
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
