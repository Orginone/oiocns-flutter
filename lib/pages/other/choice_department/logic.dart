import 'package:get/get.dart';
import 'package:orginone/pages/other/choice_people/logic.dart';
import 'package:orginone/pages/other/choice_people/mock.dart';
import 'package:orginone/pages/other/choice_people/state.dart';
import 'package:worker_manager/worker_manager.dart';

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
    state.choicePeople.value = await Executor().execute(
        arg1: PeopleMock['data'] as Map<String, dynamic>, fun1: getMockModel);
  }

  void search(String str) {
   state.searchList.clear();
   List<ChoicePeople> allList = [];

   allList.addAll(state.choicePeople.value?.getAllDepartment()??[]);

   var filter = allList
       .where((element) => (element.agencyName?.contains(str)) ?? false);
   if (filter.isNotEmpty) {
    state.searchList.addAll(filter);
   }
  }

  void back() {
   Get.back(result: state.selectedDepartment.value);
  }

  void selectedDepartment(ChoicePeople item) {
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

  void selectGroup(ChoicePeople item) {
    state.selectedGroup.add(item);
  }
}
