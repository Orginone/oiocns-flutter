import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class XColors {
  static const Color lightBlue = Color(0xFFecf5ff);
  static const Color seaBlue = Color(0xFFc9e7ff);
  static const Color lightGrey = Color(0xFFfafafa);
  static const Color easyGrey = Color(0xFFf7f7f7);
  static const Color lightBlack = Color(0xFF252a30);
  static const Color searchGrey = Color(0xFFecedef);
  static const Color darkGreen = Color.fromRGBO(1, 173, 67, 1);
  static const Color designBlue = Color(0xFF3D5ED1);
  static const Color designLightBlue = Color(0xFFEDEFFC);
  static const Color tinyBlue = Color(0xFFA8B5FF);
  static const Color tinyLightBlue = Color(0xFFCEDFFF);
  static const Color themeColor = Color(0xff3D5ED1);
  static const Color applicationColor = Color(0xff2F96F9);
  static const Color starColor = Color(0xff154AD8);
  static const Color black = Color(0xff000000);
  static const Color black3 = Color(0xff303133);
  static const Color black6 = Color(0xff606266);
  static const Color black9 = Color(0xff909399);
  static const Color white = Color(0xffffffff);
  static const Color lineLight = Color(0xffEDEDED);
  static const Color lineLight2 = Color(0xffD4D4D4);
  static const Color cardBorder = Color(0xffB1B1B1);
  static const Color backColor = Color(0xffF76C6F);
  static const Color fontErrorColor = Color(0xffd43436);
  static const Color navigatorBgColor = Color(0xfff2f2f2);
  static const Color bgColor = Color(0xfff8f8f8);
  static const Color transparent = Color(0x00ffffff);
  static const Color bgGrayLight = Color(0xFFF5F5F5);
  static const Color yellow = Color(0xFFF1B463);
}

class XIcons {
  static get arrowBack32 {
    return Icon(Icons.arrow_back_outlined, color: Colors.black, size: 32.w);
  }

  static get loading32 {
    return Icon(const IconData(0xe891), color: Colors.black, size: 32.w);
  }
}

class XWidgets {
  static get defaultBackBtn {
    return IconButton(icon: XIcons.arrowBack32, onPressed: () => Get.back());
  }
}

class XInsets {
  static get all4 {
    return EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w);
  }

  static get all8 {
    return EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w);
  }

  static get all12 {
    return EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w);
  }

  static get all16 {
    return EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w);
  }

  static get all20 {
    return EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w);
  }

  static get all24 {
    return EdgeInsets.only(left: 24.w, right: 24.w, top: 24.w);
  }

  static get all28 {
    return EdgeInsets.only(left: 28.w, right: 28.w, top: 28.w);
  }

  static get l8r8 {
    return EdgeInsets.only(left: 8.w, right: 8.w);
  }

  static get l12r12 {
    return EdgeInsets.only(left: 12.w, right: 12.w);
  }

  static get l16r16 {
    return EdgeInsets.only(left: 16.w, right: 16.w);
  }

  static get l20r20 {
    return EdgeInsets.only(left: 20.w, right: 20.w);
  }

  static get l24r24 {
    return EdgeInsets.only(left: 24.w, right: 24.w);
  }

  static get l28r28 {
    return EdgeInsets.only(left: 28.w, right: 28.w);
  }

  static get t8b8 {
    return EdgeInsets.only(top: 8.w, bottom: 8.w);
  }

  static get t12b12 {
    return EdgeInsets.only(top: 12.w, bottom: 12.w);
  }

  static get t16b16 {
    return EdgeInsets.only(top: 16.w, bottom: 16.w);
  }

  static get t20b20 {
    return EdgeInsets.only(left: 20.w, right: 20.w);
  }

  static get t24b24 {
    return EdgeInsets.only(left: 24.w, right: 24.w);
  }

  static get t28b248 {
    return EdgeInsets.only(left: 28.w, right: 28.w);
  }

  static get l8r8t4 {
    return EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h);
  }

  static get l12r12t6 {
    return EdgeInsets.only(left: 12.w, right: 12.w, top: 6.h);
  }

  static get l16r16t8 {
    return EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h);
  }

  static get l20r20t10 {
    return EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h);
  }

  static get l24r24t12 {
    return EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h);
  }

  static get l28r28t14 {
    return EdgeInsets.only(left: 28.w, right: 28.w, top: 14.h);
  }
}

class XFonts {
  static get size12Black0 {
    return TextStyle(fontSize: 12.sp, color: XColors.black);
  }

  static get size12Black3 {
    return TextStyle(fontSize: 12.sp, color: XColors.black3);
  }

  static get size12Black6 {
    return TextStyle(fontSize: 12.sp, color: XColors.black6);
  }

  static get size12Black9 {
    return TextStyle(fontSize: 12.sp, color: XColors.black9);
  }

