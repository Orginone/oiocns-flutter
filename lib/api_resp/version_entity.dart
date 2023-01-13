import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/version_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class VersionEntity {

	@JSONField(name: "Key")
	String? key;
	@JSONField(name: "Name")
	dynamic name;
	@JSONField(name: "UpdateTime")
	String? updateTime;
	List<VersionVersionMes>? versionMes;
  
  VersionEntity();

  factory VersionEntity.fromJson(Map<String, dynamic> json) => $VersionEntityFromJson(json);

  Map<String, dynamic> toJson() => $VersionEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMes {

	VersionVersionMesUploadName? uploadName;
	String? appName;
	String? publisher;
	int? version;
	String? remark;
	String? id;
	VersionVersionMesPubTeam? pubTeam;
	VersionVersionMesPubAuthor? pubAuthor;
	String? platform;
	String? pubTime;
	int? size;
	String? name;
	String? extension;
	String? shareLink;
	String? thumbnail;
  
  VersionVersionMes();

  factory VersionVersionMes.fromJson(Map<String, dynamic> json) => $VersionVersionMesFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMesUploadName {

	int? size;
	String? name;
	String? extension;
	String? shareLink;
	String? thumbnail;
  
  VersionVersionMesUploadName();

  factory VersionVersionMesUploadName.fromJson(Map<String, dynamic> json) => $VersionVersionMesUploadNameFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesUploadNameToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMesPubTeam {

	String? value;
	String? label;
	String? id;
	String? name;
	String? code;
	String? typeName;
	String? belongId;
	String? thingId;
	int? status;
	String? createUser;
	String? updateUser;
	String? version;
	String? createTime;
	String? updateTime;
	VersionVersionMesPubTeamTeam? team;
  
  VersionVersionMesPubTeam();

  factory VersionVersionMesPubTeam.fromJson(Map<String, dynamic> json) => $VersionVersionMesPubTeamFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesPubTeamToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMesPubTeamTeam {

	String? id;
	String? name;
	String? code;
	String? targetId;
	int? status;
	String? createUser;
	String? updateUser;
	String? version;
	String? createTime;
	String? updateTime;
	String? remark;

  VersionVersionMesPubTeamTeam();

  factory VersionVersionMesPubTeamTeam.fromJson(Map<String, dynamic> json) => $VersionVersionMesPubTeamTeamFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesPubTeamTeamToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMesPubAuthor {

	String? id;
	String? name;
	String? code;
	String? typeName;
	String? thingId;
	int? status;
	String? createUser;
	String? updateUser;
	String? version;
	String? createTime;
	String? updateTime;
	VersionVersionMesPubAuthorTeam? team;
  
  VersionVersionMesPubAuthor();

  factory VersionVersionMesPubAuthor.fromJson(Map<String, dynamic> json) => $VersionVersionMesPubAuthorFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesPubAuthorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VersionVersionMesPubAuthorTeam {

	String? id;
	String? name;
	String? code;
	String? targetId;
	String? remark;
	int? status;
	String? createUser;
	String? updateUser;
	String? version;
	String? createTime;
	String? updateTime;
  
  VersionVersionMesPubAuthorTeam();

  factory VersionVersionMesPubAuthorTeam.fromJson(Map<String, dynamic> json) => $VersionVersionMesPubAuthorTeamFromJson(json);

  Map<String, dynamic> toJson() => $VersionVersionMesPubAuthorTeamToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}