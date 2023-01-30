import 'package:orginone/dart/base/model/friends_entity.dart';
import 'package:orginone/dart/base/model/generated/json/base/json_convert_content.dart';

FriendsEntity $FriendsEntityFromJson(Map<String, dynamic> json) {
  final FriendsEntity friendsEntity = FriendsEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    friendsEntity.id = id;
  }
  final String? targetId = jsonConvert.convert<String>(json['targetId']);
  if (targetId != null) {
    friendsEntity.targetId = targetId;
  }
  final String? teamId = jsonConvert.convert<String>(json['teamId']);
  if (teamId != null) {
    friendsEntity.teamId = teamId;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    friendsEntity.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    friendsEntity.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    friendsEntity.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    friendsEntity.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    friendsEntity.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    friendsEntity.updateTime = updateTime;
  }
  final FriendsTeam? team = jsonConvert.convert<FriendsTeam>(json['team']);
  if (team != null) {
    friendsEntity.team = team;
  }
  final FriendsTarget? target =
      jsonConvert.convert<FriendsTarget>(json['target']);
  if (target != null) {
    friendsEntity.target = target;
  }
  return friendsEntity;
}

Map<String, dynamic> $FriendsEntityToJson(FriendsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['targetId'] = entity.targetId;
  data['teamId'] = entity.teamId;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['team'] = entity.team?.toJson();
  data['target'] = entity.target?.toJson();
  return data;
}

FriendsTeam $FriendsTeamFromJson(Map<String, dynamic> json) {
  final FriendsTeam friendsTeam = FriendsTeam();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    friendsTeam.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    friendsTeam.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    friendsTeam.code = code;
  }
  final String? targetId = jsonConvert.convert<String>(json['targetId']);
  if (targetId != null) {
    friendsTeam.targetId = targetId;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    friendsTeam.remark = remark;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    friendsTeam.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    friendsTeam.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    friendsTeam.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    friendsTeam.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    friendsTeam.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    friendsTeam.updateTime = updateTime;
  }
  final FriendsTarget? target =
      jsonConvert.convert<FriendsTarget>(json['target']);
  if (target != null) {
    friendsTeam.target = target;
  }
  return friendsTeam;
}

Map<String, dynamic> $FriendsTeamToJson(FriendsTeam entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['targetId'] = entity.targetId;
  data['remark'] = entity.remark;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['target'] = entity.target?.toJson();
  return data;
}

FriendsTarget $FriendsTargetFromJson(Map<String, dynamic> json) {
  final FriendsTarget friendsTarget = FriendsTarget();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    friendsTarget.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    friendsTarget.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    friendsTarget.code = code;
  }
  final String? typeName = jsonConvert.convert<String>(json['typeName']);
  if (typeName != null) {
    friendsTarget.typeName = typeName;
  }
  final String? thingId = jsonConvert.convert<String>(json['thingId']);
  if (thingId != null) {
    friendsTarget.thingId = thingId;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    friendsTarget.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    friendsTarget.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    friendsTarget.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    friendsTarget.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    friendsTarget.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    friendsTarget.updateTime = updateTime;
  }
  return friendsTarget;
}

Map<String, dynamic> $FriendsTargetToJson(FriendsTarget entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['code'] = entity.code;
  data['typeName'] = entity.typeName;
  data['thingId'] = entity.thingId;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  return data;
}
