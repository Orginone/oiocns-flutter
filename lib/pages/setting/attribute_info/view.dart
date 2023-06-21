import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class AttributeInfoPage
    extends BaseGetView<AttributeInfoController, AttributeInfoState> {

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: "属性定义",
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                List<List<String>> content = [];


                for (var element in state.propertys) {
                  content.add([
                    element.code ?? "",
                    element.name ?? "",
                    element.valueType ?? "",
                    element.unit ?? "",
                    element.directory?.name ?? "",
                    element.createUser??"",
                    element.belong?.name??"",
                    element.remark ?? ""
                  ]);
                }
                return CommonWidget.commonDocumentWidget(
                    title: [
                      '属性代码',
                      "属性名称",
                      "属性定义",
                      "单位",
                      "选择字典",
                      "来源组织",
                      "归属组织",
                      "属性定义"
                    ],
                    content: content,
                    showOperation: true,
                    popupMenus: [
                      const PopupMenuItem(
                        value: "edit",
                        child: Text("编辑属性"),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("删除属性"),
                      ),
                    ],onOperation: (operation,code){
                      controller.onOperation(operation,code);
                });
              }),
            ],
          ),
        ));
  }
}
