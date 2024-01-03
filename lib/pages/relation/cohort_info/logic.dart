import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CohortInfoController extends BaseController<CohortInfoState> {
  @override
  final CohortInfoState state = CohortInfoState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await init();
  }

  Future<void> init() async {
    var users = await state.cohort.loadMembers();
    state.unitMember.clear();
    state.unitMember.addAll(users);
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.roleSettings:
        Get.toNamed(Routers.roleSettings, arguments: {"target": state.cohort});
        break;
      case CompanyFunction.addUser:
        showSearchDialog(context, TargetType.company,
            title: "添加成员",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await state.cohort.pullMembers(list);
            if (success) {
              ToastUtils.showMsg(msg: "添加成功");
            } else {
              ToastUtils.showMsg(msg: "添加失败");
            }
          }
        });
        break;

      default:
    }
  }

  void removeMember(String data) async {
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await state.cohort.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }
  }
}
