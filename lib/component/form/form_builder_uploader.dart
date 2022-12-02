import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/form/uploader.dart';

class FormBuilderUploaderField extends FormBuilderField<String> {
  final FormItem item;

  FormBuilderUploaderField({
    Key? key,
    required this.item,
    required FormFieldValidator<String>? validator,
  }) : super(
          key: key,
          name: item.fieldName,
          validator: validator,
          builder: (FormFieldState<String> state) {
            var uploadState = state as _FormBuilderUploaderState;
            return Uploader(
              progress: uploadState.getProgress,
              errorText: uploadState.errorText,
              uploadedCall: (progress, fileName) {
                uploadState.setProgress(progress);
                uploadState.setValue(fileName);
              },
            );
          },
        );

  @override
  FormBuilderFieldState<FormBuilderUploaderField, String> createState() =>
      _FormBuilderUploaderState();
}

class _FormBuilderUploaderState
    extends FormBuilderFieldState<FormBuilderUploaderField, String> {
  final RxDouble _progress = 0.0.obs;

  double get getProgress => _progress.value;

  setProgress(double progress) {
    setState(() {
      _progress.value = progress;
    });
  }

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
