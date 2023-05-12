import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CohortInfoController extends BaseController<CohortInfoState> {
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
        Get.toNamed(Routers.addMembers, arguments: {"title": "指派角色"})
            ?.then((value) async {
          var selected = (value as List<XTarget>);
          if (selected.isNotEmpty) {
            bool success = await state.cohort.pullMembers(selected);
            if (success) {
              await init();
            }
          }
        });
        break;
    }
  }

  void removeMember(String data) async{
    var user = state.unitMember
        .firstWhere((element) => element.code == data);
    bool success = await state.cohort.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }
  }
}
