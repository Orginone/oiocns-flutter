import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';

class ClassificationWork extends StatelessWidget {
  final List<XFlowDefine> flow;

  const ClassificationWork({Key? key, required this.flow})
      : super(key: key);

  ClassificationInfoController get info => Get.find();
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CommonWidget.commonDocumentWidget(
                title: ["办事名称", "需求主体", "创建时间", "备注"],
                content: flow.map((e){
                  return [e.name??"",info.state.data.space.teamName,DateTime.tryParse(e.createTime??"")?.format(format: "yyyy-MM-dd HH:mm:ss")??"",e.remark??""];
                }).toList(),showOperation: true,popupMenus: [
                  const PopupMenuItem(child: Text("编辑"),value: "edit",),
              const PopupMenuItem(child: Text("删除"),value: "delete",),
            ],onOperation: (operation,name){
              info.onWorkOperation(operation,name);
            }),
          ],
        ),
      ),
    );
  }
}
