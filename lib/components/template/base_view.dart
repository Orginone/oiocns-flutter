import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/loading_widget.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isUseScaffold()
        ? OrginoneScaffold(
            appBarCenterTitle: true,
            appBarTitle: Text(
              getTitle(),
              style: XFonts.size22Black3,
            ),
            appBarLeading: XWidgets.defaultBackBtn,
            appBarActions: actions(),
            bgColor: XColors.white,
            body: builder(context),
            resizeToAvoidBottomInset: false)
        : builder(context);
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

abstract class BaseController extends GetxController {
  final Rx<LoadStatusX> loadStatus = LoadStatusX.loading.obs;

  updateLoadStatus(LoadStatusX status) {
    debugPrint("---->1$status");
    if (status != loadStatus.value) {
      loadStatus.value = status;
    }
  }
}
