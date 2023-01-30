import 'package:get/get.dart';
import 'package:orginone/dart/base/api/company_api.dart';
import 'package:orginone/dart/base/enumeration/target_type.dart';
import 'package:orginone/dart/base/model/tree_node.dart';
import 'package:orginone/dart/core/target/base_target.dart';

class Company extends BaseTarget {
  final Rx<NodeCombine?> _tree = Rxn();

  NodeCombine? get tree => _tree.value;

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
  getTree() async {
    _tree.value ??= await CompanyApi.tree();
  }
}
