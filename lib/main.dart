import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/channel/wallet_channel.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/wallet_controller.dart';
import 'package:orginone/utils/foreground_utils.dart';
import 'package:orginone/utils/notification_util.dart';
import 'common/routers/index.dart';
import 'dart/controller/index.dart';
import 'utils/hive_utils.dart';
import 'utils/index.dart';

void main() async {
  // 逻辑绑定
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await HiveUtils.init();

  await NotificationUtil.initializeService();

  // 初始化通知配置
  await Storage().init();

  ForegroundUtils().initForegroundTask();

  WalletChannel().init();
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

KernelApi get kernel => KernelApi();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final RouteObserver<PageRoute> routeObserver = RouteObserver();

IndexController get settingCtrl => Get.find<IndexController>();

WalletController get walletCtrl => Get.find<WalletController>();

const Size screenSize = Size(540, 1170);

class ScreenInit extends StatelessWidget {
  const ScreenInit({Key? key}) : super(key: key);

  // List<String> get account => Storage().getList("account");
  String get userJson => Storage().getString(sessionUserName);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorObservers: [RoutePages.observer],
          navigatorKey: navigatorKey,
          initialBinding: UserBinding(),
          onInit: () async {
            // await automaticLogon();
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
          darkTheme: ThemeData(useMaterial3: false),
          textDirection: TextDirection.ltr,
          initialRoute: userJson.isNotEmpty
              ? Routers.home
              : Routers
                  .login, //account.isNotEmpty ? Routers.home : Routers.login,
          defaultTransition: Transition.fadeIn,
          getPages: RoutePages.getInitRouters,
        );
      },
    );
  }

  // Future<void> automaticLogon() async {
  //   Future<void> login() async {
  //     // Storage.clear();
  //     if (account.isEmpty) {
  //       settingCtrl.exitLogin();
  //       return;
  //     }
  //     String accountName = account.first;
  //     String passWord = account.last;
  //     var login = await settingCtrl.provider.login(accountName, passWord);
  //     if (!login.success) {
  //       settingCtrl.exitLogin();
  //     }
  //   }

  //   if (kernel.isOnline) {
  //     await login();
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 100), () async {
  //       await automaticLogon();
  //     });
  //   }
  // }
}
