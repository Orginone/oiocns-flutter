import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_colors.dart';

import '../../util/valid_util.dart';
import '../a_font.dart';
import 'form_builder_uploader.dart';

enum ItemType { text, upload, onOff }

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
  final Map<String, dynamic>? initValue;
  final List<FormItem> items;
  final EdgeInsets padding;

  const FormWidget(
    this.items, {
    this.state,
    this.initValue,
    this.padding = defaultPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = items.map(_itemMapping).toList();
    return FormBuilder(
      initialValue: initValue ?? {},
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
        return _text(item);
      case ItemType.upload:
        return _uploader(item);
      case ItemType.onOff:
        return _switch(item);
    }
  }

  Widget _text(FormItem item) {
    return FormBuilderTextField(
      validator: (value) {
        if (item.required) {
          return ValidUtil.isEmpty(item.fieldName, value);
        }
        return null;
      },
      initialValue: item.defaultValue,
      name: item.fieldKey,
      decoration: _formDecoration(item.fieldName),
      onChanged: (val) {},
    );
  }

  Widget _switch(FormItem item) {
    return FormBuilderSwitch(
      validator: (value) {
        if (item.required) {
          return;
        }
        return null;
      },
      initialValue: item.defaultValue ?? false,
      name: item.fieldKey,
      title: Text(item.fieldName),
    );
  }

  Widget _uploader(FormItem item) {
    return FormBuilderUploaderField(
      validator: (value) {
        if (item.required) {
          return ValidUtil.isEmpty(item.fieldName, value);
        }
        return null;
      },
      item: item,
    );
  }

  InputDecoration _formDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AFont.instance.size22Black0,
    );
  }
}
