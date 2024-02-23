class TransactionRecord {
  int? blocktime;
  String? fee;
  String? from;
  int? height;
  String? note;
  String? status;
  String? to;
  String? txid;
  String? type;
  String? value;

  TransactionRecord(
      {this.blocktime,
      this.fee,
      this.from,
      this.height,
      this.note,
      this.status,
      this.to,
      this.txid,
      this.type,
      this.value});

  TransactionRecord.fromJson(Map<String, dynamic> json) {
    blocktime = json['blocktime'];
    fee = json['fee'];
    from = json['from'];
    height = json['height'];
    note = json['note'];
    status = json['status'];
    to = json['to'];
    txid = json['txid'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blocktime'] = blocktime;
    data['fee'] = fee;
    data['from'] = from;
    data['height'] = height;
    data['note'] = note;
    data['status'] = status;
    data['to'] = to;
    data['txid'] = txid;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
