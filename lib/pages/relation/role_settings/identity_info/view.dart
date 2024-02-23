import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/common/data_config/relation_config.dart';
import 'package:orginone/pages/relation/widgets/document.dart';
import 'package:orginone/utils/date_utils.dart';

import 'logic.dart';
import 'state.dart';

class IdentityInfoPage
    extends BaseGetPageView<IdentityInfoController, IdentityInfoState> {
  late Rx<IIdentity> identity;

  IdentityInfoPage(IIdentity identity, {super.key}) {
    this.identity = Rx(identity);
  }

  @override
  Widget buildView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          identityInfo(),
          body(),
        ],
      ),
    );
  }

  Widget identityInfo() {
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget(
          "角色信息",
          action: CommonWidget.commonPopupMenuButton(
              items: const [
                PopupMenuItem(
                  value: IdentityFunction.edit,
                  child: Text("编辑"),
                ),
                PopupMenuItem(
                  value: IdentityFunction.delete,
                  child: Text("删除"),
                ),
              ],
              onSelected: (IdentityFunction function) {
                controller.identityOperation(function);
              },
              color: Colors.transparent),
        ),
        Obx(() {
          return CommonWidget.commonFormWidget(formItem: [
            CommonWidget.commonFormItem(
                title: "名称", content: identity.value.metadata.name ?? ""),
            CommonWidget.commonFormItem(
                title: "编码", content: identity.value.metadata.code ?? ""),
            CommonWidget.commonFormItem(
                title: "创建人", userId: identity.value.metadata.createUser ?? ""),
            CommonWidget.commonFormItem(
                title: "创建时间",
                content:
                    DateTime.tryParse(identity.value.metadata.createTime ?? "")!
                        .format()),
            CommonWidget.commonFormItem(
                title: "描述", content: identity.value.metadata.remark ?? ""),
          ]);
        })
      ],
    );
  }

  Widget body() {
    return Column(
      children: [
        Obx(() {
          return CommonWidget.commonHeadInfoWidget(
              identity.value.metadata.name ?? "",
              action: CommonWidget.commonPopupMenuButton(
                  items: const [
                    PopupMenuItem(
                      value: IdentityFunction.addMember,
                      child: Text("添加成员"),
                    ),
                  ],
                  onSelected: (IdentityFunction function) {
                    controller.identityOperation(function);
                  },
                  color: Colors.transparent));
        }),
        Obx(() {
          return UserDocument(
            popupMenus: const [
              PopupMenuItem(value: 'out', child: Text("移除")),
            ],
            onOperation: (type, data) {
              controller.removeRole(data);
            },
            unitMember: state.unitMember.value,
          );
        }),
      ],
    );
  }

  @override
  IdentityInfoController getController() {
    return IdentityInfoController(identity);
  }

  @override
  String tag() {
    //
    return "IdentityInfo_${identity.value.metadata.name}";
  }
}
