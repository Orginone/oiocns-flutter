

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/util/common_tree_management.dart';

class ChoiceGbState extends BaseGetState{
  var gb = <ISpeciesItem>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedGb = Rxn<ISpeciesItem>();

  var selectedGroup = <ISpeciesItem>[].obs;

  var searchList = <ISpeciesItem>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;

  late String head;

  late bool showPopupMenu;

  late GbFunction function;

  ChoiceGbState(){
    head = Get.arguments?['head']??CommonTreeManagement().species?.name??"";
    ISpeciesItem? gb = Get.arguments?['gb'];
    if(gb!=null){
      this.gb.value = gb.children??[];
      selectedGroup.add(gb);
    }else{
      this.gb.value = CommonTreeManagement().species?.children??[];
    }

    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    function = Get.arguments?['function']??GbFunction.work;
  }
}

enum GbFunction{
  work,
  wareHouse
}

