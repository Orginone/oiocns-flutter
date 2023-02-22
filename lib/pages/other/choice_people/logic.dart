import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/department_utils.dart';

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

    state.departments.value = DepartmentUtils().departments;
    state.allUser = DepartmentUtils().getAllUser(state.departments);
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
    Get.back(result: state.selectedUser.value);
  }

  void selectGroup(ITarget item) {
    state.selectedGroup.add(item);
  }

  void selectedUser(XTarget item) {
    state.selectedUser.value?.isSelected = false;
    state.selectedUser.value = item;
  }
}

