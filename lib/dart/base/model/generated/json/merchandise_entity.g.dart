import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';

MerchandiseEntity $MerchandiseEntityFromJson(Map<String, dynamic> json) {
	final MerchandiseEntity merchandiseEntity = MerchandiseEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		merchandiseEntity.id = id;
	}
	final String? caption = jsonConvert.convert<String>(json['caption']);
	if (caption != null) {
		merchandiseEntity.caption = caption;
	}
	final String? productId = jsonConvert.convert<String>(json['productId']);
	if (productId != null) {
		merchandiseEntity.productId = productId;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		merchandiseEntity.price = price;
	}
	final String? sellAuth = jsonConvert.convert<String>(json['sellAuth']);
	if (sellAuth != null) {
		merchandiseEntity.sellAuth = sellAuth;
	}
	final String? marketId = jsonConvert.convert<String>(json['marketId']);
	if (marketId != null) {
		merchandiseEntity.marketId = marketId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		merchandiseEntity.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		merchandiseEntity.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		merchandiseEntity.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		merchandiseEntity.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		merchandiseEntity.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		merchandiseEntity.updateTime = updateTime;
	}
	final MerchandiseProduct? product = jsonConvert.convert<MerchandiseProduct>(json['product']);
	if (product != null) {
		merchandiseEntity.product = product;
	}
	return merchandiseEntity;
}

Map<String, dynamic> $MerchandiseEntityToJson(MerchandiseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['caption'] = entity.caption;
	data['productId'] = entity.productId;
	data['price'] = entity.price;
	data['sellAuth'] = entity.sellAuth;
	data['marketId'] = entity.marketId;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	data['product'] = entity.product.toJson();
	return data;
}

MerchandiseProduct $MerchandiseProductFromJson(Map<String, dynamic> json) {
	final MerchandiseProduct merchandiseProduct = MerchandiseProduct();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		merchandiseProduct.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		merchandiseProduct.name = name;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		merchandiseProduct.code = code;
	}
	final String? xSource = jsonConvert.convert<String>(json['source']);
	if (xSource != null) {
		merchandiseProduct.xSource = xSource;
	}
	final String? authority = jsonConvert.convert<String>(json['authority']);
	if (authority != null) {
		merchandiseProduct.authority = authority;
	}
	final String? typeName = jsonConvert.convert<String>(json['typeName']);
	if (typeName != null) {
		merchandiseProduct.typeName = typeName;
	}
	final String? belongId = jsonConvert.convert<String>(json['belongId']);
	if (belongId != null) {
		merchandiseProduct.belongId = belongId;
	}
	final String? thingId = jsonConvert.convert<String>(json['thingId']);
	if (thingId != null) {
		merchandiseProduct.thingId = thingId;
	}
	final String? remark = jsonConvert.convert<String>(json['remark']);
	if (remark != null) {
		merchandiseProduct.remark = remark;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		merchandiseProduct.status = status;
	}
	final String? createUser = jsonConvert.convert<String>(json['createUser']);
	if (createUser != null) {
		merchandiseProduct.createUser = createUser;
	}
	final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
	if (updateUser != null) {
		merchandiseProduct.updateUser = updateUser;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		merchandiseProduct.version = version;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		merchandiseProduct.createTime = createTime;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		merchandiseProduct.updateTime = updateTime;
	}
	return merchandiseProduct;
}

Map<String, dynamic> $MerchandiseProductToJson(MerchandiseProduct entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['source'] = entity.xSource;
	data['authority'] = entity.authority;
	data['typeName'] = entity.typeName;
	data['belongId'] = entity.belongId;
	data['thingId'] = entity.thingId;
	data['remark'] = entity.remark;
	data['status'] = entity.status;
	data['createUser'] = entity.createUser;
	data['updateUser'] = entity.updateUser;
	data['version'] = entity.version;
	data['createTime'] = entity.createTime;
	data['updateTime'] = entity.updateTime;
	return data;
}