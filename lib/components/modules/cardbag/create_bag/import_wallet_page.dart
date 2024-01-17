import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({Key? key}) : super(key: key);

  @override
  State<ImportWalletPage> createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  TextEditingController mnemonicController = TextEditingController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController verifyPassWordController = TextEditingController();

  var passwordUnVisible = true;

  var verifyPassWordUnVisible = true;

  String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  @override
  Widget build(BuildContext context) {
    bool isBagList = Get.arguments?['isBagList'] ?? false;

    return GyScaffold(
      titleName: "导入钱包",
      leading: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.black,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          Get.back();
          RoutePages.changeTransition();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Ionicons.scan_outline),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonWidget.commonTextTile("", "",
                controller: mnemonicController,
                maxLine: 5,
                hint: '请输入助记词,用空格分隔',
                backgroundColor: Colors.grey.shade200,
                hintTextStyle: TextStyle(color: Colors.grey, fontSize: 20.sp),
                textStyle: TextStyle(color: Colors.black, fontSize: 20.sp)),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "账户支持导入所有遵循BIP标准生成的助记词",
              style: TextStyle(color: Colors.blueAccent, fontSize: 20.sp),
            ),
            SizedBox(height: 30.h),
            CommonWidget.commonTextField(
                controller: userNameController, hint: "请输入用户名", title: "用户名"),
            SizedBox(
              height: 10.h,
            ),
            CommonWidget.commonTextField(
                controller: passWordController,
                hint: "请输入密码",
                title: "密码",
                obscureText: passwordUnVisible,
                action: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordUnVisible = !passwordUnVisible;
                      });
                    },
                    icon: Icon(
                      passwordUnVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 24.w,
                      color: Colors.grey,
                    ))),
            SizedBox(
              height: 10.h,
            ),
            CommonWidget.commonTextField(
              controller: verifyPassWordController,
              hint: "请再次输入密码",
              title: "确认密码",
              obscureText: verifyPassWordUnVisible,
              action: IconButton(
                onPressed: () {
                  setState(() {
                    verifyPassWordUnVisible = !verifyPassWordUnVisible;
                  });
                },
                icon: Icon(
                  verifyPassWordUnVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 24.w,
                  color: Colors.grey,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            CommonWidget.commonSubmitWidget(
                text: "开始导入",
                submit: () async {
                  if (userNameController.text.isEmpty) {
                    ToastUtils.showMsg(msg: "请输入用户名");
                    return;
                  }
                  if (passWordController.text.isEmpty) {
                    ToastUtils.showMsg(msg: "请输入密码");
                    return;
                  }
                  if (passWordController.text !=
                      verifyPassWordController.text) {
                    ToastUtils.showMsg(msg: "两次密码不正确");
                    return;
                  }

                  String mnemonics;
                  if (mnemonicController.text.contains(RegExp(CHINESE_REGEX))) {
                    mnemonics = mnemonicController.text
                        .replaceAll(" ", '')
                        .split('')
                        .toList()
                        .join(' ');
                  } else {
                    mnemonics = mnemonicController.text;
                  }
                  bool success = await walletCtrl.createWallet(mnemonics,
                      userNameController.text, passWordController.text);
                  if (success) {
                    ToastUtils.showMsg(msg: "导入成功");
                    RoutePages.changeTransition();
                    if (!isBagList) {
                      Get.offUntil(GetPageRoute(),
                          (route) => route.settings.name == Routers.home);
                      Get.offAndToNamed(Routers.cardbag);
                    } else {
                      Get.back();
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
