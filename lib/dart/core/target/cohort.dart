import 'package:orginone/dart/base/enumeration/target_type.dart';
import 'package:orginone/dart/core/target/base_target.dart';

class Cohort extends BaseTarget {
  Cohort(super.target);

  /// 拉人进入群组
  /// @param personIds 人员id数组
  Future<void> pullPersons(List<String> personIds) async {
    await super.pull(targetType: TargetType.person, targetIds: personIds);
  }
}
