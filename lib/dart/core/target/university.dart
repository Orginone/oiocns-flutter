import '../../base/schema.dart';
import '../enum.dart';
import 'company.dart';

class University extends Company {
  University(XTarget target, String userId) : super(target, userId) {
    super.departmentTypes = [TargetType.college, ...departmentTypes];
    subTeamTypes = [...departmentTypes, TargetType.working];
    extendTargetType = [...subTeamTypes, ...companyTypes];
    joinTargetType = [TargetType.group];
    createTargetType = [
      ...subTeamTypes,
      TargetType.station,
      TargetType.group,
      TargetType.cohort,
    ];
    searchTargetType = [TargetType.person, TargetType.group];
  }
}
