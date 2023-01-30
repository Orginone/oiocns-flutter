import 'dart:convert';

import 'package:orginone/dart/base/model/generated/json/base/json_field.dart';
import 'package:orginone/dart/base/model/generated/json/merchandise_entity.g.dart';

@JsonSerializable()
class MerchandiseEntity {
  late String id;
  late String caption;
  late String productId;
  int? price;
  late String sellAuth;
  late String marketId;
  late int status;
  late String createUser;
  late String updateUser;
  late String version;
  late String createTime;
  late String updateTime;
  late MerchandiseProduct product;

  MerchandiseEntity();

  factory MerchandiseEntity.fromJson(Map<String, dynamic> json) =>
      $MerchandiseEntityFromJson(json);

  Map<String, dynamic> toJson() => $MerchandiseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MerchandiseProduct {
  late String id;
  late String name;
  late String code;
  @JSONField(name: "source")
  String? xSource;
  late String authority;
  late String typeName;
  late String belongId;
  late String thingId;
  String? remark;
  late int status;
  late String createUser;
  late String updateUser;
  late String version;
  late String createTime;
  late String updateTime;

  MerchandiseProduct();

  factory MerchandiseProduct.fromJson(Map<String, dynamic> json) =>
      $MerchandiseProductFromJson(json);

  Map<String, dynamic> toJson() => $MerchandiseProductToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
