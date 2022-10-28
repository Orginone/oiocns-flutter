import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/public/loading/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'affairs_base_list_controller.dart';

abstract class AffairsBaseList<T extends AffairsBaseListController>
    extends GetView<T> {
  const AffairsBaseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      controller: controller,
      builder: (context) => SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => controller.onRefresh(),
        onLoading: () => controller.onLoadMore(),
        child: listWidget()
      ),
    );
  }

  Widget listWidget();

}
