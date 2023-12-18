import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_page_view.dart';
import 'package:orginone/utils/storage.dart';

import 'logic.dart';
import 'state.dart';
import 'work_sub/view.dart';

class WorkPage extends BaseSubmenuPage<WorkController, WorkState> {
  const WorkPage({super.key});

  @override
  Widget buildPageView(String type, String label) {
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   FlutterError.dumpErrorToConsole(details);
    //   if (isInDebugMode) {
    //     FlutterError.dumpErrorToConsole(details);
    //   } else {
    //     Get.dialog(Text(details.exceptionAsString()));
    //     // Get.dialog(const ErrorPage());
    //   }
    // };
    var onError = FlutterError.onError; //先将 onerror 保存起来
    FlutterError.onError = (FlutterErrorDetails details) {
      // onError?.call(details); //调用默认的onError处理
      // Get.dialog(Text(details.exceptionAsString()));
      // Get.dialog(const Text('发生错误'));
      var t = DateUtil.formatDate(DateTime.now(),
          format: "yyyy-MM-dd HH:mm:ss.SSS");

      List errorArray = [];
      var json = Storage.getString('work_page_error');
      if (json != '') {
        errorArray = jsonDecode(json);
      }

      errorArray.add({'t': t, 'errorText': details.exceptionAsString()});
      Storage.setJson('work_page_error', errorArray);
    };
    return KeepAliveWidget(child: WorkSubPage(type));
    // return WorkSubPage(type);
  }

  bool get isInDebugMode {
    bool inDebugMode = false;

    assert(inDebugMode = true);

    return inDebugMode;
  }
}