  static get size14Black0 {
    return TextStyle(fontSize: 14.sp, color: XColors.black);
  }

  static get size14Black3 {
    return TextStyle(fontSize: 14.sp, color: XColors.black3);
  }

  static get size14Black6 {
    return TextStyle(fontSize: 14.sp, color: XColors.black6);
  }

  static get size14Black9 {
    return TextStyle(fontSize: 14.sp, color: XColors.black9);
  }

  static get size16Black0 {
    return TextStyle(fontSize: 16.sp, color: XColors.black);
  }

  static get size16Black3 {
    return TextStyle(fontSize: 16.sp, color: XColors.black3);
  }

  static get size16Black6 {
    return TextStyle(fontSize: 16.sp, color: XColors.black6);
  }

  static get size16Black9 {
    return TextStyle(fontSize: 16.sp, color: XColors.black9);
  }

  static get size18Black0 {
    return TextStyle(fontSize: 18.sp, color: XColors.black);
  }

  static get size18Black3 {
    return TextStyle(fontSize: 18.sp, color: XColors.black3);
  }

  static get size18Black6 {
    return TextStyle(fontSize: 18.sp, color: XColors.black6);
  }

  static get size18Black9 {
    return TextStyle(fontSize: 18.sp, color: XColors.black9);
  }

  static get size20Black0 {
    return TextStyle(fontSize: 20.sp, color: XColors.black);
  }

  static get size20Black3 {
    return TextStyle(fontSize: 20.sp, color: XColors.black3);
  }

  static get size20Black6 {
    return TextStyle(fontSize: 20.sp, color: XColors.black6);
  }

  static get size20Black9 {
    return TextStyle(fontSize: 20.sp, color: XColors.black9);
  }

  static get size22Black0 {
    return TextStyle(fontSize: 22.sp, color: XColors.black);
  }

  static get size22Black3 {
    return TextStyle(fontSize: 22.sp, color: XColors.black3);
  }

  static get size22Black6 {
    return TextStyle(fontSize: 22.sp, color: XColors.black6);
  }

  static get size22Black9 {
    return TextStyle(fontSize: 22.sp, color: XColors.black9);
  }

  static get size24Black0 {
    return TextStyle(fontSize: 24.sp, color: XColors.black);
  }

  static get size24Black3 {
    return TextStyle(fontSize: 24.sp, color: XColors.black3);
  }

  static get size24Black6 {
    return TextStyle(fontSize: 24.sp, color: XColors.black6);
  }

  static get size24Black9 {
    return TextStyle(fontSize: 24.sp, color: XColors.black9);
  }

  static get size26Black0 {
    return TextStyle(fontSize: 26.sp, color: XColors.black);
  }

  static get size26Black3 {
    return TextStyle(fontSize: 26.sp, color: XColors.black3);
  }

  static get size26Black6 {
    return TextStyle(fontSize: 26.sp, color: XColors.black6);
  }

  static get size26Black9 {
    return TextStyle(fontSize: 26.sp, color: XColors.black9);
  }

  static get size28Black0 {
    return TextStyle(fontSize: 28.sp, color: XColors.black);
  }

  static get size28Black3 {
    return TextStyle(fontSize: 28.sp, color: XColors.black3);
  }

  static get size28Black6 {
    return TextStyle(fontSize: 28.sp, color: XColors.black6);
  }

  static get size28Black9 {
    return TextStyle(fontSize: 28.sp, color: XColors.black9);
  }

  static get size12Theme {
    return TextStyle(fontSize: 12.sp, color: XColors.themeColor);
  }

  static get size14Theme {
    return TextStyle(fontSize: 14.sp, color: XColors.themeColor);
  }

  static get size16Theme {
    return TextStyle(fontSize: 16.sp, color: XColors.themeColor);
  }

  static get size18Theme {
    return TextStyle(fontSize: 18.sp, color: XColors.themeColor);
  }

  static get size20Theme {
    return TextStyle(fontSize: 20.sp, color: XColors.themeColor);
  }

  static get size22Theme {
    return TextStyle(fontSize: 22.sp, color: XColors.themeColor);
  }

  static get size24Theme {
    return TextStyle(fontSize: 24.sp, color: XColors.themeColor);
  }

  static get size26Theme {
    return TextStyle(fontSize: 26.sp, color: XColors.themeColor);
  }

  static get size28Theme {
    return TextStyle(fontSize: 28.sp, color: XColors.themeColor);
  }

  static get size12White {
    return TextStyle(fontSize: 12.sp, color: XColors.white);
  }

  static get size14White {
    return TextStyle(fontSize: 14.sp, color: XColors.white);
  }

  static get size16White {
    return TextStyle(fontSize: 16.sp, color: XColors.white);
  }

  static get size18White {
    return TextStyle(fontSize: 18.sp, color: XColors.white);
  }

  static get size20White {
    return TextStyle(fontSize: 20.sp, color: XColors.white);
  }

