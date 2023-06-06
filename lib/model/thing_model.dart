import 'dart:math';

import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';

class ThingModel {
  String? id;
  String? creater;
  String? createrName;
  String? createTime;
  String? modifiedTime;
  String? status;
  bool isSelected = false;
  List<Map<String,dynamic>>? data;

  Map<String, dynamic>? eidtInfo = {};
  ThingModel(
      {this.id, this.creater, this.createTime, this.modifiedTime, this.status,this.eidtInfo =const {},this.data = const []});

  ThingModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creater = json['Creater'];

    SettingController setting = Get.find();
    setting.user.findShareById(creater??"").then((value){
      createrName = value.name;
    });
    createTime = json['CreateTime'];
    modifiedTime = json['ModifiedTime'];
    status = json['Status'];
    eidtInfo = json['EDIT_INFO']??{};
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
    data['EDIT_INFO'] = this.eidtInfo;
    return data;
  }
}
