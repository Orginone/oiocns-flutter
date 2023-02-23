import 'package:get/get.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/assets_page/network.dart';
import 'package:orginone/util/asset_management.dart';

import '../../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class AssetsController extends BaseListController<AssetsState> {
  final AssetsState state = AssetsState();

  late AssetsListType assetsListType;

  late AssetsType assetsType;

  AssetsController(this.assetsListType,this.assetsType);

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReceivedEvent(event) async{
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if(event is LoadAssets){
      await loadData();
    }
  }

  @override
  void search(String value) async{
    await loadData(code: value);
  }

  @override
  Future<void> loadData({String? code}) async {

    switch(assetsType){
      case AssetsType.myAssets:
        loadAssets(code: code);
        break;
      case AssetsType.check:
        // TODO: Handle this case.
        break;
      case AssetsType.claim:
        // TODO: Handle this case.
        break;
      case AssetsType.dispose:
        await loadAssetUse("disposal", code: code);
        break;
      case AssetsType.transfer:
        await loadAssetUse("asset_transfer", code: code);
        break;
      case AssetsType.handOver:
        await loadAssetUse("asset_restore", code: code);
        break;
    }
  }

  Future<void> loadAssetUse(String name, {String? code}) async {
    Map<String, dynamic> filter = {};
    if (assetsType == AssetsType.dispose) {
      filter["readStatus"] = assetsListType == AssetsListType.draft ? 0 : 1;
      if (assetsListType == AssetsListType.approved) {
        filter["verificationStatus"] = 10;
      } else if (assetsListType == AssetsListType.submitted) {
        filter["verificationStatus"] = 0;
      }
    } else {
      filter['status'] = assetsListType == AssetsListType.draft ? 0 : 1;
    }

    var data = await AssetNetWork.getAssetUseList(name: name, filter: filter);
    if (code != null && code.isNotEmpty) {
      var flitter =
          data.where((element) => element.billCode?.contains(code) ?? false);
      data = flitter.toList();
    }
    state.useList.value = data;

    loadSuccess();
  }

  void loadAssets({String? code}) {
    var data = AssetManagement().deepCopyAssets();
    if (code != null && code.isNotEmpty) {
      var flitter =
          data.where((element) => element.assetCode?.contains(code) ?? false);
      data = flitter.toList();
    }
    state.dataList.value = data;
    loadSuccess();
  }

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await loadData();
  }


  void create(AssetsType assetsType) {
    Get.toNamed(assetsType.createRoute);
  }
}
