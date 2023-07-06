import 'dart:math';

import 'package:get/get.dart';
import 'package:orginone/main.dart';

class ThingModel {
  String? id;
  String? creater;
  String? createrName;
  String? createTime;
  String? modifiedTime;
  String? status;

  bool isSelected = false;

  Map<String, dynamic> eidtInfo = {};
  Map<String, dynamic> propertys = {};
  Map<String, dynamic> species = {};
  ThingModel(
      {this.id, this.creater, this.createTime, this.modifiedTime, this.status,this.eidtInfo =const {}});

  ThingModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creater = json['Creater'];

    settingCtrl.user.findShareById(creater??"").then((value){
      createrName = value.name;
    });
    createTime = json['CreateTime'];
    modifiedTime = json['ModifiedTime'];
    status = json['Status'];
    species = json['Species']??{};
    propertys = json['Propertys']??{};
    eidtInfo = json['EDIT_INFO']??{};
    json.keys.forEach((element) {
      if(element.length>15){
        eidtInfo[element] = json[element];
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['Creater'] = creater;
    data['CreateTime'] = createTime;
    data['ModifiedTime'] = modifiedTime;
    data['Status'] = status;
    data['EDIT_INFO'] = eidtInfo;
    data['Propertys'] = propertys;
    data['Species'] = species;
    return data;
  }
}
