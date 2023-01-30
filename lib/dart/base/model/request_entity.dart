import 'package:orginone/dart/base/model/generated/json/base/json_field.dart';
import 'dart:convert';

import 'package:orginone/dart/base/model/generated/json/request_entity.g.dart';

@JsonSerializable()
class RequestEntity {
  late String module;
  late String action;
  late dynamic params;

  RequestEntity();

  RequestEntity.from({
    required this.module,
    required this.action,
    required this.params,
  });

  factory RequestEntity.fromJson(Map<String, dynamic> json) =>
      $RequestEntityFromJson(json);

  Map<String, dynamic> toJson() => $RequestEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
