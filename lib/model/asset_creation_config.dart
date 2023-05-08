import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

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
  late VoidCallback function;
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
    SettingController setting = Get.find();
    if (type == "input") {
      controller = TextEditingController();
    }
    if ((code == "USE_DEPT_NAME" || code == "OLD_ORG_NAME") && type == "text") {
      defaultData.value =
          DepartmentManagement().currentDepartment?.name ?? "个人中心";
    }
    if ((code == "USER_NAME" ||
        code == "OLD_USER_NAME" ||
        code == "SUBMITTER_NAME") &&
        type == "text") {
      defaultData.value = HiveUtils.getUser()?.person?.team?.name;
    }
    function = () async{
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
        var users = await setting.user.loadMembers(PageRequest(offset: 0, limit: 10000, filter: ''));
        PickerUtils.showListStringPicker(Get.context!, titles: users.map((e) => e.name).toList(),
            callback: (str) {
              defaultData.value = users.firstWhere((element) => element.name == str);
            });
      }
      if(type == 'selectDepartment'){
        List<ITarget> team = await setting.getTeamTree(setting.user);
        PickerUtils.showListStringPicker(Get.context!, titles: team.map((e) => e.teamName).toList(),
            callback: (str) {
              defaultData.value = team.firstWhere((element) => element.teamName == str);
            });
      }
    };
  }

  bool get isBillCode => code == "BILL_CODE";


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
    switch (code) {
      case "ASSET_TYPE":
        data[code!] = defaultData.value?.name;
        break;
      case "USER_NAME":
      case "SUBMITTER_NAME":
        if (type == "text") {
          data["USER"] = HiveUtils.getUser()?.person?.id;
        } else {
          data["USER"] = defaultData.value?.id;
          data["USER_NAME"] = defaultData.value?.name;
        }
        break;
      case 'OLD_USER_NAME':
        data["OLD_USER_ID"] = HiveUtils.getUser()?.person?.id;
        break;
      case "USE_DEPT_NAME":
        data["USE_DEPT"] = DepartmentManagement().currentDepartment?.id;
        break;
      case "OLD_ORG_NAME":
        data['OLD_ORG_ID'] = DepartmentManagement().currentDepartment?.id;
        break;
      case "KEEPER_NAME":
        data['KEEPER_NAME'] = defaultData.value?.name;
        data['KEEPER_ID'] = defaultData.value?.id;
        break;
      case 'KEEP_ORG_NAME':
        data['KEEP_ORG_NAME'] = defaultData.value?.name;
        data['KEEP_ORG_ID'] = defaultData.value?.id;
        break;
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
    switch (code) {
      case "ASSET_TYPE":
        defaultData.value =
            CommonTreeManagement().findCategoryTree(assetsJson[code!] ?? "");
        break;
      case "SFXC":
      case "DISPOSE_TYPE":
      case "IS_SYS_UNIT":
      case "evaluated":
        if (assetsJson[code!] != null) {
          dynamic key = assetsJson[code!];
          dynamic value = select![assetsJson[code!]];
          defaultData.value = {key: value};
        }
        break;
      case "KEEPER_NAME":
        defaultData.value = DepartmentManagement()
            .findXTargetByIdOrName(id: assetsJson['KEEPER_ID']);
        break;
      case "KEEP_ORG_NAME":
        defaultData.value = DepartmentManagement()
            .findITargetByIdOrName(id: assetsJson['KEEP_ORG_ID']);
        break;
      case "USER_NAME":
        if (type != "text") {
          defaultData.value = DepartmentManagement()
              .findXTargetByIdOrName(name: assetsJson['USER_NAME']);
        }
        break;
    }
  }
}
