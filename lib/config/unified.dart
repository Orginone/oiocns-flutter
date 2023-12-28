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
  static const Color bgChat = Color(0xFFF0F2F7);
  static const Color tinyLightBlue = Color(0xFFCEDFFF);
  static const Color themeColor = Color(0xff3D5ED1);
  static const Color applicationColor = Color(0xff2F96F9);
  static const Color starColor = Color(0xff154AD8);
  static const Color selectedColor = Color(0xFF3D5ED1);
  static const Color black = Color(0xff000000);
  static const Color black3 = Color(0xff303133);
  static const Color black6 = Color(0xff606266);
  static const Color black666 = Color(0xff666666);
  static const Color black9 = Color(0xff909399);
  static const Color chatTitleColor = Color(0xFF111111);
  static const Color chatHintColors = Color(0xFFC2C2C2);
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
  static const Color orange = Color(0xFFFB8F11);
  static const Color entryBgColor = Color(0xFFDFE0EF);
  static const Color entryColor = Color(0xFF396DB2);
  static const Color statisticsBoxColor = Color(0xFFC5E3FF);
  static const Color blueHintTextColor = Color(0xFF4C9DF9);
  static const Color blueTextColor = Color(0xFF1890FF);
  static const Color cardShadowColor = Color(0xFF4C9DF9);
  static const Color bgErrorColor = Color(0xFFFAECE9);

  // 列表内容背景底色
  static const Color bgListBody = Color.fromARGB(255, 240, 240, 240);
  // 列表项背景色
  static const Color bgListItem = Color(0xFFFFFFFF);
  static const Color bgListItem1 = Color.fromARGB(255, 244, 243, 243);
}

class XIcons {
  static get arrowBack32 {
    return Icon(Icons.arrow_back_outlined, color: Colors.black, size: 32.w);
  }

  static get loading32 {
    return Icon(Icons.add, color: Colors.black, size: 32.w);
  }
}

class XWidgets {
  static get defaultBackBtn {
    return IconButton(icon: XIcons.arrowBack32, onPressed: () => Get.back());
  }
}

class XFonts {
  ///沟通
  //沟通会话信息
  static get chatSMInfo => size24Black0; //文本信息
  static get chatSMSysTip => size14Black0; //系统提示文本信息

  ///动态模块
  ///动态子标题样式
  static get activityListSubTitle => size16Black9; //子标题
  static get activityListTitle => size22Black0; //标题
  static get activitListContent => size24Black0; //摘要

  ///通用字体颜色
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

  static get size15Black0 {
    return TextStyle(fontSize: 15.sp, color: XColors.black);
  }

  static get size15Black3 {
    return TextStyle(fontSize: 15.sp, color: XColors.black3);
  }

  static get size15Black6 {
    return TextStyle(fontSize: 15.sp, color: XColors.black6);
  }

  static get size15Black9 {
    return TextStyle(fontSize: 15.sp, color: XColors.black9);
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

  static get size12ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 12.sp, color: theme, fontWeight: w700);
  }

  static get size14ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 14.sp, color: theme, fontWeight: w700);
  }

  static get size16ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 16.sp, color: theme, fontWeight: w700);
  }

  static get size18ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 18.sp, color: theme, fontWeight: w700);
  }

  static get size20ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 20.sp, color: theme, fontWeight: w700);
  }

  static get size22ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 22.sp, color: theme, fontWeight: w700);
  }

  static get size24ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 24.sp, color: theme, fontWeight: w700);
  }

  static get size26ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 26.sp, color: theme, fontWeight: w700);
  }

  static get size28ThemeW700 {
    var theme = XColors.themeColor;
    return TextStyle(fontSize: 28.sp, color: theme, fontWeight: w700);
  }
}
