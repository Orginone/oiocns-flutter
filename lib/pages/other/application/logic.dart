import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ApplicationController extends BaseController<ApplicationState> with GetTickerProviderStateMixin{
 final ApplicationState state = ApplicationState();


 SettingController get settingCtrl => Get.find<SettingController>();
 ApplicationController(){
   state.tabController = TabController(length: tabTitle.length, vsync: this);
 }

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    state.products.value = await settingCtrl.user!.getOwnProducts();
    LoadingDialog.dismiss(context);
  }

}
