import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import '../item.dart';
import 'logic.dart';
import 'state.dart';


class SettingFunctionPage extends BaseGetView<SettingFunctionController,SettingFunctionState>{


  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.space.teamName,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ...StandardEnum.values
              .map((e) =>
              Item(
                standardEnum: e,
                nextLv: () {
                  controller.nextLvForStandardEnum(e);
                },
              ))
              .toList(),
          ...state.spaceEnum.map((e){
            return Item(
              spaceEnum: e,
              nextLv: () {
                controller.nextLvForSpaceEnum(e);
              },
              onSelected: (value){
                switch(value){
                  case "create":
                    controller.createOrganization(e);
                    break;
                  case "edit":
                    controller.editOrganization(e);
                    break;
                }
              },
            );
          }).toList(),
        ],
      )
    );
  }
}