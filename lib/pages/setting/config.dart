

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CompanySpaceEnum {
  company('单位'),
  innerAgency("内部机构"),
  outAgency("外部机构"),
  stationSetting("岗位设置"),
  companyCohort("单位群组");

  final  String label;

  const CompanySpaceEnum(this.label);

  static CompanySpaceEnum findEnum(String label){
    switch(label){
      case "内部机构":
        return CompanySpaceEnum.innerAgency;
      case "外部机构":
        return CompanySpaceEnum.outAgency;
      case "岗位设置":
        return CompanySpaceEnum.stationSetting;
      case "单位群组":
        return CompanySpaceEnum.companyCohort;
      default:
        return CompanySpaceEnum.company;
    }
  }
}


enum UserSpaceEnum{
  personInfo('个人信息'),
  personGroup("个人群组");

  final String label;

  const UserSpaceEnum(this.label);
}

enum StandardEnum{
  permissionCriteria("权限标准"),
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

