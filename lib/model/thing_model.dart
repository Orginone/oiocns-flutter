class ThingModel {
  String? id;
  String? creater;
  String? createTime;
  String? modifiedTime;
  String? status;
  bool isSelected = false;
  List<Map<String,dynamic>>? data;
  ThingModel(
      {this.id, this.creater, this.createTime, this.modifiedTime, this.status});

  ThingModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creater = json['Creater'];
    createTime = json['CreateTime'];
    modifiedTime = json['ModifiedTime'];
    status = json['Status'];
    data = [];
    json.keys.forEach((element) {
      if(element.length>15 && element.contains("S")){
        data!.add({
          element:json[element],
        });
      }
    });

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Creater'] = this.creater;
    data['CreateTime'] = this.createTime;
    data['ModifiedTime'] = this.modifiedTime;
    data['Status'] = this.status;
    return data;
  }
}
