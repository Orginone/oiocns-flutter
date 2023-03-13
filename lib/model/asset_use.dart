import 'package:orginone/util/asset_management.dart';

import 'assets_info.dart';

class AssetUse {
  String? billCode;
  String? applyRemark;
  int? type;
  ApprovalDocument? approvalDocument;
  dynamic status;
  DateTime? createTime;
  DateTime? updateTime;

  //资产移交字段
  String? oldUserId;
  String? keeperId;
  String? keeperOrgId;


  //资产交回
  String? submitterName;
  // String? submitUserName;
  String? userName;

  //资产处置
  int? way;
  int? evaluated;
  dynamic assetsTotal;
  dynamic depreciationTotal;
  dynamic netWorthTotal;
  dynamic count;
  int? editStatus;
  int? approvalEnd;
  int? approvalStatus;
  int? verificationStatus;
  int? readStatus;
  String? keepOrgName;
  dynamic keepOrgType;
  dynamic keepOrgPhoneNumber;
  DateTime? gmtCreate;
  String? id;
  String? verificationDate;
  String? verificationDocumentsNumber;
  String? verificationManId;
  String? verificationManName;
  List<String>? detail;

  //资产盘点
  String? stockTaskName;
  dynamic stockMethod;
  int? stockStatus;
  String? submitUserId;



  AssetUse(
      {this.billCode,
        this.applyRemark,
        this.type,
        this.oldUserId,
        this.keeperId,
        this.keeperOrgId,
        this.approvalDocument});

  AssetUse.fromJson(Map<String, dynamic> json) {
    billCode = json['stockTaskCode']??json['BILL_CODE'];
    applyRemark = json['APPLY_REMARK']??json['REMARK']??json['applyRemark'];
    type = json['type'];
    oldUserId = json['OLD_USER_ID'];
    keeperId = json['KEEPER_ID'];
    keeperOrgId = json['KEEP_ORG_ID'];
    approvalDocument = json['approvalDocument'] != null
        ? new ApprovalDocument.fromJson(json['approvalDocument'])
        : null;

    submitterName = json['submitterName']??json['SUBMITTER_NAME'];
    // submitUserName = json['submitUserName'];
    userName = json['USER_NAME'];
    status = json['status'];
    createTime = DateTime.tryParse(json['CREATE_TIME']??"");
    updateTime = DateTime.tryParse(json['UPDATE_TIME']??"");
    way = int.tryParse(json['way'].toString())??int.tryParse(json['DISPOSE_TYPE'].toString());
    keepOrgName = json['ACC_UNIT']??json['keepOrgName'];
    keepOrgType = json['IS_SYS_UNIT']??json['keepOrgType'];
    evaluated = json['evaluated'] is int?json['evaluated']:null;
    assetsTotal = json['SHEJIZCZZ']??json['assetsTotal'];
    keepOrgPhoneNumber = json['keepOrgPhoneNumber'];
    depreciationTotal = json['LEIJIZJHJ']??json['depreciationTotal'];
    netWorthTotal = json['JINGZHIHJ']??json['netWorthTotal'];
    count = int.tryParse(json['count'].toString());
    editStatus = json['editStatus'];
    approvalEnd = int.tryParse(json['approvalEnd'].toString());
    approvalStatus = int.tryParse(json['APPROVAL_STATUS'].toString());
    verificationStatus = int.tryParse(json['verificationStatus'].toString());
    readStatus = json['readStatus'];
    gmtCreate = DateTime.tryParse(json['gmtCreate']??"");
    id = json['id'];
    verificationDate = json['verificationDate'];
    verificationDocumentsNumber = json['verificationDocumentsNumber'];
    verificationManId = json['verificationManId'];
    verificationManName = json['verificationManName'];
    if (json['detail'] != null) {
      detail = <String>[];
      json['detail'].forEach((v) {
        detail!.add(v);
      });
      if(detail!.isNotEmpty){
        approvalDocument = ApprovalDocument()..detail = [];
        for (var value in detail!) {
          var item =  AssetManagement().findAsset(value);
          if(item!=null){
            approvalDocument!.detail!.add(item);
          }
        }
      }
    }
    stockTaskName = json['stockTaskName'];
    stockMethod = json['stockMethod'];
    stockStatus = json['stockStatus'];
    submitUserId = json['submitUserId']??json['SUBMITTER_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILL_CODE'] = this.billCode;
    data['APPLY_REMARK'] = this.applyRemark;
    data['REMARK'] = this.applyRemark;
    data['applyRemark'] = this.applyRemark;
    data['type'] = this.type;
    data['OLD_USER_ID'] = this.oldUserId;
    data['KEEPER_ID'] = this.keeperId;
    data['KEEP_ORG_ID'] = this.keeperOrgId;
    // data['submitUserName'] = this.submitUserName;
    data['SUBMITTER_NAME'] = this.submitterName;
    data['USER_NAME'] = this.userName;
    data['status'] = this.status;
    data['CREATE_TIME'] = this.createTime;
    data['UPDATE_TIME'] = this.updateTime;
    data['way'] = this.way;
    data['DISPOSE_TYPE'] = this.way;
    data['evaluated'] = this.evaluated;
    data['SHEJIZCZZ'] = this.assetsTotal;
    data['LEIJIZJHJ'] = this.depreciationTotal;
    data['JINGZHIHJ'] = this.netWorthTotal;
    data['ACC_UNIT'] = keepOrgName;
    data['keepOrgName'] = keepOrgName;
    data['IS_SYS_UNIT'] =  keepOrgType;
    data['keepOrgType'] = keepOrgType;
    data['count'] = this.count;
    data['keepOrgPhoneNumber'] =keepOrgPhoneNumber;
    data['editStatus'] = this.editStatus;
    data['approvalEnd'] = this.approvalEnd;
    data['APPROVAL_STATUS'] = this.approvalStatus;
    data['verificationStatus'] = this.verificationStatus;
    data['readStatus'] = this.readStatus;
    data['gmtCreate'] = this.gmtCreate;
    data['id'] = this.id;
    data['verificationDate'] = this.verificationDate;
    data['verificationDocumentsNumber'] = this.verificationDocumentsNumber;
    data['verificationManId'] = this.verificationManId;
    data['verificationManName'] = this.verificationManName;
    if (this.detail != null) {
      data['detail'] = this.detail;
    }
    if (this.approvalDocument != null) {
      data['approvalDocument'] = this.approvalDocument!.toJson();
    }
    data['stockTaskName'] = this.stockTaskName;
    data['stockMethod'] = this.stockMethod;
    data['stockStatus'] = this.stockStatus;
    data['submitUserId'] = this.submitUserId;
    return data;
  }
}

