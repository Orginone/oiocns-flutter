


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class AddMembersState extends BaseGetState{
  late String title;

  var unitMember = <XTarget>[].obs;

  var selectAll = false.obs;
  AddMembersState(){
    title = Get.arguments['title'];
  }
}