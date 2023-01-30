import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/components/unified_edge_insets.dart';
import 'package:orginone/util/asset_util.dart';

enum LoadingButtonStatus { normal, loading }

class LoadingButton extends GetView<LoadingButtonController> {
  final Widget child;
  final Function callback;
  final Rx<LoadingButtonStatus> loading = LoadingButtonStatus.normal.obs;

  LoadingButton({required this.child, required this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var lightBlueAccent = Colors.lightBlueAccent;
      return ElevatedButton(
        onPressed: loading.value == LoadingButtonStatus.loading
            ? null
            : () async {
                loading.value = LoadingButtonStatus.loading;
                try {
                  await callback();
                } finally {
                  loading.value = LoadingButtonStatus.normal;
                }
              },
        style: loading.value == LoadingButtonStatus.loading
            ? ButtonStyle(
                padding: MaterialStateProperty.all(lr40),
                backgroundColor: MaterialStateProperty.all(lightBlueAccent),
              )
            : ButtonStyle(padding: MaterialStateProperty.all(lr40)),
        child: _body,
      );
    });
  }

  get _body {
    switch (loading.value) {
      case LoadingButtonStatus.normal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [child],
        );
      case LoadingButtonStatus.loading:
        var loadingIcon = const Icon(
          AssetUtil.loadingIcon,
          color: Colors.white,
        );
        var loading = AnimatedBuilder(
          animation: controller._ctrl,
          builder: (context, child) => Transform.rotate(
            angle: controller._ctrl.value * 2 * pi,
            child: child,
          ),
          child: loadingIcon,
        );
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading,
            Container(margin: EdgeInsets.only(left: 10.w)),
            child
          ],
        );
    }
  }
}

class LoadingButtonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  LoadingButtonController();

  @override
  void onInit() {
    super.onInit();
    const duration = Duration(seconds: 1);
    _ctrl = AnimationController(vsync: this, duration: duration);
    _ctrl.repeat();
  }

  @override
  void onClose() {
    _ctrl.dispose();
    super.onClose();
  }
}
