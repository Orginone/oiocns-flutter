



import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BadgeTabWidget extends StatelessWidget {
  final int mgsCount;
  final Widget? body;
  final Widget? icon;
  final EdgeInsets iconMargin;
  const BadgeTabWidget({Key? key,  this.mgsCount = 0, this.body, this.icon, this.iconMargin = const EdgeInsets.only(bottom: 10.0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget child = Tab(
      iconMargin: iconMargin,
      icon: icon,
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
