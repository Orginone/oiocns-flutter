import 'package:orginone/dart/base/model/generated/json/base/json_convert_content.dart';
import 'package:orginone/dart/base/model/task_entity.dart';

TaskEntity $TaskEntityFromJson(Map<String, dynamic> json) {
  final TaskEntity taskEntity = TaskEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    taskEntity.id = id;
  }
  final String? nodeId = jsonConvert.convert<String>(json['nodeId']);
  if (nodeId != null) {
    taskEntity.nodeId = nodeId;
  }
  final String? instanceId = jsonConvert.convert<String>(json['instanceId']);
  if (instanceId != null) {
    taskEntity.instanceId = instanceId;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    taskEntity.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    taskEntity.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    taskEntity.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    taskEntity.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    taskEntity.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    taskEntity.updateTime = updateTime;
  }
  final TaskFlowNode? flowNode =
      jsonConvert.convert<TaskFlowNode>(json['flowNode']);
  if (flowNode != null) {
    taskEntity.flowNode = flowNode;
  }
  final TaskFlowInstance? flowInstance =
      jsonConvert.convert<TaskFlowInstance>(json['flowInstance']);
  if (flowInstance != null) {
    taskEntity.flowInstance = flowInstance;
  }
  return taskEntity;
}

Map<String, dynamic> $TaskEntityToJson(TaskEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['nodeId'] = entity.nodeId;
  data['instanceId'] = entity.instanceId;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['flowNode'] = entity.flowNode?.toJson();
  data['flowInstance'] = entity.flowInstance?.toJson();
  return data;
}

TaskFlowNode $TaskFlowNodeFromJson(Map<String, dynamic> json) {
  final TaskFlowNode taskFlowNode = TaskFlowNode();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    taskFlowNode.id = id;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    taskFlowNode.code = code;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    taskFlowNode.name = name;
  }
  final String? count = jsonConvert.convert<String>(json['count']);
  if (count != null) {
    taskFlowNode.count = count;
  }
  final String? defineId = jsonConvert.convert<String>(json['defineId']);
  if (defineId != null) {
    taskFlowNode.defineId = defineId;
  }
  final String? identityId = jsonConvert.convert<String>(json['identityId']);
  if (identityId != null) {
    taskFlowNode.identityId = identityId;
  }
  final String? rules = jsonConvert.convert<String>(json['rules']);
  if (rules != null) {
    taskFlowNode.rules = rules;
  }
  final String? nodeType = jsonConvert.convert<String>(json['nodeType']);
  if (nodeType != null) {
    taskFlowNode.nodeType = nodeType;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    taskFlowNode.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    taskFlowNode.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    taskFlowNode.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    taskFlowNode.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    taskFlowNode.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    taskFlowNode.updateTime = updateTime;
  }
  return taskFlowNode;
}

Map<String, dynamic> $TaskFlowNodeToJson(TaskFlowNode entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['code'] = entity.code;
  data['name'] = entity.name;
  data['count'] = entity.count;
  data['defineId'] = entity.defineId;
  data['identityId'] = entity.identityId;
  data['rules'] = entity.rules;
  data['nodeType'] = entity.nodeType;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  return data;
}

TaskFlowInstance $TaskFlowInstanceFromJson(Map<String, dynamic> json) {
  final TaskFlowInstance taskFlowInstance = TaskFlowInstance();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    taskFlowInstance.id = id;
  }
  final String? defineId = jsonConvert.convert<String>(json['defineId']);
  if (defineId != null) {
    taskFlowInstance.defineId = defineId;
  }
  final String? relationId = jsonConvert.convert<String>(json['relationId']);
  if (relationId != null) {
    taskFlowInstance.relationId = relationId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    taskFlowInstance.title = title;
  }
  final String? contentType = jsonConvert.convert<String>(json['contentType']);
  if (contentType != null) {
    taskFlowInstance.contentType = contentType;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    taskFlowInstance.content = content;
  }
  final String? data = jsonConvert.convert<String>(json['data']);
  if (data != null) {
    taskFlowInstance.data = data;
  }
  final String? hook = jsonConvert.convert<String>(json['hook']);
  if (hook != null) {
    taskFlowInstance.hook = hook;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    taskFlowInstance.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    taskFlowInstance.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    taskFlowInstance.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    taskFlowInstance.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    taskFlowInstance.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    taskFlowInstance.updateTime = updateTime;
  }
  final TaskFlowInstanceFlowRelation? flowRelation =
      jsonConvert.convert<TaskFlowInstanceFlowRelation>(json['flowRelation']);
  if (flowRelation != null) {
    taskFlowInstance.flowRelation = flowRelation;
  }
  return taskFlowInstance;
}

Map<String, dynamic> $TaskFlowInstanceToJson(TaskFlowInstance entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['defineId'] = entity.defineId;
  data['relationId'] = entity.relationId;
  data['title'] = entity.title;
  data['contentType'] = entity.contentType;
  data['content'] = entity.content;
  data['data'] = entity.data;
  data['hook'] = entity.hook;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['flowRelation'] = entity.flowRelation?.toJson();
  return data;
}

TaskFlowInstanceFlowRelation $TaskFlowInstanceFlowRelationFromJson(
    Map<String, dynamic> json) {
  final TaskFlowInstanceFlowRelation taskFlowInstanceFlowRelation =
      TaskFlowInstanceFlowRelation();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    taskFlowInstanceFlowRelation.id = id;
  }
  final String? productId = jsonConvert.convert<String>(json['productId']);
  if (productId != null) {
    taskFlowInstanceFlowRelation.productId = productId;
  }
  final String? functionCode =
      jsonConvert.convert<String>(json['functionCode']);
  if (functionCode != null) {
    taskFlowInstanceFlowRelation.functionCode = functionCode;
  }
  final String? defineId = jsonConvert.convert<String>(json['defineId']);
  if (defineId != null) {
    taskFlowInstanceFlowRelation.defineId = defineId;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    taskFlowInstanceFlowRelation.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    taskFlowInstanceFlowRelation.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    taskFlowInstanceFlowRelation.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    taskFlowInstanceFlowRelation.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    taskFlowInstanceFlowRelation.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    taskFlowInstanceFlowRelation.updateTime = updateTime;
  }
  return taskFlowInstanceFlowRelation;
}

Map<String, dynamic> $TaskFlowInstanceFlowRelationToJson(
    TaskFlowInstanceFlowRelation entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['productId'] = entity.productId;
  data['functionCode'] = entity.functionCode;
  data['defineId'] = entity.defineId;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  return data;
}
