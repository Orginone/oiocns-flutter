import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';

import 'popup_menu_widget.dart';

class Item extends StatelessWidget {
  final SpaceEnum? spaceEnum;
  final StandardEnum? standardEnum;
  final ITarget? target;
  final IAuthority? iAuthority;
  final SpeciesItem? species;
  final VoidCallback? nextLv;
  final VoidCallback? onTap;
  final PopupMenuItemSelected? onSelected;
  const Item(
      {Key? key,
      this.spaceEnum,
      this.target,
      this.onTap,
      this.nextLv,
      this.standardEnum,
      this.iAuthority,
      this.species,
        this.onSelected})
      : super(key: key);

  SettingController get settingController => Get.find<SettingController>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        bool hasNextLvData = true;
        if (target != null) {
          hasNextLvData = target?.subTeam.isNotEmpty ?? false;
        }
        if (iAuthority != null) {
          hasNextLvData = iAuthority?.children.isNotEmpty ?? false;
        }
        if (species != null) {
          hasNextLvData = species?.children.isNotEmpty ?? false;
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
        margin: EdgeInsets.symmetric(vertical: 10.h),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            _header(),
            Expanded(
              child: title(),
            ),
            PopupMenuWidget(
              target: target,
              spaceEnum: spaceEnum,
              onSelected:onSelected,
            ),
            more(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    String name = spaceEnum?.label  ??
        standardEnum?.label ??
        target?.teamName ??
        iAuthority?.name ??
        species?.name ??
        "";
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
    var image = target?.target.avatarThumbnail();
    return AdvancedAvatar(
      size: 60.w,
      decoration: BoxDecoration(
        color: XColors.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
          image:image!=null?DecorationImage(image: MemoryImage(image),fit: BoxFit.cover):null
      ),
    );
  }
}
