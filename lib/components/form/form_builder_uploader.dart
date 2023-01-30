import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/form/form_widget.dart';
import 'package:orginone/components/form/uploader.dart';

class FormBuilderUploaderField extends FormBuilderField<String> {
  final FormItem item;
  final bool readOnly;

  FormBuilderUploaderField({
    Key? key,
    required this.item,
    required FormFieldValidator<String>? validator,
    this.readOnly = false,
  }) : super(
          key: key,
          name: item.fieldKey,
          validator: validator,
          builder: (FormFieldState<String> state) {
            var uploadState = state as _FormBuilderUploaderState;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 10.h)),
                Text(item.fieldName, style: AFont.instance.size18Black0),
                Padding(padding: EdgeInsets.only(bottom: 10.h)),
                readOnly
                    ? Text(uploadState.value ?? "")
                    : Uploader(
                        progress: uploadState.getProgress,
                        errorText: uploadState.errorText,
                        uploadedCall: (progress, fileName) {
                          uploadState.setProgress(progress);
                          uploadState.setValue(fileName);
                        },
                      )
              ],
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
}
