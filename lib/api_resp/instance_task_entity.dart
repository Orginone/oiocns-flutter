import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/instance_task_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class InstanceTaskEntity {

	late String id;
	late String defineId;
	late String relationId;
	late String title;
	late String contentType;
	late String content;
	late String data;
	late String hook;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
	late List<InstanceTaskFlowTasks> flowTasks;
	late InstanceTaskFlowDefine? flowDefine;
	late InstanceTaskFlowRelation? flowRelation;
  
  InstanceTaskEntity();

  factory InstanceTaskEntity.fromJson(Map<String, dynamic> json) => $InstanceTaskEntityFromJson(json);

  Map<String, dynamic> toJson() => $InstanceTaskEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InstanceTaskFlowTasks {

	late String id;
	late String nodeId;
	late String instanceId;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  InstanceTaskFlowTasks();

  factory InstanceTaskFlowTasks.fromJson(Map<String, dynamic> json) => $InstanceTaskFlowTasksFromJson(json);

  Map<String, dynamic> toJson() => $InstanceTaskFlowTasksToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InstanceTaskFlowDefine {

	late String id;
	late String name;
	late String code;
	late String belongId;
	late String content;
	late String remark;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  InstanceTaskFlowDefine();

  factory InstanceTaskFlowDefine.fromJson(Map<String, dynamic> json) => $InstanceTaskFlowDefineFromJson(json);

  Map<String, dynamic> toJson() => $InstanceTaskFlowDefineToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InstanceTaskFlowRelation {

	late String id;
	late String productId;
	late String functionCode;
	late String defineId;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  InstanceTaskFlowRelation();

  factory InstanceTaskFlowRelation.fromJson(Map<String, dynamic> json) => $InstanceTaskFlowRelationFromJson(json);

  Map<String, dynamic> toJson() => $InstanceTaskFlowRelationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}