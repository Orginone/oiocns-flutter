import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';
import 'package:orginone/widget/loading_dialog.dart';

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
  late Function(ITarget) function;
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
      this.hidden,this.router,this.hint,this.select}){
    initData();
  }

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
    initData();
  }

  initData(){
    if (type == "input") {
      controller = TextEditingController();
    }
    function = (ITarget target) async{
      if (type == "router") {
        Get.toNamed(router!);
      }
      if (type == "select") {
        PickerUtils.showListStringPicker(Get.context!, titles: select!.values.toList(),
            callback: (str) {
              int index = select!.values.toList().indexOf(str);
              dynamic key = select!.keys.toList()[index];
              defaultData.value = {key: str};
            });
      }
      if(type == 'selectDate'){
        DatePicker.showDateTimePicker(Get.context!,currentTime: DateTime.now(),locale: LocaleType.zh,onConfirm: (date){
          defaultData.value = date.format(format: "yyyy-MM-dd HH:mm");
        });
      }
      if(type == 'selectPerson'){
        var users =  target.members;
        PickerUtils.showListStringPicker(Get.context!, titles: users.map((e) => e.name!).toList(),
            callback: (str) {
              defaultData.value = users.firstWhere((element) => element.name == str);
            });
      }
      if(type == 'selectDepartment'){
        List<ITarget> team = await settingCtrl.getTeamTree(settingCtrl.user);
        PickerUtils.showListStringPicker(Get.context!, titles: team.map((e) => e.metadata.name!).toList(),
            callback: (str) {
              defaultData.value = team.firstWhere((element) => element.metadata.name == str);
            });
      }
      if(type == 'upload'){
        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null) {
          LoadingDialog.showLoading(Get.context!);
          var docDir =  settingCtrl.user.directory;
          PlatformFile file = result.files.first;
          var file1 = File(file.path!);
          var item = await docDir.createFile(file1);
          if(item!=null){
            defaultData.value = item.metadata;
          }
          LoadingDialog.dismiss(Get.context!);
        }
      }
    };
  }



  Map<String,dynamic> toUploadJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[code!] = defaultData.value??"";
    if(code!.contains("Number")){
      data[code!] = int.tryParse(defaultData.value??"");
    }

    if(type == "select"){
      data[code!] = defaultData.value?.keys.first;
    }
    if(type == "selectDepartment" || type == 'selectDepartment'){
      data[code!] = defaultData.value.id;
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
    var value = assetsJson[code!];
    if (value != null) {
      defaultData.value = value;
    }
  }
}
