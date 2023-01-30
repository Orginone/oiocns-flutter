import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/company.dart';

class Hospital extends Company {
  Hospital(super.target);

  @override
  get subTypes => <TargetType>[
        TargetType.group,
        TargetType.jobCohort,
        TargetType.office,
        TargetType.working,
        TargetType.section,
        TargetType.laboratory,
      ];
}
