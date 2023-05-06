import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/notification_util.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'event/home_data.dart';
import 'util/download_utils.dart';
import 'util/event_bus_helper.dart';
import 'util/hive_utils.dart';
import 'util/local_store.dart';

void main() async {
  // 逻辑绑定
  WidgetsFlutterBinding.ensureInitialized();

  await HiveUtils.init();

  // 初始化通知配置
  NotificationUtil.initNotification();
  await DownloadUtils().init();
  await LocalStore.instance();
  // 日志初始化
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    if (kDebugMode) {
      print('${event.level.name}: ${event.time}: ${event.message}');
    }
  });

  // 开启 app
  runApp(const ScreenInit());
}

final kernel = KernelApi.getInstance();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver();
const Size screenSize = Size(540, 1170);

class ScreenInit extends StatelessWidget {
  const ScreenInit({Key? key}) : super(key: key);

  List<String>? get account => LocalStore.getStore().getStringList("account");

  SettingController get settingCtrl => Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return RefreshConfiguration(
          footerTriggerDistance: 15,
          dragSpeedRatio: 0.91,
          headerBuilder: () => const MaterialClassicHeader(
            color: XColors.themeColor,
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
            navigatorObservers: [routeObserver],
            navigatorKey: navigatorKey,
            initialBinding: SettingBinding(),
            onInit: () async {
              await automaticLogon();
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate, //iOS
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
            darkTheme: ThemeData(useMaterial3: true),
            textDirection: TextDirection.ltr,
            initialRoute: account != null ? Routers.home : Routers.login,
            getPages: Routers.getInitRouters(),
          ),
        );
      },
    );
  }

  Future<void> automaticLogon() async{
    Future<void> login() async {
      String accountName = account![0];
      String passWord = account![1];
      await settingCtrl.provider.login(accountName, passWord);
      print('登录成功');
    }

    if (account != null) {
      if (KernelApi.getInstance().isOnline) {
        await login();
      } else {
        Future.delayed(const Duration(milliseconds: 100), () async {
          await automaticLogon();
        });
      }
    }
  }
}

