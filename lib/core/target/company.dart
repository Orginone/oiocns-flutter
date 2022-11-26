import 'package:orginone/api/company_api.dart';
import 'package:orginone/api_resp/tree_node.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/base_target.dart';

class Company extends BaseTarget {
  NodeCombine? _tree;

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

  /// 加载组织树形
  loadTree() async {
    _tree ??= await CompanyApi.tree();
  }
}
