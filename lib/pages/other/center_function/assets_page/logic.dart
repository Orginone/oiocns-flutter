import 'package:get/get.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/assets_page/network.dart';
import 'package:orginone/routers.dart';
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
  void onReceivedEvent(event) async {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is LoadAssets) {
      await loadData();
    }
  }

  @override
  Future<void> loadData(
      {bool isRefresh = false, bool isLoad = false, String? code}) async {
    switch (assetsType) {
      case AssetsType.myAssets:
        await loadAssets(code: code, isRefresh: isRefresh);
        break;
      case AssetsType.check:
        await loadAssetUse("asset_check", code: code);
        break;
      case AssetsType.claim:
        loadAssetUse("asset_receive", code: code);
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

  @override
  void search(String value) async {
    await loadData(code: value);
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
    } else if (assetsListType != AssetsListType.check) {
      filter['status'] = assetsListType == AssetsListType.draft ? 0 : 1;
    }

    var data = await AssetNetWork.getAssetUseList(name: name, filter: filter);
    if (code != null && code.isNotEmpty) {
      var flitter = data.where((element) {
        if (assetsType == AssetsType.check) {
          return element.stockTaskName?.contains(code) ?? false;
        } else {
          return element.billCode?.contains(code) ?? false;
        }
      });
      data = flitter.toList();
    }
    state.dataList.value = data;

    loadSuccess();
  }

  Future<void> loadAssets({String? code, bool isRefresh = false}) async {
    if (isRefresh) {
      await AssetManagement().initAssets();
    }
    var data = AssetManagement().deepCopyAssets();
    if (code != null && code.isNotEmpty) {
      var flitter =
          data.where((element) => element.assetCode?.contains(code) ?? false);
      data = flitter.toList();
    }
    state.dataList.value = data;
    loadSuccess();
  }

  void create(AssetsType assetsType) {
    Get.toNamed(assetsType.createRoute);
  }

  void jumpBatchAssets() {
    var list = state.dataList.where((p0) => p0.notLockStatus).toList();
    Get.toNamed(
      Routers.batchOperationAsset,
      arguments: {
        "list": list,
      },
    );
  }

  void qrScan() {
    Get.toNamed(Routers.qrScan)?.then((value) {
      if (value != null) {
        AssetNetWork.getQrScanData().then((value){
          if(value!=null){
            Get.toNamed(Routers.assetsDetails,arguments: {"assets":value});
          }
        });
      }
    });
  }
}
