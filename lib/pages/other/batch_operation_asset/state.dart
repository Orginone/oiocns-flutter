

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/assets_info.dart';

class BatchOperationAssetState extends BaseGetState{

  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <AssetsInfo>[].obs;

  BatchOperationAssetState() {
    List<AssetsInfo> list = Get.arguments?["list"] ?? [];
    if (list.isNotEmpty) {
      for (var element in list) {
        element.initStatus();
      }
    }
    selectAssetList.value = list;
  }
}