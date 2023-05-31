import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
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
    List<String> selected = Get.arguments?['ids']??[];

    LoadingDialog.showLoading(context);
    state.things.value = await ChoiceThingNetWork.getThing();

    for (var element in selected) {
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
    var result = [];
    var selected = state.things.where((element) => element.isSelected);
    if(selected.isNotEmpty){
      result = selected.toList();
    }
    Get.back(result: result);
  }
}
