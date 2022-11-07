import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orginone/component/unified_colors.dart';
import '../../screen_init.dart';
import 'circle.dart';


class ALoading {
  static bool isLoading = false;

  static SpinKitCircle circle = const SpinKitCircle(
    color: UnifiedColors.themeColor,
    size: 30.0,
  );

  /// 是否可通过返回键弹出，默认为false
  static showCircle({bool? canPop = false}) {
    if(navigatorKey.currentState?.overlay?.context == null){
      return;
    }
    isLoading = true;
    showDialog(
        barrierDismissible:false,
        barrierColor: Colors.black12,
        context: navigatorKey.currentState!.overlay!.context,
        builder: (ctx){
          return WillPopScope(
            onWillPop: () async => canPop == true,
            child: Center(
              child: circle,
            ),
          );
        }
    );
  }

  static dismiss() {
    isLoading = false;
    if(navigatorKey.currentState?.overlay?.context == null){
      return;
    }
    if(Navigator.of(navigatorKey.currentState!.overlay!.context).canPop()) {
      Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
    }
  }
}
