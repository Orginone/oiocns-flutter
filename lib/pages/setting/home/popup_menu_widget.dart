import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/util/authority.dart';
import 'package:orginone/widget/common_widget.dart';

class PopupMenuWidget extends StatefulWidget {
  final ITarget? target;
  final CompanySpaceEnum? companySpaceEnum;
  final StandardEnum? standardEnum;

  const PopupMenuWidget(
      {Key? key, this.target, this.companySpaceEnum, this.standardEnum})
      : super(key: key);

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  var popupMenuItem = <PopupMenuItem>[];

  SettingController get settingController => Get.find<SettingController>();

  ITarget? target;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    target = widget.target;
    if(widget.companySpaceEnum!=null){
      switch(widget.companySpaceEnum){
        case CompanySpaceEnum.company:
          target = settingController.space;
          break;
        case CompanySpaceEnum.innerAgency:
          popupMenuItem.add(newPopupMenuItem("新建部门","createDept"));
          break;
        case CompanySpaceEnum.outAgency:
          popupMenuItem.add(newPopupMenuItem("新建集团","createGroup"));
          break;
        case CompanySpaceEnum.stationSetting:
          popupMenuItem.add(newPopupMenuItem("新建岗位","createStation"));
          break;
        case CompanySpaceEnum.companyCohort:
          popupMenuItem.add(newPopupMenuItem("新建群组","createCohort"));
          break;
      }
    }
  }

  Future<bool> initPopupMenuItem() async {
    if(target == null){
      return popupMenuItem.isNotEmpty;
    }
    bool isSuperAdmin = await Auth.isSuperAdmin(target!);
    if (target!.subTeamTypes.isNotEmpty) {
      if (isSuperAdmin) {
        popupMenuItem.add(newPopupMenuItem("新建子组织", "createOrganization"));
      }
    }
    if (isSuperAdmin) {
      popupMenuItem.add(newPopupMenuItem("编辑", "edit"));
      if (target != settingController.user &&
          target != settingController.company) {
        popupMenuItem.add(newPopupMenuItem("删除", "delete"));
      }
    } else if (await Auth.isSuperAdmin(settingController.space)) {
      if (target != settingController.user &&
          target != settingController.company) {
        popupMenuItem.add(newPopupMenuItem("退出${target!.typeName}", "signOut"));
      }
    }

    return popupMenuItem.isNotEmpty;
  }

  PopupMenuItem newPopupMenuItem(String text, String value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initPopupMenuItem(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return SizedBox();
        }
        if(!snapshot.data!){
          return SizedBox();
        }
        return CommonWidget.commonPopupMenuButton(
          items: popupMenuItem,
        );
      }
    );
  }
}
