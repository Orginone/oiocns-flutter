
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blocktime'] = this.blocktime;
    data['fee'] = this.fee;
    data['from'] = this.from;
    data['height'] = this.height;
    data['note'] = this.note;
    data['status'] = this.status;
    data['to'] = this.to;
    data['txid'] = this.txid;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
