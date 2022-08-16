// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_group_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageGroupResp _$MessageGroupRespFromJson(Map<String, dynamic> json) =>
    MessageGroupResp(
      json['id'] as int,
      json['name'] as String,
      json['chats'] as List<dynamic>,
    );

Map<String, dynamic> _$MessageGroupRespToJson(MessageGroupResp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chats': instance.chats,
    };
