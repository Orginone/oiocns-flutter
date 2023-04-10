import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/enum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_controller.dart';
import 'base_get_list_state.dart';
import 'base_get_state.dart';

abstract class BaseListController<S extends BaseGetListState> extends BaseController<S>{

  late BuildContext context;

  late Logger log;

  BaseListController();

  RefreshController get refreshController => state.refreshController;

  @override
  void onInit() {
    log = Logger(this.toString());
    super.onInit();
  }


  /// 下拉刷新使用
  Future onRefresh() async{
    return await loadData(isRefresh: true).then((value){
      refreshController.refreshCompleted();
    }).onError((err,stack){
      refreshController.refreshFailed();
    });
  }

  /// 加载更多使用
  Future onLoadMore() async{
    return await loadData().then((value){
      refreshController.loadComplete();
    }).onError((err,stack){
      refreshController.loadFailed();
    });
  }

  void loadSuccess(){
    state.isSuccess.value = true;
    state.isLoading.value = false;
  }

  void loadFailed(){
    state.isSuccess.value = false;
    state.isLoading.value = false;
  }

  /// 搜索时需要刷新页面
  void search(String value) {
    throw Exception("未实现的方法!");
  }

  /// isRefresh true 刷新 false 加载更多
  /// 添加数据&自动判断列表刷新和更多对应的头和脚状态
  void addData(bool isRefresh,data) {
    if (isRefresh) {
      state.dataList.clear();
      state.dataList.addAll(data);
      refreshController.refreshCompleted(resetFooterState: true);
      if (state.dataList.isEmpty) {
        //加载空页面
        updateLoadStatus(LoadStatusX.empty);
        return;
      } else {
        updateLoadStatus(LoadStatusX.success);
      }

      /// 无更多
      if (state.dataList.length >= data.length) {
        refreshController.loadComplete();
        refreshController.loadNoData();
      }
    } else {
      state.dataList.addAll(data);
      refreshController.loadComplete();

      /// 无更多
      if (state.dataList.length >= data.length) {
        refreshController.loadNoData();
      }
    }
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
    refreshController.dispose();
    super.onClose();
  }

  Future<void> loadData({bool isRefresh = false,bool isLoad = false}) async{

  }


  void onReceivedEvent(event) {}

  updateLoadStatus(LoadStatusX status) {
    debugPrint("---->1$status");
    if (status != state.loadStatus.value) {
      state.loadStatus.value = status;
    }
  }


}