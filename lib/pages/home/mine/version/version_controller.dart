import 'dart:io';

import 'package:get/get.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/version_entity.dart';

import '../../../../controller/file_controller.dart';
import '../../../../public/http/base_list_controller.dart';
import '../../../../public/loading/load_status.dart';

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
