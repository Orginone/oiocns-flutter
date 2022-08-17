// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResp _$PageRespFromJson(Map<String, dynamic> json) => PageResp(
      json['limit'] as int,
      json['total'] as int,
      json['result'] as List<dynamic>,
    );

Map<String, dynamic> _$PageRespToJson(PageResp instance) => <String, dynamic>{
      'limit': instance.limit,
      'total': instance.total,
      'result': instance.result,
    };
