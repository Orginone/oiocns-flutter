import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/pages/setting/organization/units/units_controller.dart';
import 'package:orginone/util/widget_util.dart';

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
