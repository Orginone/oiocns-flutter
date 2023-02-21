import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/home/home_page.dart';

class CenterFunctionState extends BaseGetState {
  late TabController tabController;

  late CenterItem info;

  late List<String> tabTitle;


  CenterFunctionState() {
    info = Get.arguments['info'];
    tabTitle = CenterFunctionTabTitle[info.type]!;
  }
}

