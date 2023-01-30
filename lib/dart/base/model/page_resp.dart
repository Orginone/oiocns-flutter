class PageResp<T> {
  final int limit;
  final int total;
  final List<T> result;

  PageResp(this.limit, this.total, this.result);

  static PageResp<T> fromMap<T>(Map<String, dynamic> map, Function mapping) {
    int limit = map["limit"] ?? 0;
    int total = map["total"] ?? 0;
    List<dynamic> result = map["result"] ?? [];

    List<T> ans = result.map((item) => mapping(item) as T).toList();
    return PageResp<T>(limit, total, ans);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["limit"] = limit;
    json["total"] = total;
    json["result"] = result;
    return json;
  }
}
