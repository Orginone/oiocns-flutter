import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';

class ClassificationAttrs extends StatelessWidget {
  final List<XAttribute> attrs;

  const ClassificationAttrs({Key? key, required this.attrs})
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
                title: ["特性编号", "特性名称", "特性分类", "属性", "共享组织", "特性定义"],
                content: attrs.map((e){
                  return [e.code??"",e.name??"",info.state.species.name,e.property?.name??"",info.state.data.space.teamName,e.remark??""];
                }).toList(),showOperation: true,popupMenus: [
              const PopupMenuItem(child: Text("关联属性"),value: "relation",),
              const PopupMenuItem(child: Text("复制属性"),value: "copy",),
            ],onOperation: (operation,code){
                  info.onDocumentOperation(operation,code);
            }),
          ],
        ),
      ),
    );
  }
}
