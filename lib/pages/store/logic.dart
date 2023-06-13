import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import 'state.dart';

class StoreController extends BaseFrequentlyUsedListController<StoreState> {
  final StoreState state = StoreState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.dataList.value = List.generate(10, (i) => i);
    state.mostUsedList = settingCtrl.store.storeRecent;
  }

  @override
  void onTapRecent(recent) async {
    if (recent is StoreRecent) {
      switch (recent.storeEnum) {
        case StoreEnum.file:
          Get.toNamed(Routers.messageFile,
              arguments: recent.fileItemShare!.shareInfo());
          break;
        case StoreEnum.thing:
          var thing = recent.thing;
          IForm? form = await settingCtrl.store
              .findForm(thing!.species.keys.first.substring(1));
          if (form != null) {
            Get.toNamed(Routers.thingDetails,
                arguments: {"thing": thing, 'form': form});
          } else {
            ToastUtils.showMsg(msg: "未找到表单");
          }
          break;
      }
    }
  }
}
