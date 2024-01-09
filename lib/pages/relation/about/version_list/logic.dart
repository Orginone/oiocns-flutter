import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/relation/about/version_list/item.dart';
import 'package:orginone/pages/relation/about/version_list/state.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/system/update_utils.dart';

class VersionListController extends BaseController<VersionListState> {
  @override
  VersionListState state = VersionListState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getVersionList();
  }

  void backToHome() {
    Get.back();
  }

  void showDiaLog(BuildContext context, VersionItem item) {
    showVersionItemDetail(context, item);
  }

  getVersionList() async {
    List<UpdateModel> loadHistoryVersionInfo =
        await UpdateRequest.loadHistoryVersionInfo();
    if (loadHistoryVersionInfo.isNotEmpty) {
      loadHistoryVersionInfo.sort((a1, a2) {
        if (a2.updateTime!.isEmpty || a1.updateTime!.isEmpty) {
          return 0;
        }
        return DateTime.parse(a2.updateTime ?? '')
            .compareTo(DateTime.parse(a1.updateTime ?? ''));
      });
    }

    state.loadHistoryVersionInfo.value = loadHistoryVersionInfo;
  }
}
