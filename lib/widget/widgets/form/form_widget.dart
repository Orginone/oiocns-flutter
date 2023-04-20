import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/form/uploader/form_builder_uploader.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/config/forms.dart';

enum ItemType { text, multiText, upload, onOff }

const EdgeInsets defaultPadding = EdgeInsets.only(left: 25, right: 25);

class FormWidget extends StatelessWidget {
  final GlobalKey<FormBuilderState>? state;
  final FormConfig formConfig;
  final EdgeInsets padding;

  const FormWidget(
    this.formConfig, {
    this.state,
    this.padding = defaultPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = formConfig.items.map(_itemMapping).toList();
    return FormBuilder(
      initialValue: formConfig.initValue ?? {},
      key: state,
      child: Container(
        padding: padding,
        child: Column(children: children),
      ),
    );
  }

  Widget _itemMapping(FormItem item) {
    switch (item.itemType) {
      case ItemType.text:
        return _text(item, false);
      case ItemType.multiText:
        return _text(item, true);
      case ItemType.upload:
        return _uploader(item);
      case ItemType.onOff:
        return _switch(item);
    }
  }

  Widget _text(FormItem item, bool isMultiple) {
    return FormBuilderTextField(
      maxLines: isMultiple ? null : 1,
      keyboardType: isMultiple ? TextInputType.multiline : TextInputType.text,
      readOnly: formConfig.status == FormStatus.view,
      validator: (value) {
        if (item.required && (value?.isEmpty ?? true)) {
          return "${item.fieldName}不能为空！";
        }
        return null;
      },
      name: item.fieldKey,
      decoration: InputDecoration(
        labelText: item.fieldName,
        labelStyle: XFonts.size22Black0,
        constraints: BoxConstraints(
          maxHeight: 144.h,
        ),
      ),
      onChanged: (val) {},
    );
  }

  Widget _switch(FormItem item) {
    return FormBuilderSwitch(
      enabled: formConfig.status != FormStatus.view,
      validator: (value) {
        if (item.required) {
          return;
        }
        return null;
      },
      name: item.fieldKey,
      title: Text(item.fieldName),
    );
  }

  Widget _uploader(FormItem item) {
    return FormBuilderUploaderField(
      readOnly: formConfig.status == FormStatus.view,
      validator: (value) {
        if (item.required && (value?.isEmpty ?? true)) {
          return "${item.fieldName}不能为空！";
        }
        return null;
      },
      item: item,
    );
  }
}
