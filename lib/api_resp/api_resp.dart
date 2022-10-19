import 'package:json_annotation/json_annotation.dart';

part 'api_resp.g.dart';

@JsonSerializable()
class ApiResp {
  final int code;
  final String msg;
  final dynamic data;
  final bool success;

  ApiResp(this.code, this.msg, this.data, this.success);

  factory ApiResp.fromMap(Map<String, dynamic> json) => _$ApiRespFromJson(json);

  ApiResp.empty()
      : code = 404,
        msg = "",
        data = null,
        success = false;

  Map<String, dynamic> toJson() => _$ApiRespToJson(this);

  @override
  String toString() {
    return 'ApiResp{code: $code, msg: $msg, data: $data, success: $success}';
  }
}
