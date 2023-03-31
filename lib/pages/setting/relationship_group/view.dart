import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/cofig.dart';
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
          switch (state.companySpaceEnum) {
            case CompanySpaceEnum.innerAgency:
              return Item(innerAgency: item, nextLv: () {
                controller.nextLv(innerAgency: item);
              },onTap: (){
                controller.onTap(innerAgency: item);
              });
            case CompanySpaceEnum.outAgency:
              return Item(outAgency: item, nextLv: () {
                controller.nextLv(outAgency: item);
              },onTap: (){
                controller.onTap(outAgency: item);
              });
            case CompanySpaceEnum.stationSetting:
              return Item(station: item, nextLv: () {
                controller.nextLv(station: item);
              },onTap: (){
                controller.onTap(station: item);
              });
            case CompanySpaceEnum.companyCohort:
              return Item(cohort: item, nextLv: () {
                controller.nextLv(cohort: item);
              },onTap: (){
                controller.onTap(cohort: item);
              },);
          }
        },
        itemCount: state.groupData.value.length ?? 0,
      );
    });
  }
}
