import 'package:fluttertoast/fluttertoast.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/check_reload.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class CheckNetwork {
  static Future<List<MyAssetsList>> queryCheckList(
      {required String stockTaskCode, required int status}) async {
    List<MyAssetsList> assets = [];

    ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "asset_checklist",
        {
          "match": {
            "stockTaskCode": stockTaskCode,
            "status": status,
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company");
    if (result.success) {
      for (var json in result.data) {
        assets.add(MyAssetsList.fromJson(json));
      }
    }
    return assets;
  }

  static Future<void> performInventory(
      {required int status, required String code, String? remark}) async {
    await KernelApi.getInstance()
        .anystore
        .update(
            "asset_checklist",
            {
              "match": {
                "ASSET_CODE": code,
              },
              "update": {
                "_set_": {
                  "status": status,
                  "assetRemark": remark,
                  "UPDATE_TIME": DateTime.now().toString(),
                }
              }
            },
            "company")
        .then((value) {
      if (value.success) {
        ToastUtils.showMsg(msg: "操作成功");
        EventBusHelper.fire(CheckReload());
      }
    });
  }

  static Future<void> allInventory({required List<MyAssetsList> assets}) async {
    for (var element in assets) {
      await KernelApi.getInstance().anystore.update(
          "asset_checklist",
          {
            "match": {
              "ASSET_CODE": element.assetCode,
            },
            "update": {
              "_set_": {
                "status": 1,
                "UPDATE_TIME": DateTime.now().toString(),
              }
            }
          },
          "company");
    }
    ToastUtils.showMsg(msg: "操作成功");
    EventBusHelper.fire(CheckReload());
  }


  static Future<MyAssetsList?> getQrScanData() async {
    MyAssetsList? assets;

    ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "asset_checklist",
        {
          "match": {
            "ASSET_CODE":"ZCGL2023022800000043",
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company");
    if(result.success){
      if(result.data.isNotEmpty){
        var data = MyAssetsList.fromJson(result.data.first);
        if(data.userName != HiveUtils.getUser()?.userName){
          ToastUtils.showMsg(msg: "这个二维码的使用人并非当前登录用户");
        }else{
          assets = data;
        }
      }
    }else{
      ToastUtils.showMsg(msg: "获取内容失败");
    }
    return assets;
  }

}
