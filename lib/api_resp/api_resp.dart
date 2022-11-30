import 'package:fluttertoast/fluttertoast.dart';
import 'package:orginone/generated/json/base/json_field.dart';
import 'package:orginone/generated/json/api_resp.g.dart';
import 'dart:convert';

@JsonSerializable()
class ApiResp {
  late int code;
  late dynamic data;
  late String msg;
  late bool success;

  ApiResp();

  ApiResp.empty()
      : code = 404,
        msg = "",
        data = null,
        success = false;

  factory ApiResp.fromJson(Map<String, dynamic> json) => $ApiRespFromJson(json);

  Map<String, dynamic> toJson() => $ApiRespToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  dynamic getData() {
    if (code != 200) {
      throw Exception(msg);
    }
    return data;
  }
}
