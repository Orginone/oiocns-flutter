


import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/assets_config.dart';

class AssetsInternalControlState extends BaseGetListState<AssetsInfo>{

}

final List<FunctionItem> items = [
  FunctionItem(
      "资产申领",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-claim.png",
      AssetsType.claim),
  FunctionItem(
      "资产盘点",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-check.png",
      AssetsType.check),
  FunctionItem(
      "资产处置",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-dispose.png",
      AssetsType.dispose),
  FunctionItem(
      "资产移交",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-transfer.png",
      AssetsType.transfer),
  FunctionItem(
      "资产交回",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-transfer.png",
      AssetsType.handOver),
  FunctionItem(
      "资产变动",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/inspection-icon.png",
      AssetsType.more),
  FunctionItem(
      "资产分配",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/report-icon.png",
      AssetsType.more),
  FunctionItem(
      "资产申购",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/work-order-icon.png",
      AssetsType.more),
];