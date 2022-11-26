import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/base_target.dart';

class Company extends BaseTarget {
  Company(super.target);

  get subTypes => <TargetType>[
        TargetType.jobCohort,
        TargetType.department,
        TargetType.working,
        TargetType.section,
        TargetType.group,
      ];

  /// 拉人进入单位
  Future<void> pullPersons(List<String> personIds) async {
    await super.pull(targetType: TargetType.person, targetIds: personIds);
  }
}
