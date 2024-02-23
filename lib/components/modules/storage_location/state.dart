import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class StorageLocationState extends BaseGetState {
  late List<StorageLocation> mock;

  var mockRx = <StorageLocation>[].obs;

  var selectedLocation = Rxn<StorageLocation>();

  var selectedGroup = <StorageLocation>[].obs;

  var searchList = <StorageLocation>[].obs;

  //显示搜索页面
  var showSearchPage = false.obs;

  TextEditingController searchController = TextEditingController();
}

class StorageLocation {
  int? id;
  String? tenantId;
  String? placeNo;
  String? placeName;
  int? pid;
  String? fullName;
  int? number;
  bool? last;
  List<StorageLocation>? children;
  bool isSelected = false;

  StorageLocation(
      {this.id,
      this.tenantId,
      this.placeNo,
      this.placeName,
      this.pid,
      this.fullName,
      this.number,
      this.last,
      this.children});

  StorageLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenantId'];
    placeNo = json['placeNo'];
    placeName = json['placeName'];
    pid = json['pid'];
    fullName = json['fullName'];
    number = json['number'];
    last = json['last'];
    children = [];
    if (json['children'] != null) {
      json['children'].forEach((v) {
        children!.add(StorageLocation.fromJson(v));
      });
    }
  }

  bool hasSelected() {
    return getAllSelected().isNotEmpty;
  }

  List<StorageLocation> getAllSelected() {
    List<StorageLocation> selected = [];
    for (var element in children!) {
      if (element.last ?? false) {
        if (element.isSelected) {
          selected.add(element);
        }
      } else {
        for (var element in element.children!) {
          selected.addAll(element.getAllSelected());
        }
      }
    }
    return selected;
  }

  List<StorageLocation> getAllLastList() {
    List<StorageLocation> list = [];
    for (var element in children!) {
      if (element.last ?? false) {
        list.add(element);
      } else {
        list.addAll(element.getAllLastList());
      }
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenantId'] = tenantId;
    data['placeNo'] = placeNo;
    data['placeName'] = placeName;
    data['pid'] = pid;
    data['fullName'] = fullName;
    data['number'] = number;
    data['last'] = last;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
