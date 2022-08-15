class MessageCount {

  final int total;
  final List<dynamic> result;

  MessageCount(this.total, this.result);

  MessageCount.fromJson(Map<String, dynamic> map)
      : total = map['total'],
        result = map['result'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['result'] = result;
    return data;
  }
}
