
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/market/index.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/util/common_tree_management.dart';

class WareHouseManagementState extends BaseGetListState<IProduct>{
  late TabController tabController;

  int index = 0;

  var recentlyList = [];

  var selectedSpecies = <ISpeciesItem>[].obs;

  late List<ISpeciesItem> species;

  WareHouseManagementState(){
    species = [];

  }
}

const List<String> tabTitle = [
  "全部",
  "共享的",
  "可用的",
  "创建的",
  "购买的",
];

class Recent {
  final String id;
  final String name;
  final String url;

  Recent(this.id, this.name, this.url);
}