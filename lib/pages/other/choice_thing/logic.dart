import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/pages/other/choice_thing/network.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ChoiceThingController extends BaseListController<ChoiceThingState> {
  final ChoiceThingState state = ChoiceThingState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  void changeSelected(int index, bool value) {
    state.dataList[index].isSelected = value;
    state.dataList.refresh();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    List<String> ids =
        state.form.things.map((element) => element.id ?? "").toList() ?? [];

   var data = await ChoiceThingNetWork.getThing(
        state.form.id, state.belongId,
        index: state.page);

    state.dataList.addAll(data);

    for (var element in ids) {
      for (var value1 in state.dataList) {
        if (value1.id == element) {
          value1.isSelected = true;
        }
      }
    }

    loadSuccess();
  }

  void submit() {
    var selected = state.dataList.where((element) => element.isSelected);
    if (selected.isNotEmpty) {
      for (var element in selected) {
        if (state.form.things
            .where((element1) => element.id == element1.id)
            .isEmpty) {
          state.form.things.add(element);
        }
      }
    }
    Get.back();
  }
}
