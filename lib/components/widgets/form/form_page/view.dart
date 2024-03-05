import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/form/form_widget/index.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';

import 'index.dart';

class FormPage extends OrginoneStatefulWidget {
  FormPage({super.key, super.data});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends OrginoneStatefulState<FormPage> {
  @override
  Widget buildWidget(BuildContext context, data) {
    return FormWidget(
      mainForm: [data.metadata],
      subForm: const [],
    );
  }
}

class FormPage1 extends GetView<FormController> {
  const FormPage1({Key? key}) : super(key: key);

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
