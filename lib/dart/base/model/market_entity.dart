import 'package:orginone/dart/base/model/generated/json/base/json_field.dart';
import 'dart:convert';

import 'package:orginone/dart/base/model/generated/json/market_entity.g.dart';

@JsonSerializable()
class MarketEntity {
  late String id;
  late String name;
  late String code;
  late String remark;
  bool? public;
  String? belongId;
  String? samrId;
  late int status;
  late String createUser;
  late String updateUser;
  late String version;
  late String createTime;
  late String updateTime;

  MarketEntity();

  factory MarketEntity.fromJson(Map<String, dynamic> json) =>
      $MarketEntityFromJson(json);

  Map<String, dynamic> toJson() => $MarketEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
