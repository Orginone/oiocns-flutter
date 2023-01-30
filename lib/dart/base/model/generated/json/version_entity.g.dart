import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/version_entity.dart';

VersionEntity $VersionEntityFromJson(Map<String, dynamic> json) {
	final VersionEntity versionEntity = VersionEntity();
	final String? key = jsonConvert.convert<String>(json['Key']);
	if (key != null) {
		versionEntity.key = key;
	}
	final dynamic? name = jsonConvert.convert<dynamic>(json['Name']);
	if (name != null) {
		versionEntity.name = name;
	}
	final String? updateTime = jsonConvert.convert<String>(json['UpdateTime']);
	if (updateTime != null) {
		versionEntity.updateTime = updateTime;
	}
	final List<VersionVersionMes>? versionMes = jsonConvert.convertListNotNull<VersionVersionMes>(json['versionMes']);
	if (versionMes != null) {
		versionEntity.versionMes = versionMes;
	}
	return versionEntity;
}

Map<String, dynamic> $VersionEntityToJson(VersionEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Key'] = entity.key;
	data['Name'] = entity.name;
	data['UpdateTime'] = entity.updateTime;
	data['versionMes'] =  entity.versionMes?.map((v) => v.toJson()).toList();
	return data;
}

VersionVersionMes $VersionVersionMesFromJson(Map<String, dynamic> json) {
	final VersionVersionMes versionVersionMes = VersionVersionMes();
	final VersionVersionMesUploadName? uploadName = jsonConvert.convert<VersionVersionMesUploadName>(json['uploadName']);
	if (uploadName != null) {
		versionVersionMes.uploadName = uploadName;
	}
	final String? appName = jsonConvert.convert<String>(json['appName']);
	if (appName != null) {
		versionVersionMes.appName = appName;
	}
	final String? publisher = jsonConvert.convert<String>(json['publisher']);
	if (publisher != null) {
		versionVersionMes.publisher = publisher;
	}
	final int? version = jsonConvert.convert<int>(json['version']);
	if (version != null) {
		versionVersionMes.version = version;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		versionVersionMes.remark = remark;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		versionVersionMes.id = id;
	}
	final VersionVersionMesPubTeam? pubTeam = jsonConvert.convert<VersionVersionMesPubTeam>(json['pubTeam']);
	if (pubTeam != null) {
		versionVersionMes.pubTeam = pubTeam;
	}
	final VersionVersionMesPubAuthor? pubAuthor = jsonConvert.convert<VersionVersionMesPubAuthor>(json['pubAuthor']);
	if (pubAuthor != null) {
		versionVersionMes.pubAuthor = pubAuthor;
	}
	final String? platform = jsonConvert.convert<String>(json['platform']);
	if (platform != null) {
		versionVersionMes.platform = platform;
	}
	final String? pubTime = jsonConvert.convert<String>(json['pubTime']);
	if (pubTime != null) {
		versionVersionMes.pubTime = pubTime;
	}
	final int? size = jsonConvert.convert<int>(json['size']);
	if (size != null) {
		versionVersionMes.size = size;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMes.name = name;
	}
	final String? extension = jsonConvert.convert<String>(json['extension']);
	if (extension != null) {
		versionVersionMes.extension = extension;
	}
	final String? shareLink = jsonConvert.convert<String>(json['shareLink']);
	if (shareLink != null) {
		versionVersionMes.shareLink = shareLink;
	}
	final String? thumbnail = jsonConvert.convert<String>(json['thumbnail']);
	if (thumbnail != null) {
		versionVersionMes.thumbnail = thumbnail;
	}
	return versionVersionMes;
}

Map<String, dynamic> $VersionVersionMesToJson(VersionVersionMes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['uploadName'] = entity.uploadName?.toJson();
	data['appName'] = entity.appName;
	data['publisher'] = entity.publisher;
	data['version'] = entity.version;
	data['remark'] = entity.remark;
	data['id'] = entity.id;
	data['pubTeam'] = entity.pubTeam?.toJson();
	data['pubAuthor'] = entity.pubAuthor?.toJson();
	data['platform'] = entity.platform;
	data['pubTime'] = entity.pubTime;
	data['size'] = entity.size;
	data['name'] = entity.name;
	data['extension'] = entity.extension;
	data['shareLink'] = entity.shareLink;
	data['thumbnail'] = entity.thumbnail;
	return data;
}

VersionVersionMesUploadName $VersionVersionMesUploadNameFromJson(Map<String, dynamic> json) {
	final VersionVersionMesUploadName versionVersionMesUploadName = VersionVersionMesUploadName();
	final int? size = jsonConvert.convert<int>(json['size']);
	if (size != null) {
		versionVersionMesUploadName.size = size;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMesUploadName.name = name;
	}
	final String? extension = jsonConvert.convert<String>(json['extension']);
	if (extension != null) {
		versionVersionMesUploadName.extension = extension;
	}
	final String? shareLink = jsonConvert.convert<String>(json['shareLink']);
	if (shareLink != null) {
		versionVersionMesUploadName.shareLink = shareLink;
	}
	final String? thumbnail = jsonConvert.convert<String>(json['thumbnail']);
	if (thumbnail != null) {
		versionVersionMesUploadName.thumbnail = thumbnail;
	}
	return versionVersionMesUploadName;
}

Map<String, dynamic> $VersionVersionMesUploadNameToJson(VersionVersionMesUploadName entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['size'] = entity.size;
	data['name'] = entity.name;
	data['extension'] = entity.extension;
	data['shareLink'] = entity.shareLink;
	data['thumbnail'] = entity.thumbnail;
	return data;
}

