import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/util/asset_management.dart';

import '../../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class AssetsController extends BaseListController<AssetsState> {
  final AssetsState state = AssetsState();

  late AssetsListType assetsListType;

  AssetsController(this.assetsListType);

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if(event is LoadAssets && assetsListType == AssetsListType.myAssets){
      loadData();
    }
  }

  @override
  void search(String value) async{
    await loadData(code: value);
  }

  Future<void> loadData({String? code}) async {
    var data = AssetManagement().deepCopyAssets();
    if(code!=null && code.isNotEmpty){
      var flitter = data.where((element) => element.assetCode?.contains(code)??false);
      data = flitter.toList();
    }
    state.dataList.value = data;
    loadSuccess();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadData();
  }

  @override
  Future onLoadMore() {
    // TODO: implement onLoadMore
    return super.onLoadMore();
  }

  void create(AssetsType assetsType) {
    Get.toNamed(assetsType.createRoute);
  }
}
