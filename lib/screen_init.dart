import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:orginone/routers.dart';

class ScreenInit extends StatelessWidget {
  const ScreenInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          textDirection: TextDirection.ltr,
          initialRoute: Routers.main,
          getPages: Routers.getInitRouters(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
