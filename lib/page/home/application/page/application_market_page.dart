import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationMarketPage extends GetView<ApplicationMarketController> {
  const ApplicationMarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [],
      ),
    );
  }

  Widget _item() {
    return Container(

    );
  }
}

class ApplicationMarketController extends GetxController {}

class ApplicationMarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationMarketController());
  }
}
