import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/organization/units/units_controller.dart';

import '../../../../api_resp/tree_node.dart';
import '../../../../component/text_search.dart';
import '../../../../component/text_tag.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/string_util.dart';
import '../../../../util/widget_util.dart';

class UnitsPage extends GetView<UnitsController> {
  const UnitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return UnifiedScaffold(
      appBarTitle: Text(homeController.currentSpace.name, style: text20),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Container(),
    );
  }
}
