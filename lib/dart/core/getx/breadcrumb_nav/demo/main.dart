import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/main.dart';

import 'demo1/binding.dart';
import 'demo1/view.dart';
import 'demo2/binding.dart';
import 'demo2/view.dart';
import 'demo3/binding.dart';
import 'demo3/view.dart';

void main() async {
  // 开启 app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

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
          initialRoute: "/demo1",
          getPages: getInitRouters(),
        );
      },
    );
  }
}

List<GetPage> getInitRouters() {
  return [
    GetPage(
      name: '/demo1',
      page: () => Demo1Page(),
      binding: Demo1Binding(),
    ),
    GetPage(
      name: '/demo2',
      page: () => Demo2Page(),
      binding: Demo2Binding(),
    ),
    GetPage(
      name: '/demo3',
      page: () => Demo3Page(),
      binding: Demo3Binding(),
    ),
  ];
}
