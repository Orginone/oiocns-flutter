import 'my_assets_list.dart';

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
  String? submitUserName;
  String? userName;



  AssetUse(
      {this.billCode,
        this.applyRemark,
        this.type,
        this.oldUserId,
        this.keeperId,
        this.keeperOrgId,
        this.approvalDocument});

  AssetUse.fromJson(Map<String, dynamic> json) {
    billCode = json['BILL_CODE'];
    applyRemark = json['APPLY_REMARK'];
    type = json['type'];
    oldUserId = json['OLD_USER_ID'];
    keeperId = json['KEEPER_ID'];
    keeperOrgId = json['KEEP_ORG_ID'];
    approvalDocument = json['approvalDocument'] != null
        ? new ApprovalDocument.fromJson(json['approvalDocument'])
        : null;

    submitterName = json['SUBMITTER_NAME'];
    submitUserName = json['submitUserName'];
    userName = json['USER_NAME'];
    status = json['status'];
    createTime = DateTime.tryParse(json['CREATE_TIME']??"");
    updateTime = DateTime.tryParse(json['UPDATE_TIME']??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILL_CODE'] = this.billCode;
    data['APPLY_REMARK'] = this.applyRemark;
    data['type'] = this.type;
    data['OLD_USER_ID'] = this.oldUserId;
    data['KEEPER_ID'] = this.keeperId;
    data['KEEP_ORG_ID'] = this.keeperOrgId;
    data['submitUserName'] = this.submitUserName;
    data['SUBMITTER_NAME'] = this.submitterName;
    data['USER_NAME'] = this.userName;
    data['status'] = this.status;
    data['CREATE_TIME'] = this.createTime;
    data['UPDATE_TIME'] = this.updateTime;
    if (this.approvalDocument != null) {
      data['approvalDocument'] = this.approvalDocument!.toJson();
    }
    return data;
  }
}

class ApprovalDocument {
  String? oldUserId;
  String? keeperId;
  String? keepOrgId;
  String? oldOrgId;
  String? oldOrgName;
  List<MyAssetsList>? detail;
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
    if (json['detail'] != null) {
      detail = <MyAssetsList>[];
      json['detail'].forEach((v) {
        detail!.add(new MyAssetsList.fromJson(v));
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

