import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/utils/load_image.dart';

class BadgeTabWidget extends StatelessWidget {
  final int mgsCount;
  final Widget? body;
  final String? imgPath;
  final Color? foreColor;
  final EdgeInsets iconMargin;
  const BadgeTabWidget(
      {Key? key,
      this.mgsCount = 0,
      this.body,
      this.imgPath,
      this.foreColor,
      this.iconMargin = const EdgeInsets.only(bottom: 5.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: EdgeInsets.only(top: 18.h, bottom: 5.h),
      child: Column(
        children: [
          imgPath == null
              ? const SizedBox()
              : XImage.localImage(imgPath!, width: 36.w, color: foreColor),
          SizedBox(
            height: 3.h,
          ),
          null != body
              ? DefaultTextStyle(
                  style: TextStyle(fontSize: 16.sp, color: foreColor),
                  child: body!)
              : const SizedBox(),
        ],
      ),
    );
    if (mgsCount == 0) {
      return Container(
        child: child,
      );
    }
    bool isMaxVal = mgsCount > 99;
    String msg = isMaxVal ? "99+" : "$mgsCount";
    return badges.Badge(
      ignorePointer: false,
      position: badges.BadgePosition.topEnd(top: 5, end: isMaxVal ? -15 : -10),
      badgeStyle: isMaxVal
          ? const BadgeStyle(
              shape: BadgeShape.square,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              padding: EdgeInsets.all(3.0),
            )
          : const BadgeStyle(),
      badgeContent: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          letterSpacing: 1,
          wordSpacing: 2,
          height: 1,
        ),
      ),
      child: child,
    );
  }
}
