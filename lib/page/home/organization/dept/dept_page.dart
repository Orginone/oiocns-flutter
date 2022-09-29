import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'dept_controller.dart';

import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/widget_util.dart';

class DeptPage extends GetView<DeptController> {
  const DeptPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("组织架构", style: text20),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Container(),
    );
  }
}
