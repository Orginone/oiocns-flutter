import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';

class AssetCreationConfig {
  String? businessName;
  String? businessCode;
  List<Config>? config;

  AssetCreationConfig({this.businessName, this.businessCode, this.config});

  AssetCreationConfig.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    businessCode = json['businessCode'];
    if (json['text'] != null) {
      config = <Config>[];
      json['text'].forEach((v) {
        config!.add(Config.fromJson(v));
      });
    }
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['businessCode'] = this.businessCode;
    if (this.config != null) {
      data['text1'] = this.config!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Config {
  String? title;
  int? sort;
  List<Fields>? fields;

  Config({this.title, this.sort, this.fields});

  Config.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sort = json['sort'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sort'] = this.sort;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool hasFilled(){
    return fields!.where((element) => element.required! && element.defaultData.value != null).isNotEmpty;
  }

  Config toNewConfig() {
    return Config.fromJson(toJson());
  }
}

class Fields {
  String? title;
  String? hint;
  String? code;
  String? type;
  bool? required;
  bool? readOnly;
  String? regx;
  Map<String, dynamic>? select;
  bool? hidden;
  int? maxLine;
  Rxn<dynamic> defaultData = Rxn<dynamic>();
  TextEditingController? controller;
  VoidCallback? function;
  double? marginTop;
  double? marginBottom;
  double? marginLeft;
  double? marginRight;
  String? router;

  Fields(
      {this.title,
      this.code,
      this.type,
      this.required,
      this.readOnly,
      this.regx,
      this.hidden});

  Fields.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    type = json['type'];
    required = json['required'];
    readOnly = json['readOnly'];
    regx = json['regx'];
    hidden = json['hidden'];
    maxLine = json['maxLine'];
    marginTop = json['marginTop'];
    marginBottom = json['marginBottom'];
    marginLeft = json['marginLeft'];
    marginRight = json['marginRight'];
    hint = json['hint'];
    router = json['router'];
    select = json['select'];
    if (type == "input") {
      controller = TextEditingController();
    }
    if (code == "USE_DEPT_NAME") {
      defaultData.value = DepartmentManagement().currentDepartment?.name??"个人中心";
    }
    if (code == "USER_NAME") {
      defaultData.value = HiveUtils.getUser()?.userName;
    }
  }

  bool get isBillCode => code == "BILL_CODE";


  Map<String,dynamic> toUploadJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[code!] = defaultData.value??"";
    if(code == "ASSET_TYPE"){
      data[code!] = defaultData.value?.name;
    } else if(code == "USER_NAME"){
      data["USER"] = HiveUtils.getUser()?.person?.id;
    }else if(code == "USE_DEPT_NAME"){
      data["USE_DEPT"] = DepartmentManagement().currentDepartment?.id;
    }else if(type == "select"){
      data[code!] = defaultData.value?.values.first;
    }
    return data;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['code'] = this.code;
    data['type'] = this.type;
    data['required'] = this.required;
    data['readOnly'] = this.readOnly;
    data['regx'] = this.regx;
    data['hidden'] = this.hidden;
    data['maxLine'] = maxLine;
    data['hint'] = hint;
    data['select'] = select;
    data['defaultData'] = defaultData;
    data['controller'] = controller;
    data['function'] = function;
    data['marginTop'] = marginTop;
    data['marginBottom'] = marginBottom;
    data['marginLeft'] = marginLeft;
    data['marginRight'] = marginRight;
    data['router'] = router;
    return data;
  }
}
