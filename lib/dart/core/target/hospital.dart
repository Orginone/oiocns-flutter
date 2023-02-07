import '../../base/schema.dart';
import '../enum.dart';
import 'company.dart';

class Hospital extends Company {
  Hospital(XTarget target, String userId) : super(target, userId) {
    subTeamTypes = [
      TargetType.jobCohort,
      TargetType.office,
      TargetType.working,
      TargetType.section,
      TargetType.station,
      TargetType.laboratory,
    ];
  }
}
