import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/pages/setting/home/item.dart';
import 'logic.dart';
import 'state.dart';

class RelationGroupPage
    extends BaseBreadcrumbNavMultiplexPage<RelationGroupController, RelationGroupState> {

  @override
  Widget body() {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = state.model.value!.children[index];
          return Item(item: item, onNext: () {
            controller.nextLv(item);
          },onTap: (){
            controller.onTap(item);
          },onSelected: (value){
            if(item.standardEnum!=null){
              switch(item.standardEnum!){
                case StandardEnum.permission:
                  controller.operationPermission(item,value);
                  break;
                case StandardEnum.dict:
                  controller.operationDict(item,value);
                  break;
                case StandardEnum.classCriteria:
                  controller.operationClassCriteria(item,value);
                  break;
                case StandardEnum.propPackage:
                  controller.operationPropPackage(item,value);
                  break;
              }
            }else{
              controller.operationGroup(item,value);
            }

          },);
        },
        itemCount: state.model.value?.children.length??0,
      );
    });
  }

  @override
  RelationGroupController getController() {
    return RelationGroupController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}
