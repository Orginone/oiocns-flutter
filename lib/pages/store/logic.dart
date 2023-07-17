import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';

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
    // TODO: implement onReady
    initData();
  }


  initData() async {
    state.dataList.value = settingCtrl.store.recent;
    loadSuccess();
  }

  @override
  void initSubmenu() {
    // TODO: implement initSubmenu
    super.initSubmenu();
    state.submenu.value = [
      SubmenuType(text: "全部", value: 'all'),
      SubmenuType(text: "文件", value: 'create'),
      SubmenuType(text: "表单", value: 'todo'),
    ];
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
