
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {

  @HiveField(0)
  String? account;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? workspaceId;

  @HiveField(3)
  String? workspaceName;

  @HiveField(4)
  Attrs? attrs;

  @HiveField(5)
  Person? person;

  @HiveField(6)
  String? accessToken;

  @HiveField(7)
  int? expiresIn;

  @HiveField(8)
  String? authority;

  @HiveField(9)
  String? license;

  @HiveField(10)
  String? tokenType;

  @HiveField(11)
  String? motto;

  UserModel(
      {this.account,
        this.userName,
        this.workspaceId,
        this.workspaceName,
        this.attrs,
        this.person,
        this.accessToken,
        this.expiresIn,
        this.authority,
        this.license,
        this.tokenType,
        this.motto});

  UserModel.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    userName = json['userName'];
    workspaceId = json['workspaceId'];
    workspaceName = json['workspaceName'];
    attrs = json['attrs'] != null ? new Attrs.fromJson(json['attrs']) : null;
    person =
    json['person'] != null ? new Person.fromJson(json['person']) : null;
    accessToken = json['accessToken'];
    expiresIn = json['expiresIn'];
    authority = json['authority'];
    license = json['license'];
    tokenType = json['tokenType'];
    motto = json['motto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['userName'] = this.userName;
    data['workspaceId'] = this.workspaceId;
    data['workspaceName'] = this.workspaceName;
    if (this.attrs != null) {
      data['attrs'] = this.attrs!.toJson();
    }
    if (this.person != null) {
      data['person'] = this.person!.toJson();
    }
    data['accessToken'] = this.accessToken;
    data['expiresIn'] = this.expiresIn;
    data['authority'] = this.authority;
    data['license'] = this.license;
    data['tokenType'] = this.tokenType;
    data['motto'] = this.motto;
    return data;
  }
}


@HiveType(typeId: 1)
class Attrs {

  @HiveField(1)
  int? limit;

  Attrs({this.limit});

  Attrs.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    return data;
  }
}

@HiveType(typeId: 2)
class Person {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? code;

  @HiveField(3)
  String? typeName;

  @HiveField(4)
  String? thingId;

  @HiveField(5)
  int? status;

  @HiveField(6)
  String? createUser;

  @HiveField(7)
  String? updateUser;

  @HiveField(8)
  String? version;

  @HiveField(9)
  String? createTime;

  @HiveField(10)
  String? updateTime;

  @HiveField(11)
  Team? team;

  Person(
      {this.id,
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
        this.team});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    typeName = json['typeName'];
    thingId = json['thingId'];
    status = json['status'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['typeName'] = this.typeName;
    data['thingId'] = this.thingId;
    data['status'] = this.status;
    data['createUser'] = this.createUser;
    data['updateUser'] = this.updateUser;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    return data;
  }
}


@HiveType(typeId: 3)
class Team {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? code;

  @HiveField(3)
  String? targetId;

  @HiveField(4)
  String? remark;

  @HiveField(5)
  int? status;

  @HiveField(6)
  String? createUser;

  @HiveField(7)
  String? updateUser;

  @HiveField(8)
  String? version;

  @HiveField(9)
  String? createTime;

  @HiveField(10)
  String? updateTime;

  Team(
      {this.id,
        this.name,
        this.code,
        this.targetId,
        this.remark,
        this.status,
        this.createUser,
        this.updateUser,
        this.version,
        this.createTime,
        this.updateTime});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    targetId = json['targetId'];
    remark = json['remark'];
    status = json['status'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['targetId'] = this.targetId;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['createUser'] = this.createUser;
    data['updateUser'] = this.updateUser;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}
