

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
    spaceEnum = [SpaceEnum.standardSettings];
    if(setting.isUserSpace(space: space)){
      spaceEnum.addAll([SpaceEnum.cardbag,SpaceEnum.security,SpaceEnum.dynamic,SpaceEnum.mark,SpaceEnum.personGroup]);
    }else{
      spaceEnum.addAll([SpaceEnum.innerAgency,SpaceEnum.outAgency,SpaceEnum.stationSetting,SpaceEnum.companyCohort]);
    }
  }
}