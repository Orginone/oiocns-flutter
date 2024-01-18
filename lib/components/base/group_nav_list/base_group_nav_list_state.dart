import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/group/subgroup.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

abstract class BaseGroupNavListState<T extends BaseBreadcrumbNavModel>
    extends BaseGetState {
  var bcNav = <BaseBreadcrumbNavInfo>[].obs;

  ///导航标题
  String title = '';

  Rxn<T> model = Rxn();

  final ScrollController navBarController = ScrollController();

  bool get isRootDir => (bcNav.length - 1) == 0;

  var showSearch = false.obs;

  var keyword = ''.obs;

  bool showSearchButton = true;

  ///group 属性
  late Rx<SubGroup> subGroup;
  var groupIndex = 0.obs;

  late TabController tabController;

  String tag = '';

  var tabIndex = 0;
  RxBool isConnected = true.obs;
}
