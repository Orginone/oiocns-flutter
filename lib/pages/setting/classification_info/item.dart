import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/setting/widget.dart';

import '../../../widget/common_widget.dart';

class Item extends StatelessWidget {
  final VoidCallback? onTap;
  final XDict dict;
  final PopupMenuItemSelected? onSelected;
  const Item({Key? key, this.onTap, required this.dict, this.onSelected}) : super(key: key);

  SettingController get settingController => Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
        ),
        child: Row(
          children: [
            _header(),
            Expanded(
              child: title(),
            ),
            CommonWidget.commonPopupMenuButton(
              items: const [
                PopupMenuItem(
                  value: "",
                  child: Text(""),
                ),
              ],
              onSelected: onSelected,
            ),
            more(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        dict.name ?? "",
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
