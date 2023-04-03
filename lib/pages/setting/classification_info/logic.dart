import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';


SettingController get setting => Get.find();

class ClassificationInfoController extends BaseController<ClassificationInfoState> with GetTickerProviderStateMixin{
 final ClassificationInfoState state = ClassificationInfoState();
 ClassificationInfoController(){
  state.tabController = TabController(length: tabTitle.length, vsync: this);
 }
 
 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await state.species.loadAttrs(setting.space.id, true, true, PageRequest(offset: 0, limit: 999, filter: ''));
    LoadingDialog.dismiss(context);
  }
}
