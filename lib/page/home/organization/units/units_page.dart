import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/organization/units/units_controller.dart';

import '../../../../component/a_font.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/widget_util.dart';

class UnitsPage extends GetView<UnitsController> {
  const UnitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return UnifiedScaffold(
      appBarTitle: Text(homeController.currentSpace.name, style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Container(),
    );
  }
}
