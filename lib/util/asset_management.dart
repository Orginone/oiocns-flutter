import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/my_assets_list.dart';

class AssetManagement {
  static final AssetManagement _instance = AssetManagement._();

  factory AssetManagement() => _instance;

  AssetManagement._();

  final List<MyAssetsList> _assets = [];

  List<MyAssetsList> get assets => _assets;

  Future<void> initAssets() async {
    if(_assets.isNotEmpty){
      return;
    }
    ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "assets_data",
        {
          "match": {},
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company");
    _assets.clear();
    if (result.success) {
      _assets.clear();
      for (var json in result.data) {
        _assets.add(MyAssetsList.fromJson(json));
      }
    }
  }

  MyAssetsList findAsset(String id) {
    return _assets.where((element) => element.id == id).first;
  }

  List<MyAssetsList> deepCopyAssets() {
    var list = _assets!.map((e) => e.toJson()).toList();
    return list.map((e) => MyAssetsList.fromJson(e)).toList();
  }

  Future<void> updateAssets(UpdateAssetsRequest request) async {
    ResultType result = await KernelApi.getInstance().anystore.update(
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
        "company");
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
