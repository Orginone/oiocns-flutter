import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/page/home/organization/units/units_controller.dart';

import '../../../../component/a_font.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../util/widget_util.dart';

class UnitsPage extends GetView<UnitsController> {
  const UnitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text(
        auth.spaceInfo.name,
        style: AFont.instance.size22Black3,
      ),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Container(),
    );
  }
}
