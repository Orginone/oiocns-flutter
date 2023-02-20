

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ChoicePeopleState extends BaseGetState{
  var choicePeople = Rxn<ChoicePeople>();

  TextEditingController searchController = TextEditingController();

  var selectedUser = Rxn<ZcyUserPos>();

  var selectedGroup = <ChoicePeople>[].obs;


  var searchList = <ZcyUserPos>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;
}



class ChoicePeople {
  String? id;
  dynamic status;
  dynamic isDeleted;
  String? agencyName;
  String? agencyCode;
  dynamic tenantCode;
  String? parentId;
  dynamic createUser;
  dynamic createTime;
  dynamic updateTime;
  dynamic updateUser;
  List<ChoicePeople>? children;
  List<ZcyUserPos>? zcyUserPos;
  dynamic userIds;
  dynamic delUserIds;
  dynamic ids;
  bool isSelected = false;

  ChoicePeople(
      {this.id,
        this.status,
        this.isDeleted,
        this.agencyName,
        this.agencyCode,
        this.tenantCode,
        this.parentId,
        this.createUser,
        this.createTime,
        this.updateTime,
        this.updateUser,
        this.children,
        this.zcyUserPos,
        this.userIds,
        this.delUserIds,
        this.ids});

  ChoicePeople.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    agencyName = json['agencyName'];
    agencyCode = json['agencyCode'];
    tenantCode = json['tenantCode'];
    parentId = json['parentId'];
    createUser = json['createUser'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    if (json['children'] != null) {
      children = <ChoicePeople>[];
      json['children'].forEach((v) {
        children!.add(new ChoicePeople.fromJson(v));
      });
    }
    if (json['zcyUserPos'] != null) {
      zcyUserPos = <ZcyUserPos>[];
      json['zcyUserPos'].forEach((v) {
        zcyUserPos!.add(new ZcyUserPos.fromJson(v));
      });
    }
    userIds = json['userIds'];
    delUserIds = json['delUserIds'];
    ids = json['ids'];
  }

  bool hasSelectedDepartment(){
    return getAllSelectedDepartment().isNotEmpty;
  }

  List<ChoicePeople> getAllDepartment(){
    List<ChoicePeople> all = [];
    if(children?.isNotEmpty??false){

      all.addAll(children!);

      for (var element in children!) {
         if(element.children?.isNotEmpty??false){
           for (var element in children!) {
             all.addAll(element.getAllDepartment());
           }
         }
      }
    }

    return all;
  }

  List<ChoicePeople> getAllSelectedDepartment() {
    List<ChoicePeople> selected = [];
    if(children?.isNotEmpty??false){
      for (var element in children!) {
        if(element.isSelected){
          selected.add(element);
        }
        if(element.children?.isNotEmpty??false){
          for (var element in children!) {
            selected.addAll(element.getAllDepartment());
          }
        }
      }
    }
    return selected;
  }


  bool hasSelectedUser(){
    return getAllSelectedUser().isNotEmpty;
  }

  List<ZcyUserPos> getAllUser(){
    List<ZcyUserPos> selected = [];
    if(zcyUserPos?.isNotEmpty??false){
      selected.addAll(zcyUserPos!);
    }
    if(children?.isNotEmpty??false){
      for (var element in children!) {
        selected.addAll(element.getAllUser());
      }
    }
    return selected;
  }

  List<ZcyUserPos> getAllSelectedUser() {
    List<ZcyUserPos> selected = [];
    if(zcyUserPos?.isNotEmpty??false){
      for (var element in zcyUserPos!) {
        if (element.isSelected) {
          selected.add(element);
        }
      }
    }
    if(children?.isNotEmpty??false){
      for (var element in children!) {
        selected.addAll(element.getAllSelectedUser());
      }
    }
    return selected;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['isDeleted'] = this.isDeleted;
    data['agencyName'] = this.agencyName;
    data['agencyCode'] = this.agencyCode;
    data['tenantCode'] = this.tenantCode;
    data['parentId'] = this.parentId;
    data['createUser'] = this.createUser;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    if (this.zcyUserPos != null) {
      data['zcyUserPos'] = this.zcyUserPos!.map((v) => v.toJson()).toList();
    }
    data['userIds'] = this.userIds;
    data['delUserIds'] = this.delUserIds;
    data['ids'] = this.ids;
    return data;
  }
}


class ZcyUserPos {
  dynamic id;
  String? userId;
  dynamic tenantCode;
  dynamic businessId;
  dynamic city;
  dynamic createTime;
  dynamic createUser;
  dynamic gender;
  dynamic idCard;
  dynamic isDeleted;
  dynamic isMaster;
  dynamic masterPersonId;
  dynamic masterTenantCode;
  dynamic masterUnitId;
  dynamic phoneNumber;
  dynamic province;
  String? realName;
  dynamic status;
  dynamic streetAddress;
  dynamic updateTime;
  dynamic updateUser;
  dynamic userBirthday;
  dynamic userCode;
  dynamic userEmail;
  dynamic userPhoto;
  bool isSelected = false;

  ZcyUserPos(
      {this.id,
        this.userId,
        this.tenantCode,
        this.businessId,
        this.city,
        this.createTime,
        this.createUser,
        this.gender,
        this.idCard,
        this.isDeleted,
        this.isMaster,
        this.masterPersonId,
        this.masterTenantCode,
        this.masterUnitId,
        this.phoneNumber,
        this.province,
        this.realName,
        this.status,
        this.streetAddress,
        this.updateTime,
        this.updateUser,
        this.userBirthday,
        this.userCode,
        this.userEmail,
        this.userPhoto});

  ZcyUserPos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    tenantCode = json['tenantCode'];
    businessId = json['businessId'];
    city = json['city'];
    createTime = json['createTime'];
    createUser = json['createUser'];
    gender = json['gender'];
    idCard = json['idCard'];
    isDeleted = json['isDeleted'];
    isMaster = json['isMaster'];
    masterPersonId = json['masterPersonId'];
    masterTenantCode = json['masterTenantCode'];
    masterUnitId = json['masterUnitId'];
    phoneNumber = json['phoneNumber'];
    province = json['province'];
    realName = json['realName'];
    status = json['status'];
    streetAddress = json['streetAddress'];
    updateTime = json['updateTime'];
    updateUser = json['updateUser'];
    userBirthday = json['userBirthday'];
    userCode = json['userCode'];
    userEmail = json['userEmail'];
    userPhoto = json['userPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['tenantCode'] = this.tenantCode;
    data['businessId'] = this.businessId;
    data['city'] = this.city;
    data['createTime'] = this.createTime;
    data['createUser'] = this.createUser;
    data['gender'] = this.gender;
    data['idCard'] = this.idCard;
    data['isDeleted'] = this.isDeleted;
    data['isMaster'] = this.isMaster;
    data['masterPersonId'] = this.masterPersonId;
    data['masterTenantCode'] = this.masterTenantCode;
    data['masterUnitId'] = this.masterUnitId;
    data['phoneNumber'] = this.phoneNumber;
    data['province'] = this.province;
    data['realName'] = this.realName;
    data['status'] = this.status;
    data['streetAddress'] = this.streetAddress;
    data['updateTime'] = this.updateTime;
    data['updateUser'] = this.updateUser;
    data['userBirthday'] = this.userBirthday;
    data['userCode'] = this.userCode;
    data['userEmail'] = this.userEmail;
    data['userPhoto'] = this.userPhoto;
    return data;
  }
}
