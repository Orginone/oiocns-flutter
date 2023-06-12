import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/pages/other/choice_thing/network.dart';
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
    state.dataList.value = await ChoiceThingNetWork.getThing(state.form.metadata.id,state.belongId);
    super.loadData();
  }
}
