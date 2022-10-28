import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/public/http/base_controller.dart';
import '../../component/unified_text_style.dart';
import '../../page/home/affairs/affairs_type_enum.dart';
import 'load_status.dart';

class LoadingWidget extends StatelessWidget {
  ///内容页面
  // final Widget child;
  final BaseController controller;
  ///内容页面
  final WidgetBuilder builder;
  ///是否显示loading
  final bool showLoading;
  LoadStatusX lastLoadStatus = LoadStatusX.loading;
  LoadingWidget({
    this.showLoading = true,
    required this.builder,
    required this.controller,
  }){
    debugPrint("--->重新初始化了LoadingWidget:$controller");
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Obx(() => _getView(context)),
    );
  }

  Widget _getView(BuildContext context) {
    debugPrint('---->loadStatus:${controller.loadStatus.value}');
    if (controller.loadStatus.value == LoadStatusX.loading) {
      return _loadingView();
    } else if (controller.loadStatus.value == LoadStatusX.error) {
      return _errorView();
    } else if (controller.loadStatus.value == LoadStatusX.empty) {
      return _emptyView();
    } else {
      return builder(context);
    }
  }

  Widget _loadingView() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Center(
          child: Text(
        "加载中...",
        style: text14Grey,
      )),
    );
  }

  Widget _emptyView() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "暂无数据",
        style: text14Grey,
      ),
    );
  }

  Widget _errorView() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "服务器开小差了",
        style: text14Grey,
      ),
    );
  }
}
