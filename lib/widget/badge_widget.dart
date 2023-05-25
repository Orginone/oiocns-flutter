



import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/util/load_image.dart';

class BadgeTabWidget extends StatelessWidget {
  final int mgsCount;
  final Widget? body;
  final String? imgPath;
  final EdgeInsets iconMargin;
  const BadgeTabWidget({Key? key,  this.mgsCount = 0, this.body, this.imgPath, this.iconMargin = const EdgeInsets.only(bottom: 5.0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget child = Tab(
      iconMargin: iconMargin,
      icon: imgPath==null?null:XImage.localImage(imgPath!, size: Size(32.w, 32.w)),
      height: 70,
      child: body,
    );
    if(mgsCount == 0){
      return Container(
        child: child,
      );
    }
    String msg = mgsCount>99?"99+":"$mgsCount";
    return badges.Badge(
      ignorePointer: false,
      position: badges.BadgePosition.topEnd(top: 0),
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
