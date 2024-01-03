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
    billCode = json['stockTaskCode'] ?? json['BILL_CODE'];
    applyRemark = json['APPLY_REMARK'] ?? json['REMARK'] ?? json['applyRemark'];
    type = json['type'];
    oldUserId = json['OLD_USER_ID'];
    keeperId = json['KEEPER_ID'];
    keeperOrgId = json['KEEP_ORG_ID'];
    approvalDocument = json['approvalDocument'] != null
        ? ApprovalDocument.fromJson(json['approvalDocument'])
        : null;

    submitterName = json['submitterName'] ?? json['SUBMITTER_NAME'];
    // submitUserName = json['submitUserName'];
    userName = json['USER_NAME'].toString();
    status = json['status'];
    createTime = DateTime.tryParse(json['CREATE_TIME'] ?? "");
    updateTime = DateTime.tryParse(json['UPDATE_TIME'] ?? "");
    way = int.tryParse(json['way'].toString()) ??
        int.tryParse(json['DISPOSE_TYPE'].toString());
    keepOrgName = json['ACC_UNIT'] ?? json['keepOrgName'];
    keepOrgType = json['IS_SYS_UNIT'] ?? json['keepOrgType'];
    evaluated = json['evaluated'] is int ? json['evaluated'] : null;
    assetsTotal = json['SHEJIZCZZ'] ?? json['assetsTotal'];
    keepOrgPhoneNumber = json['keepOrgPhoneNumber'];
    depreciationTotal = json['LEIJIZJHJ'] ?? json['depreciationTotal'];
    netWorthTotal = json['JINGZHIHJ'] ?? json['netWorthTotal'];
    count = int.tryParse(json['count'].toString());
    editStatus = json['editStatus'];
    approvalEnd = int.tryParse(json['approvalEnd'].toString());
    approvalStatus = int.tryParse(json['APPROVAL_STATUS'].toString());
    verificationStatus = int.tryParse(json['verificationStatus'].toString());
    readStatus = json['readStatus'];
    gmtCreate = DateTime.tryParse(json['gmtCreate'] ?? "");
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
      if (detail!.isNotEmpty) {
        approvalDocument = ApprovalDocument()..detail = [];
        for (var value in detail!) {
          var item;
          if (item != null) {
            approvalDocument!.detail!.add(item);
          }
        }
      }
    }
    stockTaskName = json['stockTaskName'];
    stockMethod = json['stockMethod'];
    stockStatus = json['stockStatus'];
    submitUserId = json['submitUserId'] ?? json['SUBMITTER_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BILL_CODE'] = billCode;
    data['APPLY_REMARK'] = applyRemark;
    data['REMARK'] = applyRemark;
    data['applyRemark'] = applyRemark;
    data['type'] = type;
    data['OLD_USER_ID'] = oldUserId;
    data['KEEPER_ID'] = keeperId;
    data['KEEP_ORG_ID'] = keeperOrgId;
    // data['submitUserName'] = this.submitUserName;
    data['SUBMITTER_NAME'] = submitterName;
    data['USER_NAME'] = userName;
    data['status'] = status;
    data['CREATE_TIME'] = createTime;
    data['UPDATE_TIME'] = updateTime;
    data['way'] = way;
    data['DISPOSE_TYPE'] = way;
    data['evaluated'] = evaluated;
    data['SHEJIZCZZ'] = assetsTotal;
    data['LEIJIZJHJ'] = depreciationTotal;
    data['JINGZHIHJ'] = netWorthTotal;
    data['ACC_UNIT'] = keepOrgName;
    data['keepOrgName'] = keepOrgName;
    data['IS_SYS_UNIT'] = keepOrgType;
    data['keepOrgType'] = keepOrgType;
    data['count'] = count;
    data['keepOrgPhoneNumber'] = keepOrgPhoneNumber;
    data['editStatus'] = editStatus;
    data['approvalEnd'] = approvalEnd;
    data['APPROVAL_STATUS'] = approvalStatus;
    data['verificationStatus'] = verificationStatus;
    data['readStatus'] = readStatus;
    data['gmtCreate'] = gmtCreate;
    data['id'] = id;
    data['verificationDate'] = verificationDate;
    data['verificationDocumentsNumber'] = verificationDocumentsNumber;
    data['verificationManId'] = verificationManId;
    data['verificationManName'] = verificationManName;
    if (detail != null) {
      data['detail'] = detail;
    }
    if (approvalDocument != null) {
      data['approvalDocument'] = approvalDocument!.toJson();
    }
    data['stockTaskName'] = stockTaskName;
    data['stockMethod'] = stockMethod;
    data['stockStatus'] = stockStatus;
    data['submitUserId'] = submitUserId;
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
        detail!.add(AssetsInfo.fromJson(v));
      });
    }
    if (json['details'] != null) {
      json['details'].forEach((v) {
        detail!.add(AssetsInfo.fromJson(v));
      });
    }
    createUser = json['CREATE_USER'];
    submitUserName = json['submitUserName'];
    status = json['status'];
    createTime = DateTime.tryParse(json['CREATE_TIME'] ?? "");
    updateTime = DateTime.tryParse(json['UPDATE_TIME'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OLD_USER_ID'] = oldOrgId;
    data['KEEPER_ID'] = keeperId;
    data['KEEP_ORG_ID'] = keeperId;
    data['OLD_ORG_ID'] = oldOrgId;
    data['OLD_ORG_NAME'] = oldOrgName;
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    data['CREATE_USER'] = createUser;
    data['submitUserName'] = submitUserName;
    data['status'] = status;
    data['CREATE_TIME'] = createTime;
    data['UPDATE_TIME'] = updateTime;
    return data;
  }
}