VersionVersionMesPubTeam $VersionVersionMesPubTeamFromJson(Map<String, dynamic> json) {
	final VersionVersionMesPubTeam versionVersionMesPubTeam = VersionVersionMesPubTeam();
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		versionVersionMesPubTeam.value = value;
	}
	final String? label = jsonConvert.convert<String>(json['label']);
	if (label != null) {
		versionVersionMesPubTeam.label = label;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		versionVersionMesPubTeam.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMesPubTeam.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		versionVersionMesPubTeam.code = code;
	}
	final String? typeName = jsonConvert.convert<String>(json['typeName']);
	if (typeName != null) {
		versionVersionMesPubTeam.typeName = typeName;
	}
	final String? belongId = jsonConvert.convert<String>(json['belongId']);
	if (belongId != null) {
		versionVersionMesPubTeam.belongId = belongId;
	}
	final String? thingId = jsonConvert.convert<String>(json['thingId']);
	if (thingId != null) {
		versionVersionMesPubTeam.thingId = thingId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		versionVersionMesPubTeam.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		versionVersionMesPubTeam.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		versionVersionMesPubTeam.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		versionVersionMesPubTeam.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		versionVersionMesPubTeam.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		versionVersionMesPubTeam.updateTime = updateTime;
	}
	final VersionVersionMesPubTeamTeam? team = jsonConvert.convert<VersionVersionMesPubTeamTeam>(json['team']);
	if (team != null) {
		versionVersionMesPubTeam.team = team;
	}
	return versionVersionMesPubTeam;
}

Map<String, dynamic> $VersionVersionMesPubTeamToJson(VersionVersionMesPubTeam entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['value'] = entity.value;
	data['label'] = entity.label;
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['typeName'] = entity.typeName;
	data['belongId'] = entity.belongId;
	data['thingId'] = entity.thingId;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['team'] = entity.team?.toJson();
	return data;
}

VersionVersionMesPubTeamTeam $VersionVersionMesPubTeamTeamFromJson(Map<String, dynamic> json) {
	final VersionVersionMesPubTeamTeam versionVersionMesPubTeamTeam = VersionVersionMesPubTeamTeam();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		versionVersionMesPubTeamTeam.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMesPubTeamTeam.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		versionVersionMesPubTeamTeam.code = code;
	}
	final String? targetId = jsonConvert.convert<String>(json['targetId']);
	if (targetId != null) {
		versionVersionMesPubTeamTeam.targetId = targetId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		versionVersionMesPubTeamTeam.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		versionVersionMesPubTeamTeam.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		versionVersionMesPubTeamTeam.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		versionVersionMesPubTeamTeam.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		versionVersionMesPubTeamTeam.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		versionVersionMesPubTeamTeam.updateTime = updateTime;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		versionVersionMesPubTeamTeam.remark = remark;
	}
	return versionVersionMesPubTeamTeam;
}

Map<String, dynamic> $VersionVersionMesPubTeamTeamToJson(VersionVersionMesPubTeamTeam entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['targetId'] = entity.targetId;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['remark'] = entity.remark;
	return data;
}

VersionVersionMesPubAuthor $VersionVersionMesPubAuthorFromJson(Map<String, dynamic> json) {
	final VersionVersionMesPubAuthor versionVersionMesPubAuthor = VersionVersionMesPubAuthor();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		versionVersionMesPubAuthor.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMesPubAuthor.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		versionVersionMesPubAuthor.code = code;
	}
	final String? typeName = jsonConvert.convert<String>(json['typeName']);
	if (typeName != null) {
		versionVersionMesPubAuthor.typeName = typeName;
	}
	final String? thingId = jsonConvert.convert<String>(json['thingId']);
	if (thingId != null) {
		versionVersionMesPubAuthor.thingId = thingId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		versionVersionMesPubAuthor.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		versionVersionMesPubAuthor.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		versionVersionMesPubAuthor.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		versionVersionMesPubAuthor.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		versionVersionMesPubAuthor.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		versionVersionMesPubAuthor.updateTime = updateTime;
	}
	final VersionVersionMesPubAuthorTeam? team = jsonConvert.convert<VersionVersionMesPubAuthorTeam>(json['team']);
	if (team != null) {
		versionVersionMesPubAuthor.team = team;
	}
	return versionVersionMesPubAuthor;
}

Map<String, dynamic> $VersionVersionMesPubAuthorToJson(VersionVersionMesPubAuthor entity) {
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
	data['team'] = entity.team?.toJson();
	return data;
}

VersionVersionMesPubAuthorTeam $VersionVersionMesPubAuthorTeamFromJson(Map<String, dynamic> json) {
	final VersionVersionMesPubAuthorTeam versionVersionMesPubAuthorTeam = VersionVersionMesPubAuthorTeam();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		versionVersionMesPubAuthorTeam.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		versionVersionMesPubAuthorTeam.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		versionVersionMesPubAuthorTeam.code = code;
	}
	final String? targetId = jsonConvert.convert<String>(json['targetId']);
	if (targetId != null) {
		versionVersionMesPubAuthorTeam.targetId = targetId;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		versionVersionMesPubAuthorTeam.remark = remark;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		versionVersionMesPubAuthorTeam.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		versionVersionMesPubAuthorTeam.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		versionVersionMesPubAuthorTeam.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		versionVersionMesPubAuthorTeam.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		versionVersionMesPubAuthorTeam.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		versionVersionMesPubAuthorTeam.updateTime = updateTime;
	}
	return versionVersionMesPubAuthorTeam;
}

Map<String, dynamic> $VersionVersionMesPubAuthorTeamToJson(VersionVersionMesPubAuthorTeam entity) {
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
	return data;
}