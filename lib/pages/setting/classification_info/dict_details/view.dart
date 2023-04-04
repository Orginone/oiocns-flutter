import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class DictDetailsPage
    extends BaseGetView<DictDetailsController, DictDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.dict.name,
      actions: [
        IconButton(
            onPressed: () {
              controller.createDictItem();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 36.w,
            ))
      ],
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Obx(() {
            List<List<String>> content = [];
            for (var value in state.dictItem) {
              content.add([
                value.name,
                value.value,
                findTargetShare(value.belongId).name,
                DateTime.tryParse(value.createTime ?? "")!
                    .format(format: "yyyy-MM-dd HH:mm")
              ]);
            }
            return CommonWidget.commonDocumentWidget(
                title: ["名称", "值", "共享组织", "创建时间"], content: content);
          }),
        ],
      ),
    );
  }
}
