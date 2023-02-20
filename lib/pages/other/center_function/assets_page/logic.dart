import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';

import '../../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class AssetsController extends BaseListController<AssetsState> {
  final AssetsState state = AssetsState();

  late AssetsListType assetsListType;

  AssetsController(this.assetsListType);



  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();

  }

  @override
  void search(String value) {}


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.dataList.value = List.generate(10, (index) => index);
  }

  void create(AssetsType assetsType) {
    Get.toNamed(assetsType.createRoute);
  }
}
