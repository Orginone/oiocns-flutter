import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/simple_form.dart';

class MaintainPage extends StatelessWidget {
  const MaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleForm(Get.arguments);
  }
}
