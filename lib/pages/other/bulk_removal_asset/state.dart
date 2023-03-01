import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/add_asset/state.dart';

class BulkRemovalAssetState extends BaseGetState {
  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <MyAssetsList>[].obs;

  late String info;

  BulkRemovalAssetState() {
    List<MyAssetsList> list = Get.arguments?["list"] ?? [];
    info = Get.arguments?['info']??"";
    if (list.isNotEmpty) {
      for (var element in list) {
        element.initStatus();
      }
    }
    selectAssetList.value = list;
  }
}