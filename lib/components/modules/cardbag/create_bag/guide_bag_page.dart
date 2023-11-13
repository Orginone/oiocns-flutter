import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/widgets/buttons.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

class GuideBagPage extends StatelessWidget {
  const GuideBagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.black,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          Navigator.maybePop(context);
          RoutePages.changeTransition();
        },
      ),
      body: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                elevatedButton(
                  "创建新钱包",
                  onPressed: () {
                    Get.toNamed(Routers.createBag);
                  },
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0x11000000)),
                    ),
                    onPressed: () {
                      Get.toNamed(Routers.importWallet);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "导入钱包",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "支持任意钱包的助记词或私钥导入",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
