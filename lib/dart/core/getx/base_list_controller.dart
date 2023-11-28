import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/enum.dart';

import 'base_controller.dart';
import 'base_get_list_state.dart';

abstract class BaseListController<S extends BaseGetListState>
    extends BaseController<S> {
  @override
  late BuildContext context;

  late Logger log;

  BaseListController();

  @override
  void onInit() {
    log = Logger(toString());
    super.onInit();
  }

  /// 下拉刷新使用
  Future onRefresh() async {
    state.page = 0;
    await loadData(isRefresh: true);
  }

  /// 加载更多使用
  Future onLoadMore() async {
    state.page++;
    await loadData();
  }

  void loadSuccess() {
    state.isSuccess.value = true;
    state.isLoading.value = false;
  }

  void loadFailed() {
    state.isSuccess.value = false;
    state.isLoading.value = false;
  }

  /// 搜索时需要刷新页面
  void search(String value) {
    throw Exception("未实现的方法!");
  }

  void removeAt(int index) {
    if (index < state.dataList.length) {
      state.dataList.removeAt(index);
      if (state.dataList.isEmpty) {
        updateLoadStatus(LoadStatusX.empty);
      }
    }
  }

  @override
  void onClose() {
    state.refreshController.dispose();
    super.onClose();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = true}) async {
    state.isSuccess.value = false;
    state.isLoading.value = isLoad;
    loadSuccess();
  }

  @override
  void onReceivedEvent(event) {}

  updateLoadStatus(LoadStatusX status) {
    debugPrint("---->1$status");
    if (status != state.loadStatus.value) {
      state.loadStatus.value = status;
    }
  }
}
