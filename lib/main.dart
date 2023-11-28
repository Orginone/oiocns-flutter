import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/wallet_controller.dart';
import 'package:orginone/global.dart';
import 'common/routers/index.dart';
import 'dart/controller/index.dart';
import 'utils/index.dart';

initApp() async {
  await Global.init();
  // 开启 app
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

KernelApi get kernel => KernelApi();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final RouteObserver<PageRoute> routeObserver = RouteObserver();

IndexController get settingCtrl => Get.find<IndexController>();

WalletController get walletCtrl => Get.find<WalletController>();

const Size screenSize = Size(540, 1170);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  List<String> get account => Storage().getList("account");
  // String get userJson => Storage().getString(sessionUserName);

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
          initialRoute: account.isNotEmpty ? Routers.home : Routers.login,
          defaultTransition: Transition.fadeIn,
          getPages: RoutePages.getInitRouters,
        );
      },
    );
  }

  // Future<void> automaticLogon() async {
  //   if (kernel.isOnline) {
  //     await settingCtrl.autoLogin(account);
  //   } else if (settingCtrl.canAutoLogin(account)) {
  //     Future.delayed(const Duration(milliseconds: 100), () async {
  //       await automaticLogon();
  //     });
  //   } else {
  //     settingCtrl.exitLogin(false);
  //   }
  // }
}