  static get size22White {
    return TextStyle(fontSize: 22.sp, color: XColors.white);
  }

  static get size24White {
    return TextStyle(fontSize: 24.sp, color: XColors.white);
  }

  static get size26White {
    return TextStyle(fontSize: 26.sp, color: XColors.white);
  }

  static get size28White {
    return TextStyle(fontSize: 28.sp, color: XColors.white);
  }

  static var w700 = FontWeight.w700;

  static get size12Black0W700 {
    return TextStyle(fontSize: 12.sp, color: XColors.black, fontWeight: w700);
  }

  static get size12Black3W700 {
    return TextStyle(fontSize: 12.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size12Black6W700 {
    return TextStyle(fontSize: 12.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size12Black9W700 {
    return TextStyle(fontSize: 12.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size14Black0W700 {
    return TextStyle(fontSize: 14.sp, color: XColors.black, fontWeight: w700);
  }

  static get size14Black3W700 {
    return TextStyle(fontSize: 14.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size14Black6W700 {
    return TextStyle(fontSize: 14.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size14Black9W700 {
    return TextStyle(fontSize: 14.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size16Black0W700 {
    return TextStyle(fontSize: 16.sp, color: XColors.black, fontWeight: w700);
  }

  static get size16Black3W700 {
    return TextStyle(fontSize: 16.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size16Black6W700 {
    return TextStyle(fontSize: 16.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size16Black9W700 {
    return TextStyle(fontSize: 16.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size18Black0W700 {
    return TextStyle(fontSize: 18.sp, color: XColors.black, fontWeight: w700);
  }

  static get size18Black3W700 {
    return TextStyle(fontSize: 18.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size18Black6W700 {
    return TextStyle(fontSize: 18.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size18Black9W700 {
    return TextStyle(fontSize: 18.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size20Black0W700 {
    return TextStyle(fontSize: 20.sp, color: XColors.black, fontWeight: w700);
  }

  static get size20Black3W700 {
    return TextStyle(fontSize: 20.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size20Black6W700 {
    return TextStyle(fontSize: 20.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size20Black9W700 {
    return TextStyle(fontSize: 20.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size22Black0W700 {
    return TextStyle(fontSize: 22.sp, color: XColors.black, fontWeight: w700);
  }

  static get size22Black3W700 {
    return TextStyle(fontSize: 22.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size22Black6W700 {
    return TextStyle(fontSize: 22.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size22Black9W700 {
    return TextStyle(fontSize: 22.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size24Black0W700 {
    return TextStyle(fontSize: 24.sp, color: XColors.black, fontWeight: w700);
  }

  static get size24Black3W700 {
    return TextStyle(fontSize: 24.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size24Black6W700 {
    return TextStyle(fontSize: 24.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size24Black9W700 {
    return TextStyle(fontSize: 24.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size26Black0W700 {
    return TextStyle(fontSize: 26.sp, color: XColors.black, fontWeight: w700);
  }

  static get size26Black3W700 {
    return TextStyle(fontSize: 26.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size26Black6W700 {
    return TextStyle(fontSize: 26.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size26Black9W700 {
    return TextStyle(fontSize: 26.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size28Black0W700 {
    return TextStyle(fontSize: 28.sp, color: XColors.black, fontWeight: w700);
  }

  static get size28Black3W700 {
    return TextStyle(fontSize: 28.sp, color: XColors.black3, fontWeight: w700);
  }

  static get size28Black6W700 {
    return TextStyle(fontSize: 28.sp, color: XColors.black6, fontWeight: w700);
  }

  static get size28Black9W700 {
    return TextStyle(fontSize: 28.sp, color: XColors.black9, fontWeight: w700);
  }

  static get size12WhiteW700 {
    return TextStyle(fontSize: 12.sp, color: XColors.white, fontWeight: w700);
  }

  static get size14WhiteW700 {
    return TextStyle(fontSize: 14.sp, color: XColors.white, fontWeight: w700);
  }

  static get size16WhiteW700 {
    return TextStyle(fontSize: 16.sp, color: XColors.white, fontWeight: w700);
  }

  static get size18WhiteW700 {
    return TextStyle(fontSize: 18.sp, color: XColors.white, fontWeight: w700);
  }

  static get size20WhiteW700 {
    return TextStyle(fontSize: 20.sp, color: XColors.white, fontWeight: w700);
  }

  static get size22WhiteW700 {
    return TextStyle(fontSize: 22.sp, color: XColors.white, fontWeight: w700);
  }

  static get size24WhiteW700 {
    return TextStyle(fontSize: 24.sp, color: XColors.white, fontWeight: w700);
  }

  static get size26WhiteW700 {
    return TextStyle(fontSize: 26.sp, color: XColors.white, fontWeight: w700);
  }

  static get size28WhiteW700 {
    return TextStyle(fontSize: 28.sp, color: XColors.white, fontWeight: w700);
  }
}
