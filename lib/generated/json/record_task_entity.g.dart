import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/record_task_entity.dart';

RecordTaskEntity $RecordTaskEntityFromJson(Map<String, dynamic> json) {
	final RecordTaskEntity recordTaskEntity = RecordTaskEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		recordTaskEntity.id = id;
	}
	final String? targetId = jsonConvert.convert<String>(json['targetId']);
	if (targetId != null) {
		recordTaskEntity.targetId = targetId;
	}
	final String? taskId = jsonConvert.convert<String>(json['taskId']);
	if (taskId != null) {
		recordTaskEntity.taskId = taskId;
	}
	final String? comment = jsonConvert.convert<String>(json['comment']);
	if (comment != null) {
		recordTaskEntity.comment = comment;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		recordTaskEntity.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		recordTaskEntity.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		recordTaskEntity.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		recordTaskEntity.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		recordTaskEntity.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		recordTaskEntity.updateTime = updateTime;
	}
	final RecordTaskFlowTask? flowTask = jsonConvert.convert<RecordTaskFlowTask>(json['flowTask']);
	if (flowTask != null) {
		recordTaskEntity.flowTask = flowTask;
	}
	return recordTaskEntity;
}

Map<String, dynamic> $RecordTaskEntityToJson(RecordTaskEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['targetId'] = entity.targetId;
	data['taskId'] = entity.taskId;
	data['comment'] = entity.comment;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['flowTask'] = entity.flowTask?.toJson();
	return data;
}

RecordTaskFlowTask $RecordTaskFlowTaskFromJson(Map<String, dynamic> json) {
	final RecordTaskFlowTask recordTaskFlowTask = RecordTaskFlowTask();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		recordTaskFlowTask.id = id;
	}
	final String? nodeId = jsonConvert.convert<String>(json['nodeId']);
	if (nodeId != null) {
		recordTaskFlowTask.nodeId = nodeId;
	}
	final String? instanceId = jsonConvert.convert<String>(json['instanceId']);
	if (instanceId != null) {
		recordTaskFlowTask.instanceId = instanceId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		recordTaskFlowTask.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		recordTaskFlowTask.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		recordTaskFlowTask.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		recordTaskFlowTask.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		recordTaskFlowTask.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		recordTaskFlowTask.updateTime = updateTime;
	}
	final RecordTaskFlowTaskFlowNode? flowNode = jsonConvert.convert<RecordTaskFlowTaskFlowNode>(json['flowNode']);
	if (flowNode != null) {
		recordTaskFlowTask.flowNode = flowNode;
	}
	final RecordTaskFlowTaskFlowInstance? flowInstance = jsonConvert.convert<RecordTaskFlowTaskFlowInstance>(json['flowInstance']);
	if (flowInstance != null) {
		recordTaskFlowTask.flowInstance = flowInstance;
	}
	return recordTaskFlowTask;
}

Map<String, dynamic> $RecordTaskFlowTaskToJson(RecordTaskFlowTask entity) {
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

RecordTaskFlowTaskFlowNode $RecordTaskFlowTaskFlowNodeFromJson(Map<String, dynamic> json) {
	final RecordTaskFlowTaskFlowNode recordTaskFlowTaskFlowNode = RecordTaskFlowTaskFlowNode();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		recordTaskFlowTaskFlowNode.id = id;
	}
	final String? nodeType = jsonConvert.convert<String>(json['nodeType']);
	if (nodeType != null) {
		recordTaskFlowTaskFlowNode.nodeType = nodeType;
	}
	return recordTaskFlowTaskFlowNode;
}

Map<String, dynamic> $RecordTaskFlowTaskFlowNodeToJson(RecordTaskFlowTaskFlowNode entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['nodeType'] = entity.nodeType;
	return data;
}

RecordTaskFlowTaskFlowInstance $RecordTaskFlowTaskFlowInstanceFromJson(Map<String, dynamic> json) {
	final RecordTaskFlowTaskFlowInstance recordTaskFlowTaskFlowInstance = RecordTaskFlowTaskFlowInstance();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		recordTaskFlowTaskFlowInstance.id = id;
	}
	final String? defineId = jsonConvert.convert<String>(json['defineId']);
	if (defineId != null) {
		recordTaskFlowTaskFlowInstance.defineId = defineId;
	}
	final String? relationId = jsonConvert.convert<String>(json['relationId']);
	if (relationId != null) {
		recordTaskFlowTaskFlowInstance.relationId = relationId;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		recordTaskFlowTaskFlowInstance.title = title;
	}
	final String? contentType = jsonConvert.convert<String>(json['contentType']);
	if (contentType != null) {
		recordTaskFlowTaskFlowInstance.contentType = contentType;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		recordTaskFlowTaskFlowInstance.content = content;
	}
	final String? data = jsonConvert.convert<String>(json['data']);
	if (data != null) {
		recordTaskFlowTaskFlowInstance.data = data;
	}
	final String? hook = jsonConvert.convert<String>(json['hook']);
	if (hook != null) {
		recordTaskFlowTaskFlowInstance.hook = hook;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		recordTaskFlowTaskFlowInstance.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		recordTaskFlowTaskFlowInstance.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		recordTaskFlowTaskFlowInstance.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		recordTaskFlowTaskFlowInstance.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		recordTaskFlowTaskFlowInstance.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		recordTaskFlowTaskFlowInstance.updateTime = updateTime;
	}
	final RecordTaskFlowTaskFlowInstanceFlowRelation? flowRelation = jsonConvert.convert<RecordTaskFlowTaskFlowInstanceFlowRelation>(json['flowRelation']);
	if (flowRelation != null) {
		recordTaskFlowTaskFlowInstance.flowRelation = flowRelation;
	}
	return recordTaskFlowTaskFlowInstance;
}

Map<String, dynamic> $RecordTaskFlowTaskFlowInstanceToJson(RecordTaskFlowTaskFlowInstance entity) {
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

RecordTaskFlowTaskFlowInstanceFlowRelation $RecordTaskFlowTaskFlowInstanceFlowRelationFromJson(Map<String, dynamic> json) {
	final RecordTaskFlowTaskFlowInstanceFlowRelation recordTaskFlowTaskFlowInstanceFlowRelation = RecordTaskFlowTaskFlowInstanceFlowRelation();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.id = id;
	}
	final String? productId = jsonConvert.convert<String>(json['productId']);
	if (productId != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.productId = productId;
	}
	final String? functionCode = jsonConvert.convert<String>(json['functionCode']);
	if (functionCode != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.functionCode = functionCode;
	}
	final String? defineId = jsonConvert.convert<String>(json['defineId']);
	if (defineId != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.defineId = defineId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		recordTaskFlowTaskFlowInstanceFlowRelation.updateTime = updateTime;
	}
	return recordTaskFlowTaskFlowInstanceFlowRelation;
}

Map<String, dynamic> $RecordTaskFlowTaskFlowInstanceFlowRelationToJson(RecordTaskFlowTaskFlowInstanceFlowRelation entity) {
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