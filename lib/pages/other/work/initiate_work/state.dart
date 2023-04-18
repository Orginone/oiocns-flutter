import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class InitiateWorkState extends BaseGetState {
  SettingController get settingCtrl => Get.find<SettingController>();
  late List<ISpace> spaces;

  InitiateWorkState(){
    var joinedCompanies = settingCtrl.user!.joinedCompany;
    spaces = <ISpace>[...joinedCompanies];
  }
}



List<String> personalWork = [
  "加好友",
  "加单位",
  "加群",
  "办事",
];
