import 'package:flutter/material.dart';

/// 表单验证
class Validators {
  /// Validatorless.password(6, 20, 'password must have between 6 and 20 digits')
  static FormFieldValidator<String> password(int min, int max, String m) =>
      (v) {
        if (v?.isEmpty ?? true) return null;
        if ((v?.length ?? 0) < min) return m;
        if ((v?.length ?? 0) > max) return m;
        return null;
      };
}
