import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class DictInfoPage extends BaseGetView<DictInfoController, DictInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.data.name,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonWidget.commonHeadInfoWidget("字典"),
            CommonWidget.commonFormWidget(formItem: [
              CommonWidget.commonFormItem(
                  title: "字典名称",
                  content: state.data.source.metadata.name ?? ""),
              CommonWidget.commonFormItem(
                  title: "字典代码",
                  content: state.data.source.metadata.code ?? ""),
              CommonWidget.commonFormItem(
                  title: "备注",
                  content: state.data.source.metadata.remark ?? ""),
            ]),
            CommonWidget.commonHeadInfoWidget(
              "字典",
              action: CommonWidget.commonPopupMenuButton(
                  items: const [
                    PopupMenuItem(
                      value: "create",
                      child: Text("新增字典项"),
                    ),
                  ],
                  onSelected: (operation) {
                    controller.onCreate();
                  },
                  color: Colors.transparent),
            ),
            Obx(() {
              List<List<String>> content = [];

              for (var element in state.dictItems) {
                content.add([
                  element.name,
                  element.value,
                  DateTime.tryParse(element.createTime)
                          ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                      ""
                ]);
              }
              return CommonWidget.commonDocumentWidget(
                  title: ['名称', '值', '创建时间'],
                  content: content,
                  showOperation: true,
                  popupMenus: [
                    const PopupMenuItem(
                      value: "edit",
                      child: Text("编辑字典项"),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Text("删除字典项"),
                    ),
                  ],
                  onOperation: (operation, key) {
                    controller.onOperation(operation, key);
                  });
            })
          ],
        ),
      ),
    );
  }
}
