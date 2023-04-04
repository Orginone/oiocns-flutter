


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/dict.dart';



class DictDetailsState extends BaseGetState{
  late Dict dict;
  var dictItem = <XDictItem>[].obs;

  SettingController  setting = Get.find<SettingController>();
  DictDetailsState(){
   XDict xDict = Get.arguments['dict'];
   dict = Dict(xDict);
  }
}