import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';

import 'popup_menu_widget.dart';

class Item extends StatelessWidget {
  final CompanySpaceEnum? companySpaceEnum;
  final StandardEnum? standardEnum;
  final ITarget? innerAgency;
  final IGroup? outAgency;
  final IStation? station;
  final ICohort? cohort;
  final IAuthority? iAuthority;
  final SpeciesItem? species;
  final VoidCallback? nextLv;
  final VoidCallback? onTap;
  final UserSpaceEnum? userSpaceEnum;
  final PopupMenuItemSelected? onSelected;
  const Item(
      {Key? key,
      this.companySpaceEnum,
      this.innerAgency,
      this.outAgency,
      this.station,
      this.cohort,
      this.onTap,
      this.nextLv,
      this.standardEnum,
      this.iAuthority,
      this.species,
      this.userSpaceEnum, this.onSelected})
      : super(key: key);

  SettingController get settingController => Get.find<SettingController>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        bool hasNextLvData = true;
        if (innerAgency != null) {
          hasNextLvData = innerAgency?.subTeam.isNotEmpty ?? false;
        }
        if (outAgency != null) {
          hasNextLvData = outAgency?.subGroup.isNotEmpty ?? false;
        }
        if (iAuthority != null) {
          hasNextLvData = iAuthority?.children.isNotEmpty ?? false;
        }
        if (species != null) {
          hasNextLvData = species?.children.isNotEmpty ?? false;
        }
        if (station != null) {
          hasNextLvData = false;
        }
        if (cohort != null) {
          hasNextLvData = false;
        }
        if (hasNextLvData) {
          if (nextLv != null) {
            nextLv!();
          }
        }else{
          if(onTap!=null){
            onTap!();
          }
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
              PopupMenuWidget(
                target: innerAgency ?? outAgency ?? station ?? cohort,
                companySpaceEnum: companySpaceEnum,
                userSpaceEnum: userSpaceEnum,
                onSelected:onSelected,
              ),
              more(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    String name = companySpaceEnum?.label ??
        userSpaceEnum?.label ??
        standardEnum?.label ??
        innerAgency?.teamName ??
        outAgency?.teamName ??
        station?.teamName ??
        cohort?.teamName ??
        iAuthority?.name ??
        species?.name ??
        "";
    if (companySpaceEnum == CompanySpaceEnum.company) {
      name = settingController.space.teamName;
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
      onTap: onTap,
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }

  Widget _header() {
    IconData icon = Icons.account_balance_rounded;

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
