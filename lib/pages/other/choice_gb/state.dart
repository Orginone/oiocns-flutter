

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

class ChoiceGbState extends BaseGetState{
  var gb = <ISpeciesItem>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedGroup = <ISpeciesItem>[].obs;

  var searchList = <ISpeciesItem>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;

  late String head;

  late bool showPopupMenu;

  late GbFunction function;

  ChoiceGbState(){
    head = Get.arguments?['head']??"";
    ISpeciesItem? gb = Get.arguments?['gb'];
    if(gb!=null){
      this.gb.value = gb.children??[];
      selectedGroup.add(gb);
    }else{
      this.gb.value = [];
    }

    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    function = Get.arguments?['function']??GbFunction.work;
  }
}

enum GbFunction{
  work,
  wareHouse
}

