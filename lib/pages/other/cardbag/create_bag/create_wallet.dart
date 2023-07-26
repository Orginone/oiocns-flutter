import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/buttons.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/unified.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController verifyPassWordController = TextEditingController();

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
          Expanded(child: SizedBox()),
          elevatedButton("创建", onPressed: () {
            Routers.changeTransition();
            Get.offAndToNamed(Routers.cardbag);
          }),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
