import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/pages/other/choice_thing/network.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/routers.dart';

import 'state.dart';


class ThingController extends BaseListController<ThingState> {
 final ThingState state = ThingState();


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
    state.dataList.addAll(await ChoiceThingNetWork.getThing(state.form.id,state.belongId,index: state.page));
    super.loadData();
  }

  void operation(String key, AnyThingModel item) {

    switch(key){
      case "details":
        Get.toNamed(Routers.thingDetails,
            arguments: {"thing": item, 'form': state.form});
        break;
      case "set":
        settingCtrl.store.setMostUsed(thing: item, storeEnum: StoreEnum.thing);
        break;
      case "delete":
        settingCtrl.store.removeMostUsed(item.id!);
        break;
    }
  }
}
