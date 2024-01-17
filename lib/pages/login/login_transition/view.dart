import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/index.dart';
import 'package:orginone/main_bean.dart';

import '../../../common/routers/index.dart';

class LoginTransPage extends StatefulWidget {
  const LoginTransPage({super.key});

  @override
  State<LoginTransPage> createState() => _LoginTransPageState();
}

class _LoginTransPageState extends State<LoginTransPage> {
  @override
  Widget build(BuildContext context) {
    try {
      relationCtrl.subscribe((key, args) {
        Get.offAndToNamed(Routers.home, arguments: true);
        Future.delayed(const Duration(milliseconds: 10), () {
          relationCtrl.unsubscribe(key);
        });
      });
    } catch (e) {}
    return Scaffold(
      // backgroundColor: Colors.white,
      // body: SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   child: Image.asset(
      //     AssetsImages.loginTransition,
      //     fit: BoxFit.cover,
      //   ),
      // ),

      body: _login(),
    );
  }

  Widget _login() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          //背景图模块
          background(),
          //奥集能 模块
          logo(),
          //文字Orginone 区域
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.30,
            child: const Text(
              '物以类聚  人以群分',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF366EF4),
                fontSize: 25,
                fontFamily: 'DingTalk',
                fontWeight: FontWeight.w400,
                height: 0.06,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.33,
            child: const Text(
              'Orginone',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF366EF4),
                fontSize: 18,
                fontFamily: 'DingTalk',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //logo
  Widget logo() {
    return Positioned(
      bottom: 100.h,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              width: 30,
              height: 30,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.logoNoBg),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Text.rich(TextSpan(
              text: '奥集能',
              style: TextStyle(
                color: Color(0xFF15181D),
                fontSize: 17,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      ),
    );
  }

  //背景图
  Widget background() {
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: -200,
            child: Container(
              width: 900,
              height: 500,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.logoBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: -200,
            child: Container(
              width: 900,
              height: 500,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(249, 249, 249, 0),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
