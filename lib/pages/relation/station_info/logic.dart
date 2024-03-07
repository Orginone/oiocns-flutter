import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StationInfoController extends BaseController<StationInfoState> {
  @override
  // ignore: overridden_fields
  final StationInfoState state = StationInfoState();

  @override
  void onReady() async {
    super.onReady();
    state.identitys.value = await state.station.loadIdentitys(reload: true);
    var users = await state.station.loadMembers(reload: true);
    state.unitMember.addAll(users);
  }

  void removeMember(String data) async {
    var user = state.unitMember.firstWhere((element) => element.code == data);
    bool success = await state.station.removeMembers([user]);
    if (success) {
      state.unitMember.removeWhere((element) => element.code == data);
      state.unitMember.refresh();
    }
  }

  void companyOperation(CompanyFunction function) {
    switch (function) {
      case CompanyFunction.addUser:
        showSearchBottomSheet(context, TargetType.person,
            title: "添加成员",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await state.station.pullMembers(list);
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

  void removeAdmin(String data) async {
    try {
      var user = state.identitys.firstWhere((element) => element.id == data);
      bool success = await state.station.removeIdentitys([user]);
      if (success) {
        state.identitys.remove(user);
      }
    } catch (e) {
      ToastUtils.showMsg(msg: "移除失败");
    }
  }
}
