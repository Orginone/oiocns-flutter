import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base_list_controller.dart';
import 'package:orginone/components/base_view.dart';
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
