import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/dart/core/thing/form.dart';
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
    state.mostUsedList = settingCtrl.store.storeFrequentlyUsed;
  }

  @override
  void onTapFrequentlyUsed(used) async {
    if (used is StoreFrequentlyUsed) {
      switch (used.storeEnum) {
        case StoreEnum.file:
          settingCtrl.store.onRecordRecent(
              RecentlyUseModel(type: StoreEnum.file.label, file:  used.fileItemShare));
          Get.toNamed(Routers.messageFile,
              arguments: {"file":FileItemShare.fromJson(used.fileItemShare!.shareInfo()),"type":"store"});
          break;
        case StoreEnum.thing:
          var thing = used.thing;
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
