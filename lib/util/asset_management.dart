import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/hive_utils.dart';

import 'toast_utils.dart';

class AssetManagement {
  static final AssetManagement _instance = AssetManagement._();

  factory AssetManagement() => _instance;

  AssetManagement._();

  final List<AssetsInfo> _assets = [];

  List<AssetsInfo> get assets => _assets;


  SettingController get _settingCtrl => Get.find<SettingController>();

  Future<void> initAssets() async {
    ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "assets_data",
        {
          "match": {
            "USER":HiveUtils.getUser()?.person?.id??"",
            "LIUCZT":3,
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        _settingCtrl.user.id);
    _assets.clear();
    if (result.success) {
      for (var json in result.data) {
        _assets.add(AssetsInfo.fromJson(json));
      }
    }else{
      // ToastUtils.showMsg(msg: "获取资产数据失败");
      print('获取资产数据失败');
    }
  }

  AssetsInfo? findAsset(String code) {
    var list = _assets.where((element) => element.assetCode == code);
    if(list.isEmpty){
      return null;
    }
    return list.first;
  }

  List<AssetsInfo> deepCopyAssets() {
    var list = _assets.map((e) => e.toJson()).toList();
    return list.map((e) => AssetsInfo.fromJson(e)).toList();
  }

  Future<void> updateAssets(UpdateAssetsRequest request) async {
     await KernelApi.getInstance().anystore.update(
        "assets_data",
        {
          "match": {
            "ASSET_CODE": request.assetCode,
          },
          "update": {
            "_set_": {
              ...request.updateData,
              "UPDATE_TIME": DateTime.now().toString(),
            }
          }
        },
        "company").then((value){
          if(value.success){
           var data =  _assets.where((element) => element.assetCode == request.assetCode);
           if(data.isNotEmpty){
             data.first.update(request.updateData);
           }
          }
     });

  }

  Future<void> updateAssetsForList(List<UpdateAssetsRequest> requests) async {
    for (var value in requests) {
      await updateAssets(value);
    }
  }
}

class UpdateAssetsRequest {
  final String assetCode;
  final Map<String, dynamic> updateData;

  UpdateAssetsRequest({required this.assetCode, required this.updateData});
}
