import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'logic.dart';
import 'start/view.dart';
import 'state.dart';


class WorkStartPage extends BaseGetView<WorkStartController,WorkStartState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "事项",
      body:  KeepAliveWidget(child: StartPage(state.species)),
    );
  }
}