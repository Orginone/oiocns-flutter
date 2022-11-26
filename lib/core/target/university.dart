import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/company.dart';

class University extends Company {
  University(super.target);

  @override
  // TODO: implement subTypes
  get subTypes => <TargetType>[
    TargetType.group,
    TargetType.jobCohort,
    TargetType.office,
    TargetType.working,
    TargetType.section,
    TargetType.college,
    TargetType.laboratory,
  ];
}
