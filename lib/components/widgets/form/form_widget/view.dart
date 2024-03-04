import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/form/form_widget/sub_form/index.dart';
import 'package:orginone/dart/base/schema.dart';

import 'index.dart';
import 'main_form/view.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key, required this.mainForm, required this.subForm})
      : super(key: key);
  final List<XForm> mainForm;
  final List<XForm> subForm;
  @override
  State<FormWidget> createState() =>
      _FormWidgetState(mainForm: mainForm, subForm: subForm);
}

class _FormWidgetState extends State<FormWidget>
    with AutomaticKeepAliveClientMixin {
  _FormWidgetState({required this.mainForm, required this.subForm});

  @override
  bool get wantKeepAlive => true;
  final List<XForm> mainForm;
  final List<XForm> subForm;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _FormWidgetViewGetX(
      mainForm: widget.mainForm,
      subForm: widget.subForm,
    );
  }
}

class _FormWidgetViewGetX extends GetView<FormWidgetController> {
  const _FormWidgetViewGetX({
    Key? key,
    required this.mainForm,
    required this.subForm,
  }) : super(key: key);
  final List<XForm> mainForm;
  final List<XForm> subForm;
  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          MainFormPage(mainForm),
          SubFormPage(subForm),
        ],
      ),
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
