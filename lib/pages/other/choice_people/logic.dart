import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/util/event_bus_helper.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ChoicePeopleController extends BaseController<ChoicePeopleState> {
  final ChoicePeopleState state = ChoicePeopleState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.searchController.addListener(() {
      if (state.searchController.text.isNotEmpty) {
        state.showSearchPage.value = true;
        search(state.searchController.text);
      } else {
        state.showSearchPage.value = false;
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    state.departments.value = [];
    state.allUser = [];
  }

  void search(String str) {
    state.searchList.clear();

    var filter =
        state.allUser.where((element) => (element.name.contains(str)) ?? false);
    if (filter.isNotEmpty) {
      state.searchList.addAll(filter);
    }
  }

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index+1, state.selectedGroup.length);
    state.selectedGroup.refresh();
  }

  void clearGroup() {
    state.selectedGroup.clear();
  }

  void back() {
    if (state.selectedUser.value != null) {
      EventBusHelper.fire(ChoicePeople(user: state.selectedUser.value!, department: state.selectedUserDepartment!));
    }
    Get.back();
  }

  void selectGroup(ITarget item) {
    state.selectedGroup.add(item);
  }

  void selectedUser(XTarget item) {
    state.selectedUserDepartment = state.selectedGroup.last;
    state.selectedUser.value?.isSelected = false;
    state.selectedUser.value = item;
  }
}

