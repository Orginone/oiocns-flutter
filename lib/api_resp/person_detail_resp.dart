class PersonDetailResp {
  final String name;

  PersonDetailResp.fromMap(Map<String, dynamic> map)
      : name = map["name"];

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['name'] = name;
    return json;
  }
}
