import 'package:get/get.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/pages/other/work/work_start/logic.dart';
import 'package:orginone/pages/other/work/work_start/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

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
    if (event is ChoicePeople) {
      for (var element in state.node.operations!) {
        for (var element in element.items!) {
          if (element.fields?.router == Routers.choicePeople) {
            element.fields?.defaultData.value = event.user;
          }
        }
      }
    }
    if (event is ChoiceDepartment) {
      for (var element in state.node.operations!) {
        for (var element in element.items!) {
          if (element.fields?.router == Routers.choiceDepartment) {
            element.fields?.defaultData.value = event.department;
          }
        }
      }
    }
  }

  Future init() async{
    for (var element in state.node.operations!) {
      if (element.items == null) {
        await element.getOperationItems(work.state.work.space!.id);
      }
    }
    state.show.value = true;
  }

  Future<void> submit() async{
    for (var element in state.node.operations!) {
      for (var element in element.items!) {
        if (element.fields?.required ?? false) {
          if (element.fields!.defaultData.value == null) {
            return ToastUtils.showMsg(msg: element.fields!.hint!);
          }
        }
      }
    }
    if(state.selectedThings.isEmpty && (!(state.define.isCreate??false))){
      return ToastUtils.showMsg(msg:"请至少选择一条实体");
    }
    Map<String,dynamic> data = {};

    for (var element in state.node.operations!) {
      for (var element in element.items!) {
        if (element.fields?.defaultData.value != null) {
          if (element.fields?.type == "select") {
            if (!element.fields!.code!.contains("DATE") &&
                !element.fields!.code!.contains('date') &&
                !(element.fields!.code == 'DKGMSJ')) {
              data[element.attrId!] =
                  element.fields!.defaultData.value?.values?.first.toString() ??
                      "";
            } else {
              data[element.attrId!] = element.fields?.defaultData.value;
            }
          } else if (element.fields?.type == "router") {
            data[element.attrId!] = element.fields?.defaultData.value.name;
          } else {
            data[element.attrId!] = element.fields?.defaultData.value;
             }
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
