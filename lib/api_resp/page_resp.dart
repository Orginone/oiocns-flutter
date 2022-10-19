class PageResp {
  final int limit;
  final int total;
  final List<dynamic> result;

  PageResp(this.limit, this.total, this.result);

  PageResp.fromMap(Map<String, dynamic> map)
      : limit = map["limit"],
        total = map["total"] ?? 0,
        result = map["result"] ?? [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["limit"] = limit;
    json["total"] = total;
    json["result"] = result;
    return json;
  }
}
