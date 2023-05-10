import 'package:orginone/dart/core/enum.dart';

import 'company.dart';

abstract class IHospital extends ICompany {}

class Hospital extends Company implements IHospital {
  Hospital(super.metadata, super.user){
    departmentTypes = [
      TargetType.section,
      TargetType.office,
      TargetType.working,
      TargetType.research,
      TargetType.laboratory,
      TargetType.department,
    ];
  }
}
