import 'package:get/get.dart';
import 'package:orginone/pages/other/choice_thing/network.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ChoiceThingController extends BaseController<ChoiceThingState> {
  final ChoiceThingState state = ChoiceThingState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    List<String> ids =
        state.form.things.map((element) => element.id ?? "").toList() ?? [];

    LoadingDialog.showLoading(context);
    state.things.value =
        await ChoiceThingNetWork.getThing(state.form.id, state.belongId);

    for (var element in ids) {
      for (var value1 in state.things) {
        if (value1.id == element) {
          value1.isSelected = true;
        }
      }
    }
    LoadingDialog.dismiss(context);
  }

  void changeSelected(int index, bool value) {
    state.things[index].isSelected = value;
    state.things.refresh();
  }

  void submit() {
    var selected = state.things.where((element) => element.isSelected);
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
