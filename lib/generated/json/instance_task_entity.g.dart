import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/instance_task_entity.dart';

InstanceTaskEntity $InstanceTaskEntityFromJson(Map<String, dynamic> json) {
	final InstanceTaskEntity instanceTaskEntity = InstanceTaskEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		instanceTaskEntity.id = id;
	}
	final String? defineId = jsonConvert.convert<String>(json['defineId']);
	if (defineId != null) {
		instanceTaskEntity.defineId = defineId;
	}
	final String? relationId = jsonConvert.convert<String>(json['relationId']);
	if (relationId != null) {
		instanceTaskEntity.relationId = relationId;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		instanceTaskEntity.title = title;
	}
	final String? contentType = jsonConvert.convert<String>(json['contentType']);
	if (contentType != null) {
		instanceTaskEntity.contentType = contentType;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		instanceTaskEntity.content = content;
	}
	final String? data = jsonConvert.convert<String>(json['data']);
	if (data != null) {
		instanceTaskEntity.data = data;
	}
	final String? hook = jsonConvert.convert<String>(json['hook']);
	if (hook != null) {
		instanceTaskEntity.hook = hook;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		instanceTaskEntity.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		instanceTaskEntity.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		instanceTaskEntity.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		instanceTaskEntity.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		instanceTaskEntity.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		instanceTaskEntity.updateTime = updateTime;
	}
	final List<InstanceTaskFlowTasks>? flowTasks = jsonConvert.convertListNotNull<InstanceTaskFlowTasks>(json['flowTasks']);
	if (flowTasks != null) {
		instanceTaskEntity.flowTasks = flowTasks;
	}
	final InstanceTaskFlowDefine? flowDefine = jsonConvert.convert<InstanceTaskFlowDefine>(json['flowDefine']);
	if (flowDefine != null) {
		instanceTaskEntity.flowDefine = flowDefine;
	}
	final InstanceTaskFlowRelation? flowRelation = jsonConvert.convert<InstanceTaskFlowRelation>(json['flowRelation']);
	if (flowRelation != null) {
		instanceTaskEntity.flowRelation = flowRelation;
	}
	return instanceTaskEntity;
}

Map<String, dynamic> $InstanceTaskEntityToJson(InstanceTaskEntity entity) {
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
	data['flowTasks'] =  entity.flowTasks?.map((v) => v.toJson()).toList();
	data['flowDefine'] = entity.flowDefine?.toJson();
	data['flowRelation'] = entity.flowRelation?.toJson();
	return data;
}

InstanceTaskFlowTasks $InstanceTaskFlowTasksFromJson(Map<String, dynamic> json) {
	final InstanceTaskFlowTasks instanceTaskFlowTasks = InstanceTaskFlowTasks();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		instanceTaskFlowTasks.id = id;
	}
	final String? nodeId = jsonConvert.convert<String>(json['nodeId']);
	if (nodeId != null) {
		instanceTaskFlowTasks.nodeId = nodeId;
	}
	final String? instanceId = jsonConvert.convert<String>(json['instanceId']);
	if (instanceId != null) {
		instanceTaskFlowTasks.instanceId = instanceId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		instanceTaskFlowTasks.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		instanceTaskFlowTasks.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		instanceTaskFlowTasks.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		instanceTaskFlowTasks.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		instanceTaskFlowTasks.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		instanceTaskFlowTasks.updateTime = updateTime;
	}
	return instanceTaskFlowTasks;
}

Map<String, dynamic> $InstanceTaskFlowTasksToJson(InstanceTaskFlowTasks entity) {
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
	return data;
}

InstanceTaskFlowDefine $InstanceTaskFlowDefineFromJson(Map<String, dynamic> json) {
	final InstanceTaskFlowDefine instanceTaskFlowDefine = InstanceTaskFlowDefine();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		instanceTaskFlowDefine.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		instanceTaskFlowDefine.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		instanceTaskFlowDefine.code = code;
	}
	final String? belongId = jsonConvert.convert<String>(json['belongId']);
	if (belongId != null) {
		instanceTaskFlowDefine.belongId = belongId;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		instanceTaskFlowDefine.content = content;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		instanceTaskFlowDefine.remark = remark;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		instanceTaskFlowDefine.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		instanceTaskFlowDefine.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		instanceTaskFlowDefine.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		instanceTaskFlowDefine.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		instanceTaskFlowDefine.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		instanceTaskFlowDefine.updateTime = updateTime;
	}
	return instanceTaskFlowDefine;
}

Map<String, dynamic> $InstanceTaskFlowDefineToJson(InstanceTaskFlowDefine entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['belongId'] = entity.belongId;
	data['content'] = entity.content;
	data['remark'] = entity.remark;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}

InstanceTaskFlowRelation $InstanceTaskFlowRelationFromJson(Map<String, dynamic> json) {
	final InstanceTaskFlowRelation instanceTaskFlowRelation = InstanceTaskFlowRelation();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		instanceTaskFlowRelation.id = id;
	}
	final String? productId = jsonConvert.convert<String>(json['productId']);
	if (productId != null) {
		instanceTaskFlowRelation.productId = productId;
	}
	final String? functionCode = jsonConvert.convert<String>(json['functionCode']);
	if (functionCode != null) {
		instanceTaskFlowRelation.functionCode = functionCode;
	}
	final String? defineId = jsonConvert.convert<String>(json['defineId']);
	if (defineId != null) {
		instanceTaskFlowRelation.defineId = defineId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		instanceTaskFlowRelation.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		instanceTaskFlowRelation.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		instanceTaskFlowRelation.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		instanceTaskFlowRelation.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		instanceTaskFlowRelation.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		instanceTaskFlowRelation.updateTime = updateTime;
	}
	return instanceTaskFlowRelation;
}

Map<String, dynamic> $InstanceTaskFlowRelationToJson(InstanceTaskFlowRelation entity) {
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