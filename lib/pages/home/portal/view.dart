import 'package:flutter/material.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/components/widgets/keep_alive_widget.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/home/portal/workBench/view.dart';

import 'cohort/view.dart';
import 'controller.dart';
import 'state.dart';

class PortalPage extends BaseSubmenuPage<PortalController, PortalState> {
  const PortalPage({super.key});

  @override
  Widget buildPageView(String type, String label) {
    switch (type) {
      case "workbench":
        return KeepAliveWidget(child: WorkBenchPage(type, label));
      case "activity":
        var cohortActivity = GroupActivity(
          settingCtrl.user,
          settingCtrl.chats
              .where((i) => i.isMyChat && i.isGroup)
              .map((i) => i.activity)
              .toList(),
          false,
        );
        return KeepAliveWidget(
            child: CohortActivityPage(type, label, cohortActivity));
      case "circle":
        if (null != settingCtrl.user) {
          var friendsActivity = GroupActivity(
            settingCtrl.user,
            [
              settingCtrl.user.session.activity,
              ...settingCtrl.user.memberChats.map((i) => i.activity).toList()
            ],
            true,
          );
          return KeepAliveWidget(
              child: CohortActivityPage(type, label, friendsActivity));
        } else {
          return KeepAliveWidget(child: Container());
        }
      default:
        return KeepAliveWidget(
          child: Container(),
        );
    }
  }
}
