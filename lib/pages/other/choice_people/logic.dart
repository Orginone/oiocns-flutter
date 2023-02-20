import 'package:get/get.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'mock.dart';
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

    state.choicePeople.value = await Executor().execute(
        arg1: PeopleMock['data'] as Map<String, dynamic>, fun1: getMockModel);
  }

  void search(String str) {
    state.searchList.clear();
    List<ZcyUserPos> allList = [];

    allList.addAll(state.choicePeople.value?.getAllUser()??[]);

    var filter = allList
        .where((element) => (element.realName?.contains(str)) ?? false);
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

  void selectGroup(ChoicePeople item) {
    state.selectedGroup.add(item);
  }

  void selectedUser(ZcyUserPos item) {
    state.selectedUser.value?.isSelected = false;
    state.selectedUser.value = item;
  }
}

Future<ChoicePeople?> getMockModel(
    Map<String, dynamic> json, TypeSendPort sendPort) async {
  ChoicePeople? choicePeople;

  if (json.isNotEmpty) {
    choicePeople = ChoicePeople.fromJson(json);
  }

  return choicePeople;
}
