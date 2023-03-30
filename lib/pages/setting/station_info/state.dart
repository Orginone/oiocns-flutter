

import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class StationInfoState extends BaseGetState{
  late IStation station;

  var identitys = <XIdentity>[].obs;

  var unitMember = <XTarget>[].obs;
  StationInfoState(){
    station = Get.arguments['station'];
  }
}

List<String> identityTitle = [
  "ID",
  "角色编号",
  "角色名称",
  "权限",
  "组织",
  "备注",
];

List<String> memberTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];