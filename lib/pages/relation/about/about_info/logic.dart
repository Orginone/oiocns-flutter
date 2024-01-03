import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/relation/about/about_info/state.dart';

class VersionInfoController extends BaseController<VersionInfoState> {
  @override
  final VersionInfoState state = VersionInfoState();
  @override
  void onInit() {
    loadAssests();
    super.onInit();
  }

  void loadAssests() async {
    String filePath = 'assets/markdown/originone.md';
    dynamic result = await rootBundle.loadString(filePath);
    if (result != null) {
      state.mk.value = result.toString();
      // print(state.mk.value);
    }
  }

  void backToHome() {
    Get.back();
  }
}
