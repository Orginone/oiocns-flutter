import 'package:orginone/dart/core/public/enums.dart';

import 'company.dart';

abstract class IHospital extends ICompany {}

class Hospital extends Company implements IHospital {
  Hospital(super.metadata, super.user) {
    departmentTypes = [
      TargetType.section.label,
      TargetType.office.label,
      TargetType.working.label,
      TargetType.research.label,
      TargetType.laboratory.label,
      TargetType.department.label,
    ];
  }
}
