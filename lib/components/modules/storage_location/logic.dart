import 'package:get/get.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'mock.dart';
import 'state.dart';

class StorageLocationController extends BaseController<StorageLocationState> {
  final StorageLocationState state = StorageLocationState();

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
        arg1: LocationMock['data'] as List<Map<String, dynamic>>,
        fun1: getMockListModel);

    state.mock = mockList;
    state.mockRx.addAll(mockList);
  }

  void back() {
    Get.back(result: state.selectedLocation.value);
  }

  void search(String str) {
    state.searchList.clear();
    List<StorageLocation> allList = [];

    for (var element in state.mockRx) {
      allList.addAll(element.getAllLastList());
    }

    var filter =
        allList.where((element) => (element.placeName?.contains(str)) ?? false);
    if (filter.isNotEmpty) {
      state.searchList.addAll(filter);
    }
  }

  void selectLocationGroup(StorageLocation item) {
    state.selectedGroup.add(item);
  }

  void selectLocation(StorageLocation item) {
    state.selectedLocation.value?.isSelected = false;
    state.selectedLocation.value = item;
  }

  void clearGroup() {
    state.selectedGroup.clear();
  }

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index + 1, state.selectedGroup.length);
    state.selectedGroup.refresh();
  }
}

Future<List<StorageLocation>> getMockListModel(
    List<Map<String, dynamic>> json, TypeSendPort sendPort) async {
  List<StorageLocation> list = [];

  if (json.isNotEmpty) {
    for (var value in json) {
      list.add(StorageLocation.fromJson(value));
    }
  }

  return list;
}
