import 'dart:convert';

import 'package:orginone/dart/base/model/generated/json/base/json_field.dart';
import 'package:orginone/dart/base/model/generated/json/record_task_entity.g.dart';

@JsonSerializable()
class RecordTaskEntity {
  late String id;
  late String targetId;
  late String taskId;
  late String comment;
  late int status;
  late String createUser;
  late String updateUser;
  late String version;
  late String createTime;
  late String updateTime;
  late RecordTaskFlowTask? flowTask;

  RecordTaskEntity();

  factory RecordTaskEntity.fromJson(Map<String, dynamic> json) =>
      $RecordTaskEntityFromJson(json);

  Map<String, dynamic> toJson() => $RecordTaskEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RecordTaskFlowTask {
  late String id;
  late String nodeId;
  late String instanceId;
  late int status;
  late String createUser;
  late String updateUser;
  late String version;
  late String createTime;
  late String updateTime;
  late RecordTaskFlowTaskFlowNode? flowNode;
  late RecordTaskFlowTaskFlowInstance? flowInstance;

  RecordTaskFlowTask();

  factory RecordTaskFlowTask.fromJson(Map<String, dynamic> json) =>
      $RecordTaskFlowTaskFromJson(json);

  Map<String, dynamic> toJson() => $RecordTaskFlowTaskToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RecordTaskFlowTaskFlowNode {
  late String id;
  late String nodeType;

  RecordTaskFlowTaskFlowNode();

  factory RecordTaskFlowTaskFlowNode.fromJson(Map<String, dynamic> json) =>
      $RecordTaskFlowTaskFlowNodeFromJson(json);

  Map<String, dynamic> toJson() => $RecordTaskFlowTaskFlowNodeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RecordTaskFlowTaskFlowInstance {
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
  late RecordTaskFlowTaskFlowInstanceFlowRelation? flowRelation;

  RecordTaskFlowTaskFlowInstance();

  factory RecordTaskFlowTaskFlowInstance.fromJson(Map<String, dynamic> json) =>
      $RecordTaskFlowTaskFlowInstanceFromJson(json);

  Map<String, dynamic> toJson() => $RecordTaskFlowTaskFlowInstanceToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RecordTaskFlowTaskFlowInstanceFlowRelation {
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

  RecordTaskFlowTaskFlowInstanceFlowRelation();

  factory RecordTaskFlowTaskFlowInstanceFlowRelation.fromJson(
          Map<String, dynamic> json) =>
      $RecordTaskFlowTaskFlowInstanceFlowRelationFromJson(json);

  Map<String, dynamic> toJson() =>
      $RecordTaskFlowTaskFlowInstanceFlowRelationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
