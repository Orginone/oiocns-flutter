



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';

class TargetText extends StatelessWidget {

  final String userId;

  final String? text;

  final TextStyle? style;

  final int? maxLines;

  final TextOverflow? overflow;

  final TextAlign? textAlign;

  const TargetText({Key? key, required this.userId, this.style, this.maxLines, this.overflow, this.textAlign, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<ShareIcon>(builder: (context,snapshot) {
      String name = '';

      if (snapshot.hasData) {
        name = snapshot.data?.name ?? "";
      }

      return Text("$name${text??""}", style: style,maxLines: maxLines,overflow: overflow,textAlign: textAlign,);
    },future: settingCtrl.provider.user?.findShareById(userId),);
  }
}
