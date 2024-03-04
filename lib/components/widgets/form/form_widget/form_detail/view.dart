import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/form/form_widget/main_form/index.dart';

import 'index.dart';

class FormDetailPage extends GetView<FormDetailController> {
  const FormDetailPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    if (controller.form == null) {
      return Container();
    }
    return SingleChildScrollView(
        child: MainFormPage(
      [controller.form!],
      infoIndex: controller.infoIndex,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormDetailController>(
      init: FormDetailController(),
      id: "form_detail",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text(controller.form?.name ?? '')),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
