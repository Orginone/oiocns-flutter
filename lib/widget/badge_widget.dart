



import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/widget/image_widget.dart';

class BadgeTabWidget extends StatelessWidget {
  final int mgsCount;
  final Widget? body;
  final String? imgPath;
  final EdgeInsets iconMargin;
  const BadgeTabWidget({Key? key,  this.mgsCount = 0, this.body, this.imgPath, this.iconMargin = const EdgeInsets.only(bottom: 5.0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget child = Container(
      padding: EdgeInsets.only(top: 18.h,bottom: 5.h),
      child: Column(
        children: [
          imgPath==null?const SizedBox():XImage.localImage(imgPath!, size: Size(36.w, 36.w)),
          SizedBox(height: 3.h,),
          body??const SizedBox(),
        ],
      ),
    );
    if(mgsCount == 0){
      return Container(
        child: child,
      );
    }
    String msg = mgsCount>99?"99+":"$mgsCount";
    return badges.Badge(
      ignorePointer: false,
      position: badges.BadgePosition.topEnd(top: 5),
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
