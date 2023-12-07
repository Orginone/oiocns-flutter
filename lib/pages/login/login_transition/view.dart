import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/index.dart';

import '../../../common/routers/index.dart';

class LoginTransPage extends StatefulWidget {
  const LoginTransPage({super.key});

  @override
  State<LoginTransPage> createState() => _LoginTransPageState();
}

class _LoginTransPageState extends State<LoginTransPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAndToNamed(Routers.home, arguments: true);
    });
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
          Container(
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
          ),
          //奥集能 模块
          Positioned(
            bottom: 100.00,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsImages.logoPng),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text.rich(TextSpan(
                    text: '奥集能',
                    style: TextStyle(
                      color: Color(0xFF15181D),
                      fontSize: 22.91,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ),
          ),

          //文字Orginone 区域
          const Positioned(
            left: 0,
            right: 0,
            top: 290,
            child: Text(
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
          const Positioned(
            left: 0,
            right: 0,
            top: 260,
            child: Text(
              '物以类聚，人以群分。',
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
        ],
      ),
    );
  }
}
