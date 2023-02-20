import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/base_controller.dart';
import 'package:orginone/components/unified_colors.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/components/loading_widget.dart';
import 'package:orginone/util/widget_util.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isUseScaffold()
        ? OrginoneScaffold(
            appBarCenterTitle: true,
            appBarTitle: Text(
              getTitle(),
              style: AFont.instance.size22Black3,
            ),
            appBarLeading: WidgetUtil.defaultBackBtn,
            appBarActions: actions(),
            bgColor: UnifiedColors.white,
            body: _loadingWidget(),
            resizeToAvoidBottomInset: false)
        : _loadingWidget();
  }

  _loadingWidget() {
    return LoadingWidget(
        initStatus: initStatus(),
        builder: (context) => builder(context),
        controller: controller);
  }

  Widget builder(BuildContext context);

  /// 设置页面的初始状态，默认值为loading
  LoadStatusX initStatus() {
    return controller.loadStatus.value;
  }

  /// 默认标题
  String getTitle() {
    return "";
  }

  /// 是否使用Scaffold
  bool isUseScaffold() {
    return true;
  }

  /// 标题右侧按钮
  List<Widget>? actions() {
    return null;
  }
}
