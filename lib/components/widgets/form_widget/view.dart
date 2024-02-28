import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/form_widget/sub_form/index.dart';

import 'index.dart';
import 'main_form/view.dart';

class FormWidgetPage extends StatefulWidget {
  const FormWidgetPage({Key? key}) : super(key: key);

  @override
  State<FormWidgetPage> createState() => _FormWidgetPageState();
}

class _FormWidgetPageState extends State<FormWidgetPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _FormWidgetViewGetX();
  }
}

class _FormWidgetViewGetX extends GetView<FormWidgetController> {
  const _FormWidgetViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Column(
      children: <Widget>[
        MainFormPage(controller.mainForm),
        SubFormPage(controller.subForm),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormWidgetController>(
      init: FormWidgetController(),
      id: "form_widget",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
