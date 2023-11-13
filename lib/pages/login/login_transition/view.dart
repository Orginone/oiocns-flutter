import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/common/values/index.dart';

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
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          AssetsImages.loginTransition,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
