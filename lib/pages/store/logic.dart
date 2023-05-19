import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/constant.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StoreController extends BaseController<StoreState>{
 final StoreState state = StoreState();

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.recentlyList.add(
        Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "资产处置", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "通用表格", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公物仓", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公益仓", "${Constant.host}/img/logo/logo3.jpg"));
  }
}
