import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/market_resp_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MarketRespEntity {

	late String id;
	late String name;
	late String code;
	late String remark;
	late bool public;
	late int status;
	late String createUser;
	late String updateUser;
	late String version;
	late String createTime;
	late String updateTime;
  
  MarketRespEntity();

  factory MarketRespEntity.fromJson(Map<String, dynamic> json) => $MarketRespEntityFromJson(json);

  Map<String, dynamic> toJson() => $MarketRespEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}