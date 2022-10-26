import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/api_resp.dart';

ApiResp $ApiRespFromJson(Map<String, dynamic> json) {
	final ApiResp apiResp = ApiResp();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		apiResp.code = code;
	}
	final dynamic? data = jsonConvert.convert<dynamic>(json['data']);
	if (data != null) {
		apiResp.data = data;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		apiResp.msg = msg;
	}
	final bool? success = jsonConvert.convert<bool>(json['success']);
	if (success != null) {
		apiResp.success = success;
	}
	return apiResp;
}

Map<String, dynamic> $ApiRespToJson(ApiResp entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['data'] = entity.data;
	data['msg'] = entity.msg;
	data['success'] = entity.success;
	return data;
}