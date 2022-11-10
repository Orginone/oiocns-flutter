import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form/uploader.dart';

class FormBuilderUploaderField extends FormBuilderField<String> {
  FormBuilderUploaderField({
    Key? key,
    required super.name,
  }) : super(
          key: key,
          builder: (FormFieldState<String> state) {
            return Uploader(progress: 0.0.obs);
          },
        );

  @override
  FormBuilderFieldState<FormBuilderUploaderField, String> createState() =>
      _FormBuilderUploaderState();
}

class _FormBuilderUploaderState
    extends FormBuilderFieldState<FormBuilderUploaderField, String> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
  }
}
