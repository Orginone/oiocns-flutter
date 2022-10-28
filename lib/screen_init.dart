import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/routers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScreenInit extends StatelessWidget {
  const ScreenInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return RefreshConfiguration(
          footerTriggerDistance: 15,
          dragSpeedRatio: 0.91,
          headerBuilder: () => const MaterialClassicHeader(
            color: UnifiedColors.themeColor,
          ),
          footerBuilder: () => const ClassicFooter(
              loadingText: "努力加载中...",
              idleText: "上拉加载更多...",
              canLoadingText: "上拉加载更多",
              noDataText: "没有更多了",
              failedText: "点击重试"),
          enableLoadingWhenNoData: false,
          enableRefreshVibrate: false,
          enableLoadMoreVibrate: false,
          shouldFooterFollowWhenNotFull: (state) {
            return false;
          },
          child: GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate, //iOS
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
            textDirection: TextDirection.ltr,
            initialRoute: Routers.main,
            getPages: Routers.getInitRouters(),
          ),
        );
      },
    );
  }
}
