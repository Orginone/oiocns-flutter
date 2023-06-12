import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StoreController extends BaseFrequentlyUsedListController<StoreState>{
 final StoreState state = StoreState();

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.dataList.value = List.generate(10, (i)=>i);
  }
}
