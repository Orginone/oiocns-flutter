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

  static showCircle() {
    if(navigatorKey.currentState?.overlay?.context == null){
      return;
    }
    isLoading = true;
    showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (ctx){
          return Center(
            child: circle,
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
  // static BuildContext? _context;
  // static bool isLoading = false;
  //
  // static SpinKitCircle circle = const SpinKitCircle(
  //   color: UnifiedColors.themeColor,
  //   size: 30.0,
  // );
  //
  // static showCircle(BuildContext? context) {
  //   if(isLoading || context == null){
  //     return;
  //   }
  //   isLoading = true;
  //   showDialog(
  //       context: ,
  //       builder: (ctx){
  //         _context = ctx;
  //         return Center(
  //           child: circle,
  //         );
  //       }
  //   );
  // }
  //
  // static dismiss() {
  //   isLoading = false;
  //   if (_context == null || Navigator.of(_context!) == null) {
  //     return;
  //   }
  //
  //   if(Navigator.of(_context!).canPop()) {
  //     Navigator.of(_context!).pop();
  //   }
  // }
}
