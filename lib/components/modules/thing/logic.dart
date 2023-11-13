import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/modules/choice_thing/network.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';

import 'state.dart';

class ThingController extends BaseListController<ThingState> {
  @override
  final ThingState state = ThingState();

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    state.dataList.addAll(await ChoiceThingNetWork.getThing(
        state.form.id, state.belongId,
        index: state.page, filter: state.filter));
    super.loadData();
  }

  void operation(String key, AnyThingModel item) {
    switch (key) {
      case "details":
        Get.toNamed(Routers.thingDetails,
            arguments: {"thing": item, 'form': state.form});
        break;
      case "set":
        //TODO:setMostUsed removeMostUsed方法不存在 使用时要看逻辑
        // settingCtrl.store.setMostUsed(thing: item, storeEnum: StoreEnum.thing);
        break;
      case "delete":
        // settingCtrl.store.removeMostUsed(item.id!);
        break;
    }
  }
}