class ApprovalDocument {
  String? oldUserId;
  String? keeperId;
  String? keepOrgId;
  String? oldOrgId;
  String? oldOrgName;
  List<AssetsInfo>? detail;
  String? createUser;
  String? submitUserName;
  dynamic status;
  DateTime? createTime;
  DateTime? updateTime;

  ApprovalDocument(
      {this.oldUserId,
        this.keeperId,
        this.keepOrgId,
        this.oldOrgId,
        this.oldOrgName,
        this.detail,
        this.status,
        this.createUser,
        this.submitUserName,
        this.createTime,
        this.updateTime});

  ApprovalDocument.fromJson(Map<String, dynamic> json) {
    oldOrgId = json['OLD_USER_ID'];
    keeperId = json['KEEPER_ID'];
    keepOrgId = json['KEEP_ORG_ID'];
    oldOrgId = json['OLD_ORG_ID'];
    oldOrgName = json['OLD_ORG_NAME'];
    detail = <AssetsInfo>[];
    if (json['detail'] != null) {
      json['detail'].forEach((v) {
        detail!.add(new AssetsInfo.fromJson(v));
      });
    }
    if (json['details'] != null) {
      json['details'].forEach((v) {
        detail!.add(new AssetsInfo.fromJson(v));
      });
    }
    createUser = json['CREATE_USER'];
    submitUserName = json['submitUserName'];
    status = json['status'];
    createTime = DateTime.tryParse(json['CREATE_TIME']??"");
    updateTime = DateTime.tryParse(json['UPDATE_TIME']??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OLD_USER_ID'] = this.oldOrgId;
    data['KEEPER_ID'] = this.keeperId;
    data['KEEP_ORG_ID'] = this.keeperId;
    data['OLD_ORG_ID'] = this.oldOrgId;
    data['OLD_ORG_NAME'] = this.oldOrgName;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    data['CREATE_USER'] = this.createUser;
    data['submitUserName'] = this.submitUserName;
    data['status'] = this.status;
    data['CREATE_TIME'] = this.createTime;
    data['UPDATE_TIME'] = this.updateTime;
    return data;
  }
}

