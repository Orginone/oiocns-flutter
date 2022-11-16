import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/market_resp_entity.dart';

MarketRespEntity $MarketRespEntityFromJson(Map<String, dynamic> json) {
	final MarketRespEntity marketRespEntity = MarketRespEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		marketRespEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		marketRespEntity.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		marketRespEntity.code = code;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		marketRespEntity.remark = remark;
	}
	final bool? public = jsonConvert.convert<bool>(json['public']);
	if (public != null) {
		marketRespEntity.public = public;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		marketRespEntity.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		marketRespEntity.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		marketRespEntity.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		marketRespEntity.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		marketRespEntity.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		marketRespEntity.updateTime = updateTime;
	}
	return marketRespEntity;
}

Map<String, dynamic> $MarketRespEntityToJson(MarketRespEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['remark'] = entity.remark;
	data['public'] = entity.public;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}