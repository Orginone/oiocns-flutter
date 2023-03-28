import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/market/model.dart';

import '../../../../dart/core/getx/base_controller.dart';

class Recent {
  final String id;
  final String name;
  final String url;

  Recent(this.id, this.name, this.url);
}

class RecentlyOpenedController extends BaseController<RecentlyOpenedState> {
  final RecentlyOpenedState state = RecentlyOpenedState();

  @override
  void onInit() {
    debugPrint('---————————————>recentlycontroller onInit');
    state.recentlyList.add(
        Recent("0000", "资产管家", "http://anyinone.com:888/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "一警一档", "http://anyinone.com:888/img/logo/logo3.jpg"));
    super.onInit();
  }

  List getList(int index) {
    return index * 5 + 5 > state.recentlyList.length
        ? state.recentlyList.sublist(index * 5, state.recentlyList.length)
        : state.recentlyList.sublist(index * 5, index * 5 + 5);
  }

  void addRecentlyApp(IProduct product) {
    if (hasProduct(product)) {
      state.recentlyList.removeWhere((element) => element.id == product.prod.id);
    }else{
      state.recentlyList.add(Recent(product.prod.id??"",product.prod.name??"","http://anyinone.com:888/img/logo/logo3.jpg"));
      state.recentlyList.refresh();
    }
  }

  bool hasProduct(IProduct product){
     try{
       var has = state.recentlyList.firstWhere((p0) => p0.id == product.prod.id);
       return true;
     }catch(e){
       return false;
    }
  }
}


class RecentlyOpenedState extends BaseGetState {
  var recentlyList = <Recent>[].obs;
  var currentIndex = 0.obs;
}