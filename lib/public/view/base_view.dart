import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/public/http/base_controller.dart';
import 'package:orginone/public/loading/load_status.dart';
import 'package:orginone/public/loading/loading_widget.dart';

import '../../component/unified_colors.dart';
import '../../component/unified_scaffold.dart';
import '../../util/widget_util.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isUseScaffold()
        ? UnifiedScaffold(
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
    return LoadStatusX.loading;
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
