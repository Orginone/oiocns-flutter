import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'company.dart';

class Hospital extends Company {
  Hospital(XTarget target, String userId) : super(target, userId) {
    subTeamTypes = [
      TargetType.JobCohort,
      TargetType.Office,
      TargetType.Working,
      TargetType.Section,
      TargetType.Station,
      TargetType.Laboratory,
    ];
  }
}
