import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

SettingController get setting => Get.find();

class PermissionInfoPage extends BaseGetView<PermissionInfoController,PermissionInfoState>{
  @override
  Widget buildView() {
    setting.space.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));

    return GyScaffold(
      titleName: state.authority.name,
      body: Column(
        children: [
          CommonWidget.commonHeadInfoWidget("基本信息"),
          CommonWidget.commonFormWidget(formItem:[
            CommonWidget.commonFormItem(title: "权限名称",content: state.authority.name),
            CommonWidget.commonFormItem(title: "共享组织",content: findTargetShare(state.authority.belongId).name),
            CommonWidget.commonFormItem(title: "权限编码",content: state.authority.code),
            CommonWidget.commonFormItem(title: "创建人",content: findTargetShare(state.authority.createUser).name),
            CommonWidget.commonFormItem(title: "创建时间",content: DateTime.tryParse(state.authority.createTime)!.format(format: "yyyy-MM-dd HH:mm")),
            CommonWidget.commonFormItem(title: "备注",content: state.authority.remark),
          ])
        ],
      ),
    );
  }
}
