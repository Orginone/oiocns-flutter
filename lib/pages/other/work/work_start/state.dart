


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

class WorkStartState extends BaseGetState{
  late TabController tabController;

  late ISpeciesItem species;


  WorkStartState(){
    species = Get.arguments['species'];
  }

}


const List<String> tabTitle = [
  '发起',
  '已发起',
];