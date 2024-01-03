import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/pages/relation/role_settings/logic.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class IdentityInfoController extends BaseController<IdentityInfoState> {
  @override
  final IdentityInfoState state = IdentityInfoState();
  late Rx<IIdentity> identity;

  RoleSettingsController get roleSetting => Get.find<RoleSettingsController>();

  IdentityInfoController(this.identity);

  @override
  void onReady() async {
    super.onReady();
    await loadMembers();
  }

  Future<void> loadMembers() async {
    var users = await identity.value.loadMembers();
    state.unitMember.clear();
    state.unitMember.addAll(users);
  }

  void removeRole(String code) async {
    try {
      var user = state.unitMember.firstWhere((element) => element.code == code);
      bool success = await identity.value.removeMembers([user]);
      if (success) {
        state.unitMember.removeWhere((element) => element.code == code);
        state.unitMember.refresh();
      }
    } catch (e) {
      ToastUtils.showMsg(msg: e.toString() + code);
    }
  }

  void identityOperation(IdentityFunction function) {
    switch (function) {
      case IdentityFunction.edit:
        showCreateIdentityDialog(context, [],
            onCreate: (name, code, authId, remark) async {
          try {
            bool success = await identity.value
                .update(IdentityModel(name: name, code: code, remark: remark));
            if (success) {
              identity.value.metadata.name = name;
              identity.value.metadata.code = code;
              identity.value.metadata.remark = remark;
              identity.refresh();
            } else {
              ToastUtils.showMsg(msg: "修改失败");
            }
          } catch (e) {
            ToastUtils.showMsg(msg: e.toString());
          }
        }, identity: identity.value);
        break;
      case IdentityFunction.delete:
        roleSetting.deleteIdentity(identity.value);
        break;
      case IdentityFunction.addMember:
        showSearchDialog(context, TargetType.person,
            title: "添加成员",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await roleSetting.state.target.pullMembers(list);
            if (success) {
              ToastUtils.showMsg(msg: "添加成功");
            } else {
              ToastUtils.showMsg(msg: "添加失败");
            }
          }
        });
        break;
    }
  }
}
