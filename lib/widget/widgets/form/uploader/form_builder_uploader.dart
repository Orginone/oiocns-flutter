import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/form/uploader/uploader.dart';
import 'package:orginone/config/forms.dart';

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
                Text(item.fieldName, style: XFonts.size18Black0),
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
