import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationManagerPage extends GetView<ApplicationManagerController> {
  const ApplicationManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("资产管理", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
    );
  }
}

class ApplicationManagerController extends GetxController {}

class ApplicationManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationManagerController());
  }
}
