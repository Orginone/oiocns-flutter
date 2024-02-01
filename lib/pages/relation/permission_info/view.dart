import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class PermissionInfoPage
    extends BaseGetView<PermissionInfoController, PermissionInfoState> {
  const PermissionInfoPage({super.key});

  @override
  Widget buildView() {
    // setting.space.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));

    return GyScaffold(
      titleName: state.authority.metadata.name,
      body: Column(
        children: [
          CommonWidget.commonHeadInfoWidget("基本信息"),
          CommonWidget.commonFormWidget(formItem: [
            CommonWidget.commonFormItem(
                title: "权限名称", content: state.authority.metadata.name ?? ""),
            CommonWidget.commonFormItem(
                title: "共享组织", userId: state.authority.belongId),

            ///belongId和belong.id
            CommonWidget.commonFormItem(
                title: "权限编码", content: state.authority.metadata.code ?? ""),
            CommonWidget.commonFormItem(
                title: "创建人", userId: state.authority.metadata.createUser!),
            CommonWidget.commonFormItem(
                title: "创建时间",
                content:
                    DateTime.tryParse(state.authority.metadata.createTime!)!
                        .format(format: "yyyy-MM-dd HH:mm")),
            CommonWidget.commonFormItem(
                title: "备注", content: state.authority.metadata.remark ?? ""),
          ])
        ],
      ),
    );
  }
}
