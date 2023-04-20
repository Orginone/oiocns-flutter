import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/base_view.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListView<T extends BaseListController> extends BaseView<T> {
  const BaseListView({Key? key}) : super(key: key);

  @override
  Widget builder(context) {
    return Obx(() {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => controller.onRefresh(),
        onLoading: () => controller.onLoadMore(),
        child: listWidget(),
      );
    });
  }

  ListView listWidget();
}

abstract class BaseListController<T> extends BaseController {
  /// 列表数据容器
  RxList<T> dataList = RxList([]);

  /// 刷新控制器
  RefreshController refreshController = RefreshController();

  /// 下拉刷新使用
  void onRefresh() {
    throw Exception("未实现的方法!");
  }

  /// 加载更多使用
  void onLoadMore() {
    throw Exception("未实现的方法!");
  }

  /// 搜索时需要刷新页面
  void search(String value) {
    throw Exception("未实现的方法!");
  }

  /// isRefresh true 刷新 false 加载更多
  /// 添加数据&自动判断列表刷新和更多对应的头和脚状态
  void addData(bool isRefresh, PageResp<T> pageResp) {
    if (isRefresh) {
      dataList.clear();
      dataList.addAll(pageResp.result);
      refreshController.refreshCompleted(resetFooterState: true);
      if (dataList.isEmpty) {
        //加载空页面
        updateLoadStatus(LoadStatusX.empty);
        return;
      } else {
        updateLoadStatus(LoadStatusX.success);
      }

      /// 无更多
      if (dataList.length >= pageResp.total) {
        refreshController.loadComplete();
        refreshController.loadNoData();
      }
    } else {
      dataList.addAll(pageResp.result);
      refreshController.loadComplete();

      /// 无更多
      if (dataList.length >= pageResp.total) {
        refreshController.loadNoData();
      }
    }
  }

  void removeAt(int index) {
    if (index < dataList.length) {
      dataList.removeAt(index);
      if (dataList.isEmpty) {
        updateLoadStatus(LoadStatusX.empty);
      }
    }
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
