import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ChoiceAssetsState extends BaseGetState {
  TextEditingController searchController = TextEditingController();

  var mockList = <ChildList>[].obs;

  //显示搜索页面
  var showSearchPage = false.obs;

  //选择的资产
  var selectedAsset = Rxn<ChildList>();

  var searchList = <ChildList>[].obs;

  ChoiceAssetState() {

  }
}




class ChildList {
  int? id;
  String? oldId;
  String? categoryCode;
  String? categoryName;
  String? parentId;
  String? parentCode;
  String? parentName;
  String? firstId;
  String? firstName;
  String? tenantCode;
  int? level;
  String? businessId;
  int? categoryType;
  String? categoryHide;
  String? categoryDelete;
  String? categoryStandardCode;
  String? categoryBusinessCode;
  String? categoryDepreciation;
  String? categoryDepreciationStatus;
  String? categoryUsefulLife;
  String? categoryUnit;
  int? informationType;
  bool? last;
  bool? custom;
  String? templateId;
  List<ChildList>? childList;

  ChildList(
      {this.id,
        this.oldId,
        this.categoryCode,
        this.categoryName,
        this.parentId,
        this.parentCode,
        this.parentName,
        this.firstId,
        this.firstName,
        this.tenantCode,
        this.level,
        this.businessId,
        this.categoryType,
        this.categoryHide,
        this.categoryDelete,
        this.categoryStandardCode,
        this.categoryBusinessCode,
        this.categoryDepreciation,
        this.categoryDepreciationStatus,
        this.categoryUsefulLife,
        this.categoryUnit,
        this.informationType,
        this.last,
        this.custom,
        this.templateId,
        this.childList});

  ChildList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    oldId = json['oldId'];
    categoryCode = json['categoryCode'];
    categoryName = json['categoryName'];
    parentId = json['parentId'];
    parentCode = json['parentCode'];
    parentName = json['parentName'];
    firstId = json['firstId'];
    firstName = json['firstName'];
    tenantCode = json['tenantCode'];
    level = json['level'];
    businessId = json['businessId'];
    categoryType = json['categoryType'];
    categoryHide = json['categoryHide'];
    categoryDelete = json['categoryDelete'];
    categoryStandardCode = json['categoryStandardCode'];
    categoryBusinessCode = json['categoryBusinessCode'];
    categoryDepreciation = json['categoryDepreciation'];
    categoryDepreciationStatus = json['categoryDepreciationStatus'];
    categoryUsefulLife = json['categoryUsefulLife'];
    categoryUnit = json['categoryUnit'];
    informationType = json['informationType'];
    last = json['last'];
    custom = json['custom'];
    templateId = json['templateId'].toString();
    childList = [];
    if(json['childList']!=null){
      json['childList'].forEach((json){
        childList!.add(ChildList.fromJson(json));
      });
    }
  }


  bool isAllLast(){
    if(childList?.isEmpty??true){
      return true;
    }
    return childList!.where((element) => !element.last!).isEmpty;
  }

  List<ChildList> getAllLastList(){
    List<ChildList> list = [];

    for (var element in childList!) {
      if(element.last??false){
        list.add(element);
      }else{
        list.addAll(element.getAllLastList());
      }
    }

    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['oldId'] = this.oldId;
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['parentId'] = this.parentId;
    data['parentCode'] = this.parentCode;
    data['parentName'] = this.parentName;
    data['firstId'] = this.firstId;
    data['firstName'] = this.firstName;
    data['tenantCode'] = this.tenantCode;
    data['level'] = this.level;
    data['businessId'] = this.businessId;
    data['categoryType'] = this.categoryType;
    data['categoryHide'] = this.categoryHide;
    data['categoryDelete'] = this.categoryDelete;
    data['categoryStandardCode'] = this.categoryStandardCode;
    data['categoryBusinessCode'] = this.categoryBusinessCode;
    data['categoryDepreciation'] = this.categoryDepreciation;
    data['categoryDepreciationStatus'] = this.categoryDepreciationStatus;
    data['categoryUsefulLife'] = this.categoryUsefulLife;
    data['categoryUnit'] = this.categoryUnit;
    data['informationType'] = this.informationType;
    data['last'] = this.last;
    data['custom'] = this.custom;
    data['templateId'] = this.templateId;
    data['childList'] = this.childList;
    return data;
  }
}