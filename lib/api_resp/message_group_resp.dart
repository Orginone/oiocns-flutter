import 'package:json_annotation/json_annotation.dart';

part 'message_group_resp.g.dart';

@JsonSerializable()
class MessageGroupResp {
  int id;
  String name;
  List<dynamic> chats;

  MessageGroupResp(this.id, this.name, this.chats);

  factory MessageGroupResp.fromMap(Map<String, dynamic> json) =>
      _$MessageGroupRespFromJson(json);

  Map<String, dynamic> toJson() => _$MessageGroupRespToJson(this);
}
