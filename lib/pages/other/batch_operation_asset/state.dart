

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';

class BatchOperationAssetState extends BaseGetState{

  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <MyAssetsList>[].obs;

  BatchOperationAssetState() {
    List<MyAssetsList> list = Get.arguments?["list"] ?? [];
    if (list.isNotEmpty) {
      for (var element in list) {
        element.initStatus();
      }
    }
    selectAssetList.value = list;
  }
}