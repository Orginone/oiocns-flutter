import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/relation/about/version_list/state.dart';

class VersionListController extends BaseController<VersionListState> {
  void backToHome() {
    Get.back();
  }
}
