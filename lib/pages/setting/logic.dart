import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/model/subgroup_config.dart';
import 'package:orginone/util/hive_utils.dart';
import 'state.dart';

class SettingController extends BaseSubmenuController<SettingState> {
  final SettingState state = SettingState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    [
      FrequentlyUsed(
        id: "addPerson",
        name: "加好友",
        avatar:  Ionicons.add,
      ),
      FrequentlyUsed(
        id: "createGroup",
        name: "建群组",
        avatar: Ionicons.create,
      ),
      FrequentlyUsed(
        id: "addGroup",
        name: "加群组",
        avatar: Ionicons.add,
      ),
      FrequentlyUsed(
        id: "createCompany",
        name: "建单位",
        avatar: Ionicons.create,
      ),
      FrequentlyUsed(
        id: "addCompany",
        name: "加单位",
        avatar: Ionicons.add,
      ),
    ];
  }


  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var setting = HiveUtils.getSubGroup('setting');
    if(setting==null){
      setting = SubGroup.fromJson(settingDefaultConfig);
      HiveUtils.putSubGroup('setting', setting);
    }
    state.subGroup = Rx(setting);
  }

}
