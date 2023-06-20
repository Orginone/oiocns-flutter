

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ChoiceGbState extends BaseGetState{
  var gb = <XSpeciesItem>[].obs;

  TextEditingController searchController = TextEditingController();

  var selectedGroup = <XSpeciesItem>[].obs;

  var searchList = <XSpeciesItem>[].obs;


  //显示搜索页面
  var showSearchPage = false.obs;

  late String head;

  late bool showPopupMenu;

  late GbFunction function;

  ChoiceGbState(){
    head = Get.arguments?['head']??"";
    XSpeciesItem? gb = Get.arguments?['gb'];
    if(gb!=null){
      this.gb.value = gb.nodes??[];
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

