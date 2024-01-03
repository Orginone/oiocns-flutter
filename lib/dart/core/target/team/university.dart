import 'package:orginone/dart/core/public/enums.dart';

import 'company.dart';

abstract class IUniversity extends ICompany {}

class University extends Company implements IUniversity {
  University(super.metadata, super.user) {
    departmentTypes = [
      TargetType.college.label,
      TargetType.office.label,
      TargetType.working.label,
      TargetType.research.label,
      TargetType.laboratory.label,
      TargetType.department.label,
    ];
  }
}
