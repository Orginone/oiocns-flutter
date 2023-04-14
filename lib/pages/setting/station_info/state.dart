

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

