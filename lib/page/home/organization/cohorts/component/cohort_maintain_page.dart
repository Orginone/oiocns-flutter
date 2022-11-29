import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/util/widget_util.dart';

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

class CohortMaintainPage extends GetView<TargetController> {
  const CohortMaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = Get.arguments;
    TargetEvent func = (args["func"] as TargetEvent);
    return UnifiedScaffold(
      appBarTitle: Text(func.funcName, style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarCenterTitle: true,
      body: FormWidget(
        formConfig,
        initValue: args["cohort"] ?? {},
        submitCallback: (Map<String, dynamic> value) async {
          if (func == TargetEvent.updateCohort) {
            controller.updateCohort(value);
          } else {
            controller.createCohort(value);
          }
        },
      ),
    );
  }
}
