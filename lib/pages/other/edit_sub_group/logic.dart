import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

import 'state.dart';

class EditSubGroupController extends BaseController<EditSubGroupState> {
  final EditSubGroupState state = EditSubGroupState();

  void changeGroupIndex(int oldIndex, int newIndex) {
    var item = state.subGroup.value.groups!.removeAt(oldIndex);

    int index = 0;

    if (newIndex < oldIndex) {
      index = newIndex;
    } else if (newIndex != 0) {
      index = newIndex - 1;
    }

    state.subGroup.value.groups!.insert(index, item);

    state.subGroup.refresh();
  }

  void save() {
    state.clickSave = true;
    HiveUtils.putSubGroup(state.subGroup.value.type!, state.subGroup.value);
    ToastUtils.showMsg(msg: "保存成功");
  }

  void removeGroup(Group item) {
    state.subGroup.value.groups!.remove(item);
    state.subGroup.value.hidden!.add(item);
    state.subGroup.refresh();
  }

  void addGroup(Group item) {
    state.subGroup.value.hidden!.remove(item);
    state.subGroup.value.groups!.add(item);
    state.subGroup.refresh();
  }

  void back() {
    Get.back(result: state.clickSave?state.subGroup.value:null);
  }


}
