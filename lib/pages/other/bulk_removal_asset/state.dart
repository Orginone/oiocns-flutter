import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/assets_info.dart';

class BulkRemovalAssetState extends BaseGetState {
  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <AssetsInfo>[].obs;

  late String info;

  BulkRemovalAssetState() {
    List<AssetsInfo> list = Get.arguments?["list"] ?? [];
    info = Get.arguments?['info']??"";
    if (list.isNotEmpty) {
      for (var element in list) {
        element.initStatus();
      }
    }
    selectAssetList.value = list;
  }
}
