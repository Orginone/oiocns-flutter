import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/notification_util.dart';
import 'util/hive_utils.dart';
import 'util/local_store.dart';


void main() async {
  // 逻辑绑定
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await HiveUtils.init();

  // 初始化通知配置
  NotificationUtil.initNotification();
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

KernelApi get kernel => KernelApi();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver();

SettingController get settingCtrl => Get.find<SettingController>();
const Size screenSize = Size(540, 1170);

class ScreenInit extends StatelessWidget {
  const ScreenInit({Key? key}) : super(key: key);

  List<String>? get account => LocalStore.getStore().getStringList("account");

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
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
        );
      },
    );
  }

  Future<void> automaticLogon() async{
    Future<void> login() async {
      String accountName = account![0];
      String passWord = account![1];
      var login = await settingCtrl.provider.login(accountName, passWord);
      if(login.success){
        print('登录成功');
      }else{
        ToastUtils.showMsg(msg: login.msg);
        Get.offAllNamed(Routers.login);
      }
    }

    if (account != null) {
      if (kernel.isOnline) {
        await login();
      } else {
        Future.delayed(const Duration(milliseconds: 100), () async {
          await automaticLogon();
        });
      }
    }
  }
}

