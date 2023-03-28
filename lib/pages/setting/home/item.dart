import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';

import 'logic.dart';
import 'state.dart';

class Item extends StatelessWidget {
  final CompanySpaceEnum? companySpaceEnum;
  final ITarget? innerAgency;
  final IGroup? outAgency;
  final IStation? station;
  final ICohort? cohort;

  const Item(
      {Key? key,
      this.companySpaceEnum,
      this.innerAgency,
      this.outAgency,
      this.station,
      this.cohort})
      : super(key: key);

  SettingController get settingController => Get.find<SettingController>();

  SettingCenterController get settingCenterController =>
      Get.find<SettingCenterController>(tag: "SettingCenter");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (companySpaceEnum != null) {
          settingCenterController.nextLvForEnum(companySpaceEnum!);
        } else {
          settingCenterController.nextLvForGroup(
              innerAgency: innerAgency,
              outAgency: outAgency,
              station: station,
              cohort: cohort);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
          ),
          child: Row(
            children: [
              _header(),
              Expanded(
                child: title(),
              ),
              _popupMenuButton(),
              more(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    String name = companySpaceEnum?.label ??
        innerAgency?.teamName ??
        outAgency?.teamName ??
        station?.teamName ??
        cohort?.teamName ??
        "";
    if (companySpaceEnum == CompanySpaceEnum.company) {
      name = settingController.space.name;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        name,
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
    );
  }

  Widget more() {
    return GestureDetector(
      onTap: () {},
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: "createThing",
            child: Text("创建实体"),
          ),
        ];
      },
    );
  }

  Widget _header() {
    IconData icon = Icons.account_balance_rounded;
    if (companySpaceEnum != null) {
      switch (companySpaceEnum) {
        case CompanySpaceEnum.company:
          icon = Icons.location_city;
          break;
        case CompanySpaceEnum.innerAgency:
          icon = Icons.account_balance_outlined;
          break;
        case CompanySpaceEnum.outAgency:
          icon = Icons.account_tree_outlined;
          break;
        case CompanySpaceEnum.stationSetting:
          icon = Icons.location_history_rounded;
          break;
        case CompanySpaceEnum.companyCohort:
          icon = Icons.chat_rounded;
          break;
      }
    }

    return AdvancedAvatar(
      size: 60.w,
      decoration: BoxDecoration(
        color: XColors.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
