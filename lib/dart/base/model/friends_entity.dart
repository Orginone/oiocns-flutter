import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/friends_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class FriendsEntity {

	late String id;
	late String targetId;
	late String teamId;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
	late FriendsTeam? team;
	late FriendsTarget? target;
  
  FriendsEntity();

  factory FriendsEntity.fromJson(Map<String, dynamic> json) => $FriendsEntityFromJson(json);

  Map<String, dynamic> toJson() => $FriendsEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FriendsTeam {

	late String id;
	late String name;
	late String code;
	late String targetId;
	late String remark;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
	late FriendsTarget? target;
  
  FriendsTeam();

  factory FriendsTeam.fromJson(Map<String, dynamic> json) => $FriendsTeamFromJson(json);

  Map<String, dynamic> toJson() => $FriendsTeamToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FriendsTarget {

	late String id;
	late String name;
	late String code;
	late String typeName;
	late String thingId;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  FriendsTarget();

  factory FriendsTarget.fromJson(Map<String, dynamic> json) => $FriendsTargetFromJson(json);

  Map<String, dynamic> toJson() => $FriendsTargetToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}