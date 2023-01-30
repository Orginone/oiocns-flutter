import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/maintain_widget.dart';

import '../../util/valid_util.dart';
import '../a_font.dart';
import 'form_builder_uploader.dart';

enum ItemType { text, multiText, upload, onOff }

class FormItem {
  final String fieldKey;
  final String fieldName;
  final ItemType itemType;
  final bool required;
  final dynamic defaultValue;

  const FormItem({
    required this.fieldKey,
    required this.fieldName,
    required this.itemType,
    this.required = false,
    this.defaultValue,
  });
}

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
      readOnly: formConfig.status == MaintainStatus.view,
      validator: (value) {
        if (item.required) {
          return ValidUtil.isEmpty(item.fieldName, value);
        }
        return null;
      },
      name: item.fieldKey,
      decoration: InputDecoration(
        labelText: item.fieldName,
        labelStyle: AFont.instance.size22Black0,
        constraints: BoxConstraints(
          maxHeight: 144.h,
        ),
      ),
      onChanged: (val) {},
    );
  }

  Widget _switch(FormItem item) {
    return FormBuilderSwitch(
      enabled: formConfig.status != MaintainStatus.view,
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
      readOnly: formConfig.status == MaintainStatus.view,
      validator: (value) {
        if (item.required) {
          return ValidUtil.isEmpty(item.fieldName, value);
        }
        return null;
      },
      item: item,
    );
  }
}
