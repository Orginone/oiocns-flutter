


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class CohortInfoState extends BaseGetState{
  late ICohort cohort;
  var unitMember = <XTarget>[].obs;
  CohortInfoState(){
    cohort = Get.arguments['cohort'];
  }
}

List<String> memberTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];