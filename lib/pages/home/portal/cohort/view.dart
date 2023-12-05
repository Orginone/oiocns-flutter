import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';

import 'controller.dart';
import 'state.dart';

class CohortActivityPage
    extends BaseGetListPageView<CohortActivityController, CohortActivityState> {
  late String type;
  late String label;

  CohortActivityPage(this.type, this.label, {super.key});

  @override
  Widget buildView() {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 15.h), children: const []);
  }

  @override
  CohortActivityController getController() {
    // showErr();
    return CohortActivityController(type);
  }

  @override
  String tag() {
    return "portal_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
