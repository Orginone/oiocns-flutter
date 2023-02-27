import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/hive_utils.dart';

class AssetManagement {
  static final AssetManagement _instance = AssetManagement._();

  factory AssetManagement() => _instance;

  AssetManagement._();

  final List<MyAssetsList> _assets = [];

  List<MyAssetsList> get assets => _assets;

  Future<void> initAssets() async {
    ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "assets_data",
        {
          "match": {
            "USER":{"value":HiveUtils.getUser()?.userName??""}
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company");
    _assets.clear();
    if (result.success) {
      for (var json in result.data) {
        _assets.add(MyAssetsList.fromJson(json));
      }
    }
  }

  MyAssetsList findAsset(String code) {
    return _assets.where((element) => element.assetCode == code).first;
  }

  List<MyAssetsList> deepCopyAssets() {
    var list = _assets.map((e) => e.toJson()).toList();
    return list.map((e) => MyAssetsList.fromJson(e)).toList();
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
