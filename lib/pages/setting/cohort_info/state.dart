


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