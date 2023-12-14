import 'package:flutter/material.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';

import 'logic.dart';
import 'state.dart';
import 'work_sub/view.dart';

class WorkPage extends BaseSubmenuPage<WorkController, WorkState> {
  const WorkPage({super.key});

  @override
  Widget buildPageView(String type, String label) {
    return KeepAliveWidget(child: WorkSubPage(type));
    // return WorkSubPage(type);
  }
}
