import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/model/subgroup_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';

import 'state.dart';

class StoreController extends BaseSubmenuController<StoreState> {
  final StoreState state = StoreState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    loadSuccess();
  }

  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var store = HiveUtils.getSubGroup('store');
    if(store==null){
      store = SubGroup.fromJson(storeDefaultConfig);
      HiveUtils.putSubGroup('store', store);
    }
    state.subGroup = Rx(store);
  }

  @override
  void onTapFrequentlyUsed(used) async {
    if (used is StoreFrequentlyUsed) {
      switch (used.storeEnum) {
        case StoreEnum.file:
          Routers.jumpFile(
              file: FileItemShare.fromJson(used.fileItemShare!.shareInfo()),
              type: 'store');
          break;
        case StoreEnum.thing:
          // var thing = used.thing;
          // IForm? form = await settingCtrl.store
          //     .findForm(thing!.keys.first.substring(1));
          // if (form != null) {
          //   Get.toNamed(Routers.thingDetails,
          //       arguments: {"thing": thing, 'form': form});
          // } else {
          //   ToastUtils.showMsg(msg: "未找到表单");
          // }
          break;
      }
    }
  }
}
