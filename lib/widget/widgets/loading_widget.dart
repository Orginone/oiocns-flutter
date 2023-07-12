import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/widget/unified.dart';

class LoadingWidget extends StatelessWidget {
  ///内容页面
  final WidgetBuilder builder;

  ///是否显示loading
  /// 初始化状态，默认显示页面内容
  // Rx<LoadStatusX> currStatus = Rx(LoadStatusX.loading);
  LoadStatusX currStatus = LoadStatusX.loading;

  LoadingWidget({
    Key? key,
    this.currStatus = LoadStatusX.loading,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      // child: Obx(() => _getView(context)),
      child: _getView(context),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return ConstrainedBox(
  //     constraints: const BoxConstraints.expand(),
  //     child: Obx(() => _getView(context)),
  //   );
  // }

  Widget _getView(BuildContext context) {
    if (currStatus == LoadStatusX.loading) {
      return _loadingView();
    } else if (currStatus == LoadStatusX.error) {
      return _errorView();
    } else if (currStatus == LoadStatusX.empty) {
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
