// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResp _$ApiRespFromJson(Map<String, dynamic> json) => ApiResp(
      json['code'] as int,
      json['msg'] as String,
      json['data'],
      json['success'] as bool,
    );

Map<String, dynamic> _$ApiRespToJson(ApiResp instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success,
    };
