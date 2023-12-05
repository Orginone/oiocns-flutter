import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/components/widgets/keep_alive_widget.dart';
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
        return KeepAliveWidget(child: CohortActivityPage(type, label));
      case "circle":
      default:
        return KeepAliveWidget(
          child: Container(),
        );
    }
  }
}
