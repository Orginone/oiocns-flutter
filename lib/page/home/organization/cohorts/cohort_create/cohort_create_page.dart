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

class CohortCreatePage extends GetView<CohortsController> {
  const CohortCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("群组创建", style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarCenterTitle: true,
      body: FormWidget(formConfig, submitCallback: (value) {
        controller.createCohort(value).then((value) => Get.back());
      }),
    );
  }
}
