import 'dart:convert';

import 'package:orginone/dart/base/model/generated/json/base/json_field.dart';
import 'package:orginone/dart/base/model/generated/json/staging_entity.g.dart';
import 'package:orginone/dart/base/model/market_entity.dart';
import 'package:orginone/dart/base/model/merchandise_entity.dart';

@JsonSerializable()
class StagingEntity {

	late String id;
	late String merchandiseId;
	late String belongId;
	late String marketId;
	late String number;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
	late MarketEntity market;
	late MerchandiseEntity merchandise;
  
  StagingEntity();

  factory StagingEntity.fromJson(Map<String, dynamic> json) => $StagingEntityFromJson(json);

  Map<String, dynamic> toJson() => $StagingEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
