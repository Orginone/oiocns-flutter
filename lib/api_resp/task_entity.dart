import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/task_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class TaskEntity {

	late String id;
	late String nodeId;
	late String instanceId;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
	late TaskFlowNode flowNode;
	late TaskFlowInstance flowInstance;
  
  TaskEntity();

  factory TaskEntity.fromJson(Map<String, dynamic> json) => $TaskEntityFromJson(json);

  Map<String, dynamic> toJson() => $TaskEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TaskFlowNode {

	late String id;
	late String code;
	late String name;
	late String count;
	late String defineId;
	late String identityId;
	late String rules;
	late String nodeType;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  TaskFlowNode();

  factory TaskFlowNode.fromJson(Map<String, dynamic> json) => $TaskFlowNodeFromJson(json);

  Map<String, dynamic> toJson() => $TaskFlowNodeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TaskFlowInstance {

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
	late TaskFlowInstanceFlowRelation flowRelation;
  
  TaskFlowInstance();

  factory TaskFlowInstance.fromJson(Map<String, dynamic> json) => $TaskFlowInstanceFromJson(json);

  Map<String, dynamic> toJson() => $TaskFlowInstanceToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class TaskFlowInstanceFlowRelation {

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
  
  TaskFlowInstanceFlowRelation();

  factory TaskFlowInstanceFlowRelation.fromJson(Map<String, dynamic> json) => $TaskFlowInstanceFlowRelationFromJson(json);

  Map<String, dynamic> toJson() => $TaskFlowInstanceFlowRelationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}