import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class StoreController extends BaseFrequentlyUsedListController<StoreState> {
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

   initData() async{
    state.dataList.value = settingCtrl.store.recent;
    loadSuccess();
  }

  void loadFrequentlyUsed() {
    state.mostUsedList.value = settingCtrl.store.storeFrequentlyUsed;
    state.mostUsedList.refresh();
  }

  @override
  void onTapFrequentlyUsed(used) async {
    if (used is StoreFrequentlyUsed) {
      switch (used.storeEnum) {
        case StoreEnum.file:
          Get.toNamed(Routers.messageFile, arguments: {
            "file": FileItemShare.fromJson(used.fileItemShare!.shareInfo()),
            "type": "store"
          });
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
