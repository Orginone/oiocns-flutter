import 'package:flutter/material.dart';
import 'package:orginone/components/widgets/common/others/keep_alive_widget.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';
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
    relationModel = InfoListPageModel(title: "门户", tabItems: [
      TabItemsModel(title: "工作台", content: buildWorkBench()),
      TabItemsModel(title: "群动态", content: buildDynamic()),
      TabItemsModel(title: "好友圈", content: buildFriends())
    ]);
  }

  /// 构建工作台
  Widget buildWorkBench() {
    return WorkBenchPage("workbench", "工作台");
  }

  /// 构建群动态
  Widget buildDynamic() {
    // if (null != kernel.user) {
    var cohortActivity = GroupActivity(
      relationCtrl.user,
      relationCtrl.chats
          .where((i) => i.isMyChat && i.isGroup)
          .map((i) => i.activity)
          .toList(),
      false,
    );
    return KeepAliveWidget(
        child: CohortActivityPage("activity", "群动态", cohortActivity,
            loadCohortActivity: () => GroupActivity(
                  relationCtrl.user,
                  relationCtrl.chats
                      .where((i) => i.isMyChat && i.isGroup)
                      .map((i) => i.activity)
                      .toList(),
                  false,
                )));
    // } else {
    //   return Container(
    //     child: const Center(child: Text("--暂无动态内容--")),
    //   );
    // }
  }

  /// 构建好友圈
  Widget buildFriends() {
    // if (null != kernel.user) {
    var friendsActivity = GroupActivity(
      relationCtrl.user,
      [
        relationCtrl.user.session.activity,
        ...relationCtrl.user.memberChats.map((i) => i.activity).toList()
      ],
      true,
    );
    return KeepAliveWidget(
        child: CohortActivityPage(
      "circle",
      "好友圈",
      friendsActivity,
      loadCohortActivity: () => GroupActivity(
        relationCtrl.user,
        [
          relationCtrl.user.session.activity,
          ...relationCtrl.user.memberChats.map((i) => i.activity).toList()
        ],
        true,
      ),
    ));
    // } else {
    //   return Container(
    //     child: const Center(child: Text("--暂无好友圈内容--")),
    //   );
    // }
  }
}
