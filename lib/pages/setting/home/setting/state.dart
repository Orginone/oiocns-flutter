

import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';




class SettingFunctionState extends BaseGetState{
  late ISpace space;

  late List<SpaceEnum> spaceEnum;

  SettingController get setting => Get.find<SettingController>();

  SettingFunctionState(){
    space = Get.arguments['space'];
    spaceEnum = [];
    if(setting.isCompanySpace()){
      spaceEnum.addAll([SpaceEnum.innerAgency,SpaceEnum.outAgency,SpaceEnum.stationSetting,SpaceEnum.companyCohort]);
    }else{
      spaceEnum.addAll([SpaceEnum.personGroup]);
    }
  }
}