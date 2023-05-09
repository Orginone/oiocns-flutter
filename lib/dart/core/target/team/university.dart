import 'package:orginone/dart/core/enum.dart';

import 'company.dart';

abstract class IUniversity extends ICompany {}

class University extends Company implements IUniversity {
  University(super.metadata, super.user){
    departmentTypes = [
      TargetType.college,
      TargetType.office,
      TargetType.working,
      TargetType.research,
      TargetType.laboratory,
      TargetType.department,
    ];
  }
}
