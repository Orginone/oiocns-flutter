import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/common/others/keep_alive_widget.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/home/portal/cohort/view.dart';
import 'package:orginone/pages/home/portal/workBench/view.dart';

/// 门户页面
class PortalPage extends StatelessWidget {
  late InfoListPageModel? relationModel;

  PortalPage({super.key}) {
    relationModel = null;
  }

  @override
  Widget build(BuildContext context) {
    if (null == relationModel) {
      load();
    }

    return InfoListPage(relationModel!);
  }

  void load() {
    relationModel = InfoListPageModel(
        title: "门户",
        activeTabTitle: getActiveTabTitle(),
        tabItems: [
          TabItemsModel(title: "工作台", content: buildWorkBench()),
          TabItemsModel(title: "群动态", content: buildDynamic()),
          TabItemsModel(title: "好友圈", content: buildFriends())
        ]);
  }

  /// 获得激活页签
  getActiveTabTitle() {
    return RoutePages.getRouteDefaultActiveTab()?.firstOrNull;
  }

  /// 构建工作台
  Widget buildWorkBench() {
    return WorkBenchPage("workbench", "工作台");
  }

  /// 构建群动态
  Widget buildDynamic() {
    // if (null != kernel.user) {
    return Obx(() {
      return null != relationCtrl.cohortActivity.value &&
              null != relationCtrl.user
          ? KeepAliveWidget(
              child: CohortActivityPage(
                  "activity", "群动态", relationCtrl.cohortActivity))
          : const Center(child: Text("数据加载中。。。"));
    });
    // } else {
    //   return Container(
    //     child: const Center(child: Text("--暂无动态内容--")),
    //   );
    // }
  }

  /// 构建好友圈
  Widget buildFriends() {
    // if (null != kernel.user) {
    return Obx(() {
      return null != relationCtrl.friendsActivity.value &&
              null != relationCtrl.user
          ? KeepAliveWidget(
              child: CohortActivityPage(
              "circle",
              "好友圈",
              relationCtrl.friendsActivity,
            ))
          : const Center(child: Text("数据加载中。。。"));
    });
    // } else {
    //   return Container(
    //     child: const Center(child: Text("--暂无好友圈内容--")),
    //   );
    // }
  }
}
