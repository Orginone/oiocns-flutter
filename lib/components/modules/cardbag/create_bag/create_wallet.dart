import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/modules/cardbag/index.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/config/unified.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController verifyPassWordController = TextEditingController();

  CreateBagController get controller => Get.find();

  var passwordUnVisible = true;

  var verifyPassWordUnVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30.h),
          Text("创建钱包", style: XFonts.size28Black0W700),
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
                    passwordUnVisible ? Icons.visibility_off : Icons.visibility,
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
          elevatedButton("创建", onPressed: () async {
            if (userNameController.text.isEmpty) {
              ToastUtils.showMsg(msg: "请输入用户名");
              return;
            }
            if (passWordController.text.isEmpty) {
              ToastUtils.showMsg(msg: "请输入密码");
              return;
            }
            if (passWordController.text != verifyPassWordController.text) {
              ToastUtils.showMsg(msg: "两次密码不正确");
              return;
            }

            dynamic mnemonics;
            if (controller.state.mnemonicType == 0) {
              mnemonics = controller.state.mnemonics.join(' ');
            } else {
              mnemonics = controller.state.mnemonics.join('');
              mnemonics = mnemonics.split('').toList().join(' ');
            }
            bool success = await walletCtrl.createWallet(
                mnemonics, userNameController.text, passWordController.text);
            if (success) {
              ToastUtils.showMsg(msg: "创建成功");
              RoutePages.changeTransition();
              if (!controller.state.isBagList) {
                Get.offUntil(GetPageRoute(),
                    (route) => route.settings.name == Routers.home);
                Get.offAndToNamed(Routers.cardbag);
              } else {
                Get.back();
              }
            }
          }),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
