import 'package:flutter/material.dart';
import 'package:orginone/dart/controller/base_list_controller.dart';

/// 办事模块通用的controller
abstract class AffairsBaseListController<T> extends BaseListController<T> {
  /// 不分页，直接一次性加载完成
  int limit = 10;
  int offset = 0;

  @override
  void onInit() {
    super.onInit();
    debugPrint("onInit->$this");
    onRefresh();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("onReady->$this");
    // onRefresh();
  }
}
