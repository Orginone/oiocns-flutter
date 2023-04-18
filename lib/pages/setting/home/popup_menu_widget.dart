import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/util/authority.dart';
import 'package:orginone/widget/common_widget.dart';

class PopupMenuWidget<T> extends StatefulWidget {
  final ITarget? target;
  final CompanySpaceEnum? companySpaceEnum;
  final UserSpaceEnum? userSpaceEnum;
  final PopupMenuItemSelected<T>? onSelected;

  const PopupMenuWidget(
      {Key? key,
      this.target,
      this.companySpaceEnum,
      this.userSpaceEnum,
      this.onSelected})
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
    init();
  }

  void init() {
    popupMenuItem.clear();
    target = widget.target;
    if (widget.companySpaceEnum != null) {
      switch (widget.companySpaceEnum) {
        case CompanySpaceEnum.company:
          target = settingController.space;
          break;
        case CompanySpaceEnum.innerAgency:
          popupMenuItem.add(newPopupMenuItem("新建部门", "create"));
          break;
        case CompanySpaceEnum.outAgency:
          popupMenuItem.add(newPopupMenuItem("新建集团", "create"));
          break;
        case CompanySpaceEnum.stationSetting:
          popupMenuItem.add(newPopupMenuItem("新建岗位", "create"));
          break;
        case CompanySpaceEnum.companyCohort:
          popupMenuItem.add(newPopupMenuItem("新建群组", "create"));
          break;
      }
    }
    if (widget.userSpaceEnum != null) {
      switch (widget.userSpaceEnum) {
        case UserSpaceEnum.personInfo:
          popupMenuItem.add(newPopupMenuItem("编辑", "edit"));
          break;
        case UserSpaceEnum.personGroup:
          popupMenuItem.add(newPopupMenuItem("新建群组", "create"));
          break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initPopupMenuItem();
    });
  }

  Future<bool> initPopupMenuItem() async {
    if (target == null) {
      return popupMenuItem.isNotEmpty;
    }
    bool isSuperAdmin = await Auth.isSuperAdmin(target!);
    if (target?.subTeamTypes.isNotEmpty??false) {
      if (isSuperAdmin) {
        popupMenuItem.add(newPopupMenuItem("新建子组织", "create"));
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

    setState(() {});
    return popupMenuItem.isNotEmpty;
  }

  PopupMenuItem newPopupMenuItem(String text, String value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  @override
  void didUpdateWidget(covariant PopupMenuWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target ||
        oldWidget.companySpaceEnum != widget.companySpaceEnum ||
        oldWidget.userSpaceEnum != widget.userSpaceEnum) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(popupMenuItem.isEmpty){
      return Container();
    }
    return CommonWidget.commonPopupMenuButton(
      items: popupMenuItem,
      onSelected: widget.onSelected,
    );
  }
}
