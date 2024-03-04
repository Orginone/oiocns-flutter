import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/form/form_widget/index.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';

import 'index.dart';

class FormPage extends GetView<FormController> {
  const FormPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return FormWidget(
      mainForm: controller.mainForm,
      subForm: controller.subForm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      init: FormController(),
      id: "form",
      builder: (_) {
        return GyScaffold(
          // appBar: AppBar(title: const Text("form")),
          titleName: controller.title,
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
