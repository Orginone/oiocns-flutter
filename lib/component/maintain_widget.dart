import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

enum MaintainStatus { view, create, update }

class FormConfig {
  final String title;
  final MaintainStatus status;
  final List<FormItem> items;
  final Map<String, dynamic>? initValue;

  const FormConfig({
    required this.title,
    required this.status,
    required this.items,
    this.initValue,
  });
}

class MaintainInfo {
  final FormConfig formConfig;
  final Function(Map<String, dynamic>)? call;

  MaintainInfo({required this.formConfig, this.call});
}

class MaintainWidget extends StatelessWidget {
  final MaintainInfo maintainConfig;

  const MaintainWidget(this.maintainConfig, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = GlobalKey<FormBuilderState>();
    var formConfig = maintainConfig.formConfig;
    return UnifiedScaffold(
      appBarTitle: Text(formConfig.title, style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarCenterTitle: true,
      body: Column(
        children: [
          FormWidget(
            formConfig,
            state: state,
          ),
          Padding(padding: EdgeInsets.only(top: 20.h)),
          if (formConfig.status == MaintainStatus.create ||
              formConfig.status == MaintainStatus.update)
            _submitBtn(state)
        ],
      ),
    );
  }

  Widget _submitBtn(GlobalKey<FormBuilderState> formKey) {
    var formConfig = maintainConfig.formConfig;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(UnifiedColors.themeColor),
        fixedSize: MaterialStateProperty.all(Size.fromWidth(400.w)),
      ),
      onPressed: () {
        if (!formKey.currentState!.saveAndValidate()) {
          return;
        }
        var value = Map<String, dynamic>.of(formKey.currentState!.value);
        formConfig.initValue?.forEach((initKey, initValue) {
          value.putIfAbsent(initKey, () => initValue);
        });
        if (formConfig.status == MaintainStatus.create) {
          maintainConfig.call!(value);
        } else if (formConfig.status == MaintainStatus.update) {
          maintainConfig.call!(value);
        }
      },
      child: const Text("提交", style: TextStyle(color: Colors.white)),
    );
  }
}
