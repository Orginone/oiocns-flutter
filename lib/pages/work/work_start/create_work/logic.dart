import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/pages/work/work_start/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateWorkController extends BaseController<CreateWorkState> {
  final CreateWorkState state = CreateWorkState();

  WorkStartController get work => Get.find<WorkStartController>();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);

  }

  Future<void> loadForm() async{
    List<IForm> iForms = (await state.define.workItem.loadForms());

    if(state.node.value.forms!=null){
      var formIds = state.node.value.forms!.map((i) => i.id).toList();
      for (var form in state.node.value.forms!) {
        try{
          var iForm = iForms.firstWhere((element) => formIds.contains(element.metadata.id));
          form.attributes = await iForm.loadAttributes();
        }catch(e){

        }
      }
    }
  }

  Future<void> submit() async{
    for (var element in state.node.value.forms??[]) {
      for (var element in element.attributes??[]) {
        if (element.fields?.required ?? false) {
          if (element.fields!.defaultData.value == null) {
            return ToastUtils.showMsg(msg: element.fields!.hint!);
          }
        }
      }
    }
    Map<String,dynamic> data = {};

    for (var element in state.node.value.forms??[]) {
      for (var element in element.attributes??[]) {
        if (element.fields?.defaultData.value != null) {
          data[element.id!] = element.fields?.defaultData.value;
        }
      }
    }

    WorkStartNetWork.createInstance(state.define, data, state.selectedThings.map((element) => element.id!).toList());
  }

  void jumpEntity() {
    Get.toNamed(Routers.choiceThing, arguments: {
      "selectedThings":
          state.selectedThings.map((element) => element.id).toList()
    })?.then((value) {
      state.selectedThings.value = value;
    });
  }

  void delete(int index) {
    state.selectedThings.removeAt(index);
  }
}
