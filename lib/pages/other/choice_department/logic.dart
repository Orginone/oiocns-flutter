import 'package:get/get.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/department_management.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ChoiceDepartmentController extends BaseController<ChoiceDepartmentState> {
  final ChoiceDepartmentState state = ChoiceDepartmentState();

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
    state.departments.value = DepartmentManagement().departments;
    state.allDepartment = DepartmentManagement().getAllDepartment(state.departments);
  }

  void search(String str) {
    state.searchList.clear();

    var filter = state.allDepartment
        .where((element) => (element.name.contains(str)) ?? false);
    if (filter.isNotEmpty) {
      state.searchList.addAll(filter);
    }
  }

  void back() {
   Get.back(result: state.selectedDepartment.value);
  }

  void selectedDepartment(ITarget item) {
    state.selectedDepartment.value?.isSelected = false;
    state.selectedDepartment.value = item;
  }

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index + 1, state.selectedGroup.length);
    state.selectedGroup.refresh();
  }

  void clearGroup() {
    state.selectedGroup.clear();
  }

  void selectGroup(ITarget item) {
    state.selectedGroup.add(item);
  }
}
