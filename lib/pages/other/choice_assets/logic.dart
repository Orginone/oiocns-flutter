import 'package:get/get.dart';
import 'package:orginone/event/choice_assets.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'mock.dart';
import 'state.dart';

class ChoiceAssetsController extends BaseController<ChoiceAssetsState> {
  final ChoiceAssetsState state = ChoiceAssetsState();

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

    var mockList = await Executor().execute(
        arg1:
            ChoiceAssetMock['data']['childList'] as List<Map<String, dynamic>>,
        fun1: getMockListModel);

    state.mockList.addAll(mockList);
  }

  void search(String str) {
    state.searchList.clear();
    List<ChildList> allList = [];

    for (var element in state.mockList) {
      allList.addAll(element.getAllLastList());
    }

    var filter = allList
        .where((element) => (element.categoryName?.contains(str)) ?? false);
    if (filter.isNotEmpty) {
      state.searchList.addAll(filter);
    }
  }

  void selectItem(ChildList item) {
    state.selectedAsset.value = item;
  }

  void back() {
    EventBusHelper.fire(ChoiceAssets(state.selectedAsset.value));

    Get.back();
  }
}

Future<List<ChildList>> getMockListModel(
    List<Map<String, dynamic>> json, TypeSendPort sendPort) async {
  List<ChildList> list = [];

  if (json.isNotEmpty) {
    for (var value in json) {
      list.add(ChildList.fromJson(value));
    }
  }

  return list;
}
