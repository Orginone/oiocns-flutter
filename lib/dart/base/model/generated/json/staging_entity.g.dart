import 'package:orginone/dart/base/model/generated/json/base/json_convert_content.dart';
import 'package:orginone/dart/base/model/market_entity.dart';
import 'package:orginone/dart/base/model/merchandise_entity.dart';
import 'package:orginone/dart/base/model/staging_entity.dart';

StagingEntity $StagingEntityFromJson(Map<String, dynamic> json) {
  final StagingEntity stagingEntity = StagingEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    stagingEntity.id = id;
  }
  final String? merchandiseId =
      jsonConvert.convert<String>(json['merchandiseId']);
  if (merchandiseId != null) {
    stagingEntity.merchandiseId = merchandiseId;
  }
  final String? belongId = jsonConvert.convert<String>(json['belongId']);
  if (belongId != null) {
    stagingEntity.belongId = belongId;
  }
  final String? marketId = jsonConvert.convert<String>(json['marketId']);
  if (marketId != null) {
    stagingEntity.marketId = marketId;
  }
  final String? number = jsonConvert.convert<String>(json['number']);
  if (number != null) {
    stagingEntity.number = number;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    stagingEntity.status = status;
  }
  final String? createUser = jsonConvert.convert<String>(json['createUser']);
  if (createUser != null) {
    stagingEntity.createUser = createUser;
  }
  final String? updateUser = jsonConvert.convert<String>(json['updateUser']);
  if (updateUser != null) {
    stagingEntity.updateUser = updateUser;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    stagingEntity.version = version;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    stagingEntity.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    stagingEntity.updateTime = updateTime;
  }
  final MarketEntity? market =
      jsonConvert.convert<MarketEntity>(json['market']);
  if (market != null) {
    stagingEntity.market = market;
  }
  final MerchandiseEntity? merchandise =
      jsonConvert.convert<MerchandiseEntity>(json['merchandise']);
  if (merchandise != null) {
    stagingEntity.merchandise = merchandise;
  }
  return stagingEntity;
}

Map<String, dynamic> $StagingEntityToJson(StagingEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['merchandiseId'] = entity.merchandiseId;
  data['belongId'] = entity.belongId;
  data['marketId'] = entity.marketId;
  data['number'] = entity.number;
  data['status'] = entity.status;
  data['createUser'] = entity.createUser;
  data['updateUser'] = entity.updateUser;
  data['version'] = entity.version;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['market'] = entity.market.toJson();
  data['merchandise'] = entity.merchandise.toJson();
  return data;
}
