import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';


SettingController get setting => Get.find();

class ClassificationInfoController extends BaseController<ClassificationInfoState> with GetTickerProviderStateMixin{
  final ClassificationInfoState state = ClassificationInfoState();

  ClassificationInfoController() {
    state.tabTitle = [
      ClassificationEnum.info,
      ClassificationEnum.attrs,
      ClassificationEnum.form
    ];
    if (findHasMatters(state.species)) {
      state.tabTitle.add(ClassificationEnum.work);
    }
    state.tabController =
        TabController(length: state.tabTitle.length, vsync: this);
  }

  bool findHasMatters(SpeciesItem species) {
    if (species.target.code == 'matters') {
      return true;
    } else if (species.parent != null) {
      return findHasMatters((species.parent!) as SpeciesItem);
    }
    return false;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await state.species.loadAttrs(state.species.target.belongId, true, true,
        PageRequest(offset: 0, limit: 999, filter: ''));
    LoadingDialog.dismiss(context);
  }

  void changeIndex(int index) {
    if (index != state.currentIndex.value) {
      state.currentIndex.value = index;
    }
  }

  void create() {}
}
