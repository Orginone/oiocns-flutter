import 'package:json_annotation/json_annotation.dart';

part 'page_resp.g.dart';

@JsonSerializable()
class PageResp {
  final int limit;
  final int total;
  final List<dynamic> result;

  PageResp(this.limit, this.total, this.result);

  factory PageResp.fromMap(Map<String, dynamic> json) =>
      _$PageRespFromJson(json);

  Map<String, dynamic> toJson() => _$PageRespToJson(this);
}
