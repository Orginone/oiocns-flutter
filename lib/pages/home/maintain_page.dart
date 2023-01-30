import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/maintain_widget.dart';

class MaintainPage extends StatelessWidget {
  const MaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintainWidget(Get.arguments);
  }
}
