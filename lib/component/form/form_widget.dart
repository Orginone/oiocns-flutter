import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_colors.dart';

import '../../util/valid_util.dart';
import '../a_font.dart';
import 'form_builder_uploader.dart';

enum ItemType { text, upload }

class FormItem {
  final String fieldKey;
  final String fieldName;
  final ItemType itemType;

  const FormItem({
    required this.fieldKey,
    required this.fieldName,
    required this.itemType,
  });
}

const String defaultSubmitName = '提交';
const EdgeInsets defaultPadding = EdgeInsets.only(left: 25, right: 25);

class FormWidget extends StatelessWidget {
  final Map<String, dynamic>? initValue;
  final List<FormItem> items;
  final EdgeInsets padding;
  final Function? submitCallback;
  final String submitName;

  const FormWidget(
    this.items, {
    this.initValue,
    this.padding = defaultPadding,
    this.submitName = defaultSubmitName,
    this.submitCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final children = items.map(_itemMapping).toList();
    return FormBuilder(
      initialValue: initValue ?? {},
      key: formKey,
      child: Container(
        padding: padding,
        child: Column(
          children: children
            ..add(Padding(padding: EdgeInsets.only(top: 20.h)))
            ..add(_submitBtn(formKey)),
        ),
      ),
    );
  }

  Widget _itemMapping(FormItem item) {
    switch (item.itemType) {
      case ItemType.text:
        return _text(item);
      case ItemType.upload:
        return _uploader(item);
    }
  }

  Widget _text(FormItem item) {
    return FormBuilderTextField(
      validator: (value) => ValidUtil.isEmpty(item.fieldName, value),
      name: item.fieldKey,
      decoration: _formDecoration(item.fieldName),
      onChanged: (val) {},
    );
  }

  Widget _uploader(FormItem item) {
    return FormBuilderUploaderField(name: item.fieldName);
  }

  InputDecoration _formDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AFont.instance.size22Black0,
    );
  }

  Widget _submitBtn(GlobalKey<FormBuilderState> formKey) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(UnifiedColors.themeColor),
        fixedSize: MaterialStateProperty.all(Size.fromWidth(400.w)),
      ),
      onPressed: () {
        if (!formKey.currentState!.saveAndValidate()) {
          return;
        }
        if (submitCallback != null) {
          var value = Map<String, dynamic>.of(formKey.currentState!.value);
          initValue?.forEach((initKey, initValue) {
            value.putIfAbsent(initKey, () => initValue);
          });
          submitCallback!(value);
        }
      },
      child: Text(submitName, style: const TextStyle(color: Colors.white)),
    );
  }
}
