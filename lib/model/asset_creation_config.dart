import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:hive/hive.dart';
part 'asset_creation_config.g.dart';

@HiveType(typeId: 4)
class AssetCreationConfig {
  @HiveField(0)
  String? businessName;
  @HiveField(1)
  String? businessCode;
  @HiveField(2)
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

@HiveType(typeId: 5)
class Config {
  @HiveField(0)
  String? title;
  @HiveField(1)
  int? sort;
  @HiveField(2)
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

@HiveType(typeId: 6)
class Fields {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? hint;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? type;
  @HiveField(4)
  bool? required;
  @HiveField(5)
  bool? readOnly;
  @HiveField(6)
  String? regx;
  @HiveField(7)
  Map<dynamic, String>? select;
  @HiveField(8)
  bool? hidden;
  @HiveField(9)
  int? maxLine;
  Rxn<dynamic> defaultData = Rxn<dynamic>();
  TextEditingController? controller;
  VoidCallback? function;
  @HiveField(10)
  double? marginTop;
  @HiveField(11)
  double? marginBottom;
  @HiveField(12)
  double? marginLeft;
  @HiveField(13)
  double? marginRight;
  @HiveField(14)
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
    if(code!.contains("Number")){
      data[code!] = int.tryParse(defaultData.value??"");
    }

    if(code == "ASSET_TYPE"){
      data[code!] = defaultData.value?.name;
    } else if(code == "USER_NAME"){
      data["USER"] = HiveUtils.getUser()?.person?.id;
    }else if(code == "USE_DEPT_NAME"){
      data["USE_DEPT"] = DepartmentManagement().currentDepartment?.id;
    }else if(type == "select"){
      data[code!] = defaultData.value?.keys.first;
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

  void initDefaultData(Map<String,dynamic> assetsJson) {
    defaultData.value = assetsJson[code!];
    if (code == "ASSET_TYPE") {
      defaultData.value = CommonTreeManagement().findCategoryTree(assetsJson[code!]??"");
    } else if((code == "SFXC" || code == "DISPOSE_TYPE" || code == "IS_SYS_UNIT" || code == "evaluated") && assetsJson[code!]!=null){
      dynamic key = assetsJson[code!];
      dynamic value = select![assetsJson[code!]];
      defaultData.value = {key:value};
    }else {
      defaultData.value = assetsJson[code!];
    }
  }
}
