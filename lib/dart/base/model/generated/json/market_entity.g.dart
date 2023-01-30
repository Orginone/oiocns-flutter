import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/core/base/model/market_entity.dart';

MarketEntity $MarketEntityFromJson(Map<String, dynamic> json) {
	final MarketEntity marketEntity = MarketEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		marketEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		marketEntity.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		marketEntity.code = code;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		marketEntity.remark = remark;
	}
	final bool? public = jsonConvert.convert<bool>(json['public']);
	if (public != null) {
		marketEntity.public = public;
	}
	final String? belongId = jsonConvert.convert<String>(json['belongId']);
	if (belongId != null) {
		marketEntity.belongId = belongId;
	}
	final String? samrId = jsonConvert.convert<String>(json['samrId']);
	if (samrId != null) {
		marketEntity.samrId = samrId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		marketEntity.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		marketEntity.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		marketEntity.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		marketEntity.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		marketEntity.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		marketEntity.updateTime = updateTime;
	}
	return marketEntity;
}

Map<String, dynamic> $MarketEntityToJson(MarketEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['remark'] = entity.remark;
	data['public'] = entity.public;
	data['belongId'] = entity.belongId;
	data['samrId'] = entity.samrId;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}