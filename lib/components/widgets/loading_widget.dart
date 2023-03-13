import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/components/template/base_view.dart';
import 'package:orginone/components/unified.dart';

class LoadingWidget extends StatelessWidget {
  ///内容页面
  final BaseController controller;

  ///内容页面
  final WidgetBuilder builder;

  ///是否显示loading
  /// 初始化状态，默认显示页面内容
  LoadStatusX initStatus = LoadStatusX.loading;

  LoadingWidget({
    Key? key,
    this.initStatus = LoadStatusX.loading,
    required this.builder,
    required this.controller,
  }) : super(key: key) {
    controller.loadStatus.value = initStatus;
    // debugPrint("--->重新初始化了LoadingWidget:$controller");
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Obx(() => _getView(context)),
    );
  }

  Widget _getView(BuildContext context) {
    // debugPrint('---->loadStatus:${controller.loadStatus.value}');
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
      child: Container(
        width: 100.w,
        height: 100.w,
        alignment: Alignment.center,
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 2.5.w,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "加载中...",
              style: XFonts.size20Black9,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "暂无数据",
        style: XFonts.size20Black9,
      ),
    );
  }

  Widget _errorView() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        "服务器开小差了",
        style: XFonts.size20Black9,
      ),
    );
  }
}
