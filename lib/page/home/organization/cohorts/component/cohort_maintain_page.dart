import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_controller.dart';

import '../../../../../component/a_font.dart';
import '../../../../../component/form_widget.dart';
import '../../../../../util/widget_util.dart';

List<FormItem> formConfig = [
  const FormItem(
    fieldKey: 'name',
    fieldName: "群组名称",
    itemType: ItemType.text,
  ),
  const FormItem(
    fieldKey: 'code',
    fieldName: "群组编号",
    itemType: ItemType.text,
  ),
  const FormItem(
    fieldKey: 'remark',
    fieldName: "群组简介",
    itemType: ItemType.text,
  ),
];

class CohortMaintainPage extends GetView<CohortsController> {
  const CohortMaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = "";
    Map<String, dynamic> args = Get.arguments;
    CohortFunction func = args["func"];
    if (func == CohortFunction.update) {
      label = CohortFunction.update.funcName;
    } else {
      label = CohortFunction.create.funcName;
    }
    return UnifiedScaffold(
      appBarTitle: Text(label, style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarCenterTitle: true,
      body: FormWidget(
        formConfig,
        initValue: args["cohort"],
        submitCallback: (Map<String, dynamic> value) {
          if (func == CohortFunction.update) {
            controller.updateCohort(value).then((value) => Get.back());
          } else {
            controller.createCohort(value).then((value) => Get.back());
          }
        },
      ),
    );
  }
}
