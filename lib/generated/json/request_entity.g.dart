import 'package:orginone/generated/json/base/json_convert_content.dart';
import 'package:orginone/api_resp/request_entity.dart';

RequestEntity $RequestEntityFromJson(Map<String, dynamic> json) {
	final RequestEntity requestEntity = RequestEntity();
	final String? module = jsonConvert.convert<String>(json['module']);
	if (module != null) {
		requestEntity.module = module;
	}
	final String? action = jsonConvert.convert<String>(json['action']);
	if (action != null) {
		requestEntity.action = action;
	}
	final dynamic? params = jsonConvert.convert<dynamic>(json['params']);
	if (params != null) {
		requestEntity.params = params;
	}
	return requestEntity;
}

Map<String, dynamic> $RequestEntityToJson(RequestEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['module'] = entity.module;
	data['action'] = entity.action;
	data['params'] = entity.params;
	return data;
}