import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/user_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/toast_utils.dart';

import 'dialog.dart';
import 'state.dart';

class SettingController extends BaseSubmenuController<SettingState> {
  final SettingState state = SettingState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    [
      FrequentlyUsed(
        id: "addPerson",
        name: "加好友",
        avatar:  Ionicons.add,
      ),
      FrequentlyUsed(
        id: "createGroup",
        name: "建群组",
        avatar: Ionicons.create,
      ),
      FrequentlyUsed(
        id: "addGroup",
        name: "加群组",
        avatar: Ionicons.add,
      ),
      FrequentlyUsed(
        id: "createCompany",
        name: "建单位",
        avatar: Ionicons.create,
      ),
      FrequentlyUsed(
        id: "addCompany",
        name: "加单位",
        avatar: Ionicons.add,
      ),
    ];
  }



  @override
  void initSubmenu() {
    // TODO: implement initSubmenu
    super.initSubmenu();
    state.submenu.value = [
      SubmenuType(text: "全部", value: 'all'),
      SubmenuType(text: "常用", value: 'common'),
      SubmenuType(text: "最近", value: 'recent'),
    ];
  }

  @override
  void onTapFrequentlyUsed(used) {
    switch (used.id) {
      case "addPerson":
        showSearchDialog(Get.context!, TargetType.person,
            title: "添加好友",
            hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {
          if (list.isNotEmpty) {
            bool success = await settingCtrl.user.pullMembers(list);
            if (success) {
              ToastUtils.showMsg(msg: "好友申请发送成功");
            } else {
              ToastUtils.showMsg(msg: "好友申请发送失败");
            }
          }
        });
        break;
      case "createGroup":
        settingCtrl.showAddFeatures(
            ItemModel(Shortcut.addCohort, "建群聊", "建群组", TargetType.cohort));
        break;
      case "addGroup":
        settingCtrl.showAddFeatures(ItemModel(
            Shortcut.addGroup, "添加群组", "请输入群组的编码", TargetType.cohort));
        break;
      case "createCompany":
        showCreateOrganizationDialog(
          Get.context!,
          [TargetType.company],
          callBack: (String name, String code, String nickName,
              String identify, String remark, TargetType type) async {
            var target = TargetModel(
              name: nickName,
              code: code,
              typeName: type.label,
              teamName: name,
              teamCode: code,
              remark: remark,
            );
            var company = await settingCtrl.user.createCompany(target);
            if(company!=null){
              ToastUtils.showMsg(msg: "新建成功");
            }
          },
        );
        break;
      case "addCompany":
        settingCtrl.showAddFeatures(ItemModel(
            Shortcut.addCompany, "添加单位", "请输入单位的社会统一代码", TargetType.company));
        break;
    }
  }
}
