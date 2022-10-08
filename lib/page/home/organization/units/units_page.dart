import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/organization/units/units_controller.dart';

import '../../../../component/text_search.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSearch(controller.searchingCallback),
          BreadCrumb(controller: controller.breadCrumbController),
          ListView.builder(itemBuilder: (BuildContext context, int index) {
            return Container();
          })
        ],
      ),
    );
  }
}
