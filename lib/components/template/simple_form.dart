import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/form/form_widget.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/config/forms.dart';

class SimpleForm extends StatelessWidget {
  final FormInfo maintainConfig;

  const SimpleForm(this.maintainConfig, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = GlobalKey<FormBuilderState>();
    var formConfig = maintainConfig.formConfig;
    return OrginoneScaffold(
      appBarTitle: Text(formConfig.title, style: XFonts.size22Black3),
      appBarLeading: XWidgets.defaultBackBtn,
      appBarCenterTitle: true,
      body: Column(
        children: [
          FormWidget(
            formConfig,
            state: state,
          ),
          Padding(padding: EdgeInsets.only(top: 20.h)),
          if (formConfig.status == FormStatus.create ||
              formConfig.status == FormStatus.update)
            _submitBtn(state)
        ],
      ),
    );
  }

  Widget _submitBtn(GlobalKey<FormBuilderState> formKey) {
    var formConfig = maintainConfig.formConfig;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(XColors.themeColor),
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
        if (formConfig.status == FormStatus.create) {
          maintainConfig.call!(value);
        } else if (formConfig.status == FormStatus.update) {
          maintainConfig.call!(value);
        }
      },
      child: const Text("提交", style: TextStyle(color: Colors.white)),
    );
  }
}
