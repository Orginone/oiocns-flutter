class PersonDetailResp {
  final String id;
  final String nickName;
  // team 里面有 name,code,remark等字段
  final Map<String,dynamic> team;

  PersonDetailResp.fromMap(Map<String, dynamic> map)
      : nickName = map["name"],
        id = map["id"],
        team = map["team"]
  ;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['nickName'] = nickName;
    json['id'] = id;
    json['team'] = team;
    return json;
  }
}
