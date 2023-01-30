import 'dart:io';

import 'package:get/get.dart';
import 'package:orginone/components/load_status.dart';
import 'package:orginone/dart/base/model/page_resp.dart';
import 'package:orginone/dart/base/model/version_entity.dart';
import 'package:orginone/dart/controller/base_list_controller.dart';
import 'package:orginone/dart/controller/file_controller.dart';

class VersionController extends BaseListController<VersionVersionMes> {
  var fileCtrl = Get.find<FileController>();

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onRefresh() async {
    var version = await fileCtrl.versionList();
    if (version != null) {
      List<VersionVersionMes> versionList = [];
      for (var element in (version.versionMes ?? [])) {
        if (Platform.isAndroid && element.platform.toLowerCase() == "android") {
          versionList.add(element);
        } else if (Platform.isIOS && element.platform.toLowerCase() == "ios") {
          versionList.add(element);
        }
      }
      if (versionList.isEmpty) {
        updateLoadStatus(LoadStatusX.empty);
        update();
        return;
      }
      PageResp<VersionVersionMes> pageResp =
          PageResp(versionList.length, versionList.length, versionList);
      addData(true, pageResp);
      updateLoadStatus(LoadStatusX.success);
      update();
    } else {
      updateLoadStatus(LoadStatusX.error);
      update();
    }
  }

  @override
  void onLoadMore() {}

  @override
  void search(String value) {}
}

class VersionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VersionController());
  }
}
