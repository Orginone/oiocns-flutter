import 'package:orginone/routers.dart';

class FunctionItem {
  final String name;
  final String iconUrl;
  final AssetsType type;

  FunctionItem(this.name, this.iconUrl, this.type);
}


//资产列表页功能区分
enum AssetsListType {
  draft,//草稿
  submitted,//已提交
  approved,//已审批
  check,//盘点
  myAssets,//我的资产
  myGoods,//我的物品
}


enum AssetsType {
  myAssets,
  approve,
  check,
  claim,
  subscribe,
  dispose,
  transfer,
  borrow,
  revert,
  handOver,
  store,
  more,
}

extension ExAssetsType on AssetsType {
  String get billHeader{
    switch (this) {
      case AssetsType.myAssets:
      case AssetsType.approve:
      case AssetsType.check:
      case AssetsType.subscribe:
      case AssetsType.borrow:
      case AssetsType.revert:
      case AssetsType.store:
      case AssetsType.more:
       return "";
      case AssetsType.dispose:
        return "ZCCZ";
      case AssetsType.transfer:
        return "ZCYJ";
      case AssetsType.handOver:
        return "ZCJH";
      case AssetsType.claim:
        return "ZCSY";
    }
  }

  String get name {
    switch (this) {
      case AssetsType.myAssets:
        return "资产";
      case AssetsType.approve:
        return "审批";
      case AssetsType.check:
        return "盘点";
      case AssetsType.claim:
        return "申领";
      case AssetsType.subscribe:
        return "申购";
      case AssetsType.dispose:
        return "处置";
      case AssetsType.transfer:
        return "移交";
      case AssetsType.borrow:
        return "借用";
      case AssetsType.revert:
        return "归还";
      case AssetsType.handOver:
        return "交回";
      case AssetsType.store:
        return "";
      case AssetsType.more:
        return "";
    }
  }

  String get createRoute {
    switch (this) {
      case AssetsType.myAssets:
        return "";
      case AssetsType.approve:
        return "";
      case AssetsType.check:
        return "";
      case AssetsType.claim:
        return Routers.createClaim;
      case AssetsType.subscribe:
        return "";
      case AssetsType.dispose:
        return Routers.createDispose;
      case AssetsType.transfer:
        return Routers.createTransfer;
      case AssetsType.borrow:
        return "";
      case AssetsType.revert:
        return "";
      case AssetsType.handOver:
        return Routers.createHandOver;
      case AssetsType.store:
        return "";
      case AssetsType.more:
        return "";
    }
  }
}

//单据类型
enum DocumentsType{
  transfer,
  change,
  management,
  apply,
  buy,
}

extension ExDocumentsType on DocumentsType{
  String get name {
    switch (this) {
      case DocumentsType.transfer:
        return "移交单";
      case DocumentsType.change:
        return "变动单";
      case DocumentsType.management:
        return "处置单";
      case DocumentsType.apply:
        return "申领单";
      case DocumentsType.buy:
        return "申购单";
    }
  }

  String get detailed{
    switch (this) {
      case DocumentsType.transfer:
        return "移交明细";
      case DocumentsType.change:
        return "变动明细";
      case DocumentsType.management:
        return "处置明细";
      case DocumentsType.apply:
        return "申领明细";
      case DocumentsType.buy:
        return "申购明细";
    }
  }
}

//
final Map<int,String> CheckStatus ={
  0:"未盘点",
  1:"盘点中",
  2:"完成盘点",
  3:"终止盘点",
};


//CenterFunction用的tab显示字段
final Map<AssetsType, List<String>> CenterFunctionTabTitle = {
  AssetsType.approve: ["待审核", "已审核"],
  AssetsType.claim: ["草稿","已提交", "已审批"],
  AssetsType.transfer: ["草稿","已提交", "已审批"],
  AssetsType.dispose: ["草稿","已提交", "已审批"],
  AssetsType.handOver: ["草稿","已提交", "已审批"],
  AssetsType.check:[],
  AssetsType.myAssets:["我的资产","我的物品"],
};

final List<String> SearchContent = ["单据编号", "提交人"];

final List<String> AssetsDetailsTabTitle = ["详情","审批流程"];

final List<String> AssetsCheckTabTitle = ["未盘点","盘存","盘亏"];


final List<String> BillType = [
  "全部单据",
  "物品申请",
  "物品入库",
  "物品领用",
  "物品出库",
  "物品申领",
  "物品申购",
  "资产变动",
  "资产处理",
  "资产移交",
  "资产借用",
  "资产归还",
  "资产交回"
];

final List<String> DisposeTyep = [
  '报废（集中处置）',
  '报废（自行处置）',
  '调拨（无偿调拨）',
  '公开出售/转让/出让',
  '协议出售/转让/出让',
  '报损',
  '捐赠',
  '置换',
  '退货',
  '货币性损失',
  '错账更正',
];

final List<String> ApprovalStatus = ["全部状态", "通过", "未通过"];

final List<String> DraftTips = ["保存草稿","放弃更改","取消"];

final List<String> AssetAcceptanceUnitType = [
  "区域外",
  "系统内"
];

final List<String> Whether = ["是","否"];