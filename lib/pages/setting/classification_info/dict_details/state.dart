


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/dict.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class DictDetailsState extends BaseGetState{
  late Dict dict;
  var dictItem = <XDictItem>[].obs;

  RefreshController refreshController = RefreshController();

  SettingController  setting = Get.find<SettingController>();
  DictDetailsState(){
   XDict xDict = Get.arguments['dict'];
   dict = Dict(xDict);
  }
}