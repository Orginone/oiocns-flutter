import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/config/constant.dart';

enum LoadingButtonStatus { normal, loading }

class LoadingButton extends StatelessWidget {
  final Widget child;
  final Function callback;
  final Rx<LoadingButtonStatus> loading;
  final LoadingButtonController loadingBtnCtrl;
  final AnimationController animationCtrl;

  LoadingButton({Key? key,
    required this.child,
    required this.callback,
    required this.loadingBtnCtrl,
  })  : loading = LoadingButtonStatus.normal.obs,
        animationCtrl = AnimationController(
          vsync: loadingBtnCtrl,
          duration: const Duration(seconds: 1),
        )..repeat(), super(key: key);

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
                padding: MaterialStateProperty.all(
                  EdgeInsets.only(left: 40.w, right: 40.w),
                ),
                backgroundColor: MaterialStateProperty.all(lightBlueAccent),
              )
            : ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.only(left: 40.w, right: 40.w),
                ),
              ),
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
          IconData(0xe891, fontFamily: Constant.projectName),
          color: Colors.white,
        );
        var loading = AnimatedBuilder(
          animation: animationCtrl,
          builder: (context, child) => Transform.rotate(
            angle: animationCtrl.value * 2 * pi,
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
    with GetSingleTickerProviderStateMixin {}
