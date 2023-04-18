import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';

import 'state.dart';

class NavigatorItem extends StatelessWidget {
  final NavigatorModel item;

  final VoidCallback? next;

  final VoidCallback? onTap;

  final List<PopupMenuItem<NavigatorPopupMenuEnum>> popupMenuItem;

  final List<Widget> action;

  const NavigatorItem({
    Key? key,
    required this.item,
    this.next,
    this.onTap,
    this.popupMenuItem = const [],
    this.action = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.children.isNotEmpty) {
          if (next != null) {
            next!();
          }
        } else {
          if (onTap != null) {
            onTap!();
          }
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
        child: Row(
          children: [
            AdvancedAvatar(
              size: 60.w,
              decoration: BoxDecoration(
                color: XColors.themeColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
              ),
              child: const Icon(Icons.account_balance_rounded,
                  color: Colors.white),
            ),
            Expanded(
              child: title(),
            ),
            ...action,
            _popupMenuButton(),
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
        item.title,
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

  Widget _popupMenuButton() {
    if (popupMenuItem.isEmpty) {
      return Container();
    }
    return PopupMenuButton<NavigatorPopupMenuEnum>(
      icon: Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context) {
        return popupMenuItem;
      },
      onSelected: (value) {

      },
    );
  }
}
