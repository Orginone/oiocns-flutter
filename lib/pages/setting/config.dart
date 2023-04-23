

import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';

enum SpaceEnum {
  innerAgency("内部机构"),
  outAgency("外部机构"),
  stationSetting("岗位设置"),
  companyCohort("单位群组"),

  personGroup("个人群组"),
  standardSettings("标准设置"),
  cardbag("卡包"),
  security("安全"),
  dynamic("动态"),
  mark("收藏");

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
      case "标准设置":
        return SpaceEnum.standardSettings;
      default:
        return SpaceEnum.personGroup;
    }
  }
}

enum StandardEnum {
  permission("权限定义"),
  dict("字典定义"),
  attribute("属性定义"),
  classCriteria('分类定义');

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

List<String> ValueType = [
  '数值型',
  '描述型',
  '选择型',
  '分类型',
  '附件型',
  '日期型',
  '时间型',
  '用户型',
];

enum IdentityFunction {
  edit,
  delete,
  addMember,
}

enum CompanyFunction {
  roleSettings,
  addUser,
  addGroup,
}

enum UserFunction{
  record,
  addUser,
  addGroup,
}

List<IAuthority> getAllAuthority(List<IAuthority> authority) {
  List<IAuthority> list = [];
  for (var element in authority) {
    list.add(element);
    if (element.children.isNotEmpty) {
      list.addAll(getAllAuthority(element.children));
    }
  }
  return list;
}

List<IGroup> getAllOutAgency(List<IGroup> outAgencyGroup) {
  List<IGroup> list = [];
  for (var element in outAgencyGroup) {
    list.add(element);
    if (element.subGroup.isNotEmpty) {
      list.addAll(getAllOutAgency(element.subGroup));
    }
  }

  return list;
}
