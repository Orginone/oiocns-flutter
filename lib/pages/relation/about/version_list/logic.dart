import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/relation/about/version_list/item.dart';
import 'package:orginone/pages/relation/about/version_list/state.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';

class VersionListController extends BaseController<VersionListState> {
  @override
  VersionListState state = VersionListState();
  void backToHome() {
    Get.back();
  }

  void showDiaLog(BuildContext context, VersionItem item) {
    showVersionItemDetail(context, item);
  }
}
