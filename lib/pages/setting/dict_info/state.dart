


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/setting/home/state.dart';

class DictInfoState extends BaseGetState{
  late SettingNavModel data;

  var dictItems = <XDictItem>[].obs;
  DictInfoState(){
    data = Get.arguments['data'];
  }
}