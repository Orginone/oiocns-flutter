import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'logic.dart';
import 'state.dart';
import 'work_sub/view.dart';

class WorkPage extends BaseSubmenuPage<WorkController, WorkState> {
  @override
  Widget buildPageView(BuildContext context, int index) {
    return KeepAliveWidget(child: WorkSubPage(state.submenu[index].value));
  }

  @override
  bool displayNoDataWidget() => false;
}
