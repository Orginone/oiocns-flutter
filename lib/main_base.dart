import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/wallet_controller.dart';
import 'package:orginone/global.dart';
import 'package:orginone/pages/login/login_transition/view.dart';
import 'dart/controller/index.dart';
import 'utils/storage.dart';

initApp() async {
  errorWatch();
  await Global.init();

  SystemChannels.lifecycle.setMessageHandler((msg) async {
    LogUtil.d(
        '>>>===state:$msg user:${kernel.user == null} isOnline:${kernel.isOnline} inited:${relationCtrl.provider.inited}');
    relationCtrl.appDataController.appLifecycleState = msg ?? "";
    return msg;
  });
  // 监听网络状态变化
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    LogUtil.d('网络状态变化: $result ${result.index}');
    relationCtrl.appDataController.connectivityResult = result;
  });
  // 开启 app
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
}

void errorWatch() {
  var onError = FlutterError.onError; //先将 onerror 保存起来
  FlutterError.onError = (FlutterErrorDetails details) {
    try {
      // onError?.call(details); //调用默认的onError处理
      // Get.dialog(Text(details.exceptionAsString()));
      // Get.dialog(const Text('发生错误'));
      var t = DateUtil.formatDate(DateTime.now(),
          format: "yyyy-MM-dd HH:mm:ss.SSS");

      List errorArray = [];
      var json = Storage.getString('work_page_error');
      if (json != '') {
        errorArray = jsonDecode(json);
      }

      LogUtil.d('=================');
      LogUtil.d('${details.exceptionAsString()}\r\n${details.stack}');
      errorArray.add({
        't': t,
        'errorText': '${details.exceptionAsString()}\r\n${details.stack}'
      });
      Storage.setJson('work_page_error', errorArray);
    } catch (e) {}
  };
}

KernelApi _kernel = KernelApi();
KernelApi get kernel => _kernel;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final RouteObserver<PageRoute> routeObserver = RouteObserver();

IndexController get relationCtrl => Get.find<IndexController>();

/// 钱包相关暂时先注释
WalletController get walletCtrl => Get.find<WalletController>();

const Size screenSize = Size(540, 1170);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  List<String> get account => Storage.getList(Constants.account);
  String get userJson => Storage.getString(Constants.sessionUser);

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
          darkTheme: ThemeData(
              useMaterial3: false,
              listTileTheme: const ListTileThemeData(
                  titleAlignment: ListTileTitleAlignment.center)),
          theme: ThemeData(
              useMaterial3: false,
              listTileTheme: const ListTileThemeData(
                  titleAlignment: ListTileTitleAlignment.center)),
          textDirection: TextDirection.ltr,
          initialRoute:
              userJson.isNotEmpty ? Routers.logintrans : Routers.login,
          defaultTransition: Transition.fadeIn,
          getPages: RoutePages.getInitRouters,
        );
      },
      child: const LoginTransPage(),
    );
  }

  // Future<void> automaticLogon() async {
  //   if (kernel.isOnline) {
  //     await relationCtrl.autoLogin(account);
  //   } else if (relationCtrl.canAutoLogin(account)) {
  //     Future.delayed(const Duration(milliseconds: 100), () async {
  //       await automaticLogon();
  //     });
  //   } else {
  //     relationCtrl.exitLogin(false);
  //   }
  // }
}
