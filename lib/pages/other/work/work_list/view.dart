import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/work/work_list/state.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';

class WorkListPage extends BaseGetView<WorkListController,WorkListState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.data.name,
    );
  }
}