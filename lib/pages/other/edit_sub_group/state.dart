


import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/subgroup.dart';

class EditSubGroupState extends BaseGetState{
  late Rx<SubGroup> subGroup;

  bool clickSave = false;

  EditSubGroupState(){
    subGroup = Rx(Get.arguments['subGroup']);
  }
}