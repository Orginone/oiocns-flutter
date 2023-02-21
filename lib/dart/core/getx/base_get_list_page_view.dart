import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/loading_widget.dart';
import 'package:orginone/widget/load_state_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_controller.dart';
import 'base_get_list_state.dart';
import 'base_get_state.dart';
import 'base_list_controller.dart';

abstract class BaseGetListPageView<T extends BaseListController, S extends BaseGetListState>
    extends StatelessWidget {

  late T controller;

  S get state => controller.state as S;

  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(getController(), tag: tag());
    controller.context = context;

    return Column(
      children: [
        headWidget(),
        Expanded(
          child: Obx(() {
            return LoadStateWidget(
              isSuccess: state.isSuccess.value,
              isLoading: state.isLoading.value,
              onRetry: (){
                controller.loadData();
              },
              builder: (){
                return SmartRefresher(
                  controller: controller.refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () => controller.onRefresh(),
                  onLoading: () => controller.onLoadMore(),
                  child: buildView(),
                );
              },
            );
          }),
        ),
        bottomWidget(),
      ],
    );
  }

  Widget buildView();


  Widget headWidget() {
    return Container();
  }

  Widget bottomWidget() {
    return Container();
  }

  T getController();

  String tag() {
    return "";
  }
}