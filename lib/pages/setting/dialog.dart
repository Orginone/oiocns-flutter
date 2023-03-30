import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';

typedef IdentityChangeCallBack = Function(
    String name, String code, String remark);

Future<void> showEditIdentityDialog(IIdentity identity, BuildContext context,
    {IdentityChangeCallBack? callBack}) async {
  TextEditingController name = TextEditingController(text: identity.name);
  TextEditingController code =
      TextEditingController(text: identity.target.code);
  TextEditingController remark =
      TextEditingController(text: identity.target.remark);
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonWidget.commonHeadInfoWidget("编辑"),
                  CommonWidget.commonTextTile("角色名称", '',
                      controller: name, showLine: true, required: true),
                  CommonWidget.commonTextTile("角色编号", '',
                      controller: code, showLine: true, required: true),
                  CommonWidget.commonTextTile("角色简介", '',
                      controller: remark, showLine: true),
                  CommonWidget.commonMultipleSubmitWidget(onTap1: () {
                    Navigator.pop(context);
                  }, onTap2: () {
                    if (name.text.isEmpty) {
                      ToastUtils.showMsg(msg: "请输入角色名称");
                    } else if (code.text.isEmpty) {
                      ToastUtils.showMsg(msg: "请输入角色编号");
                    } else {
                      if (callBack != null) {
                        callBack(name.text, code.text, remark.text);
                      }
                      Navigator.pop(context);
                    }
                  }),
                ],
              ),
            );
          }));
    },
  );
}

Future<void> showSelectMemberDialog(BuildContext context,
    {ValueChanged<List<String>>? onChange}) async {
  SettingController setting = Get.find();
  var users = await setting.space
      .loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));

  List<List<String>> docContent = [];

  var data = users.result ?? [];

  for (var user in data) {
    docContent.add([
      user.code,
      user.name,
      user.team?.name ?? "",
      user.team?.code ?? "",
      user.team?.remark ?? "",
    ]);
  }


}
