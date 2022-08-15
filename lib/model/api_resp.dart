class ApiResp {
  final int code;
  final String msg;
  final dynamic data;
  final bool success;

  ApiResp.fromJson(Map<String, dynamic> map)
      : code = map["code"],
        msg = map["msg"],
        data = map["data"],
        success = map["success"];

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['code'] = code;
    json['msg'] = msg;
    json['data'] = data;
    json['success'] = success;
    return json;
  }

  @override
  String toString() {
    return 'ApiResp{code: $code, msg: $msg, data: $data, success: $success}';
  }
}
