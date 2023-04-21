import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/pages/index/index_page.dart';

import 'logic.dart';
import 'state.dart';

class Demo1Page extends BaseBreadcrumbNavMultiplexPage<Demo1Controller,Demo1State>{

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: state.model?.children.map((e){
              return BreadcrumbNavItem(item: e,onNext: (){
                Get.toNamed("/demo1",arguments: {'data':e},preventDuplicates: false);
              },);
            }).toList()??[],
          ),
          MaterialButton(onPressed: () {
            Get.toNamed("/demo2");
          },child: Text("跳转demo2"),),
        ],
      ),
    );
  }

  @override
  Demo1Controller getController() {
     return Demo1Controller();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}

class BreadcrumbNavItem extends BaseBreadcrumbNavItem{
  BreadcrumbNavItem({required super.item,super.onTap,super.onNext});

}