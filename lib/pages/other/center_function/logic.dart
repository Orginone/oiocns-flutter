import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/bottom_sheet_dialog.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CenterFunctionController extends BaseController<CenterFunctionState> with GetTickerProviderStateMixin{
 final CenterFunctionState state = CenterFunctionState();


 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: state.tabTitle.length, vsync: this);
  }


}
