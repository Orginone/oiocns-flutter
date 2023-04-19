

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SpaceEnum {
  innerAgency("内部机构"),
  outAgency("外部机构"),
  stationSetting("岗位设置"),
  companyCohort("单位群组"),

  personGroup("个人群组");


  final  String label;

  const SpaceEnum(this.label);

  static SpaceEnum findEnum(String label){
    switch(label){
      case "内部机构":
        return SpaceEnum.innerAgency;
      case "外部机构":
        return SpaceEnum.outAgency;
      case "岗位设置":
        return SpaceEnum.stationSetting;
      case "单位群组":
        return SpaceEnum.companyCohort;
      case "个人群组":
        return SpaceEnum.personGroup;
      default:
        return SpaceEnum.personGroup;
    }
  }
}

enum StandardEnum{
  permission("权限设置"),
  dict("字典设置"),
  form("表单设置"),
  classCriteria('分类标准');

  final String label;

  const StandardEnum(this.label);
}

const companySpace = [
  '内部机构',
  '外部机构',
  '岗位设置',
  '单位群组',
];


List<String> memberTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];

List<String> spaceTitle = [
  "单位简称",
  "社会统一信用代码",
  "单位全称",
  "单位代码",
  "单位简介",
];

List<String> groupTitle = [
  "集团简称",
  "集团编码",
  "集团全称",
  "集团代码",
  "集团简介",
];

List<String> outGroupTitle = [
  "单位简称",
  "社会统一信用",
  "单位全称",
  "单位代码",
  "单位简介",
];


List<String> identityTitle = [
  "ID",
  "角色编号",
  "角色名称",
  "权限",
  "组织",
  "备注",
];

enum IdentityFunction{
  edit,
  delete,
  addMember,
}

enum CompanyFunction{
  roleSettings,
  addUser,
  addGroup,
}

enum UserFunction{
  record,
  addUser,
  addGroup,
}

