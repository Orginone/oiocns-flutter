import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/pages/setting/home/item.dart';
import 'logic.dart';
import 'state.dart';

class RelationGroupPage
    extends BaseGetView<RelationGroupController, RelationGroupState> {
  @override
  Widget buildView() {
    return GyScaffold(
      centerTitle: false,
      backgroundColor: Colors.white,
      titleWidget: Obx(
            () {
          return CommonWidget.commonBreadcrumbNavWidget(
              firstTitle: state.head,
              allTitle: state.selectedGroup.value,
              onTapFirst: () {
                controller.back();
              },
              onTapTitle: (index) {
                controller.removeGroup(index);
              },padding: EdgeInsets.zero);
        },
      ),
      leadingWidth: 0,
      leading: const SizedBox(),
      body: body(),
    );
  }

  Widget body() {
    return Obx(() {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = state.groupData.value[index];
          if(state.isStandard){
            switch (state.standardEnum) {
              case StandardEnum.permission:
                return Item(iAuthority: item, nextLv: () {
                  controller.nextLv(iAuthority: item);
                },onTap: (){
                  controller.onTap(iAuthority: item);
                },onSelected: (value){

                },);
              case StandardEnum.classCriteria:
                return Item(species: item, nextLv: () {
                  controller.nextLv(species: item);
                },onTap: (){
                  controller.onTap(species: item);
                },onSelected: (value){

                },);
            }
          }
          return Item(target: item, nextLv: () {
            controller.nextLv(target: item);
          },onTap: (){
            controller.onTap(target: item);
          },onSelected: (value){
            controller.operation(item,value);
          },);
        },
        itemCount: state.groupData.value.length ?? 0,
      );
    });
  }
}
