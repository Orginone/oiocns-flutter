import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/classification_info/logic.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

class ClassificationForm extends StatelessWidget {
  final List<XOperation> operation;

  const ClassificationForm({Key? key, required this.operation})
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
                title: ["业务编号", "业务名称", "特性分类", "共享组织"],
                content: operation.map((e){

                  String? name = getSpeciesName(e.speciesId??"",info.state.data.space.species);

                  return [e.code??"",e.name??"",name??"",info.state.species.name];
                }).toList(),showOperation: true,popupMenus: [
              const PopupMenuItem(child: Text("编辑"),value: "edit",),
              const PopupMenuItem(child: Text("删除"),value: "delete",),
            ],onOperation: (operation,code){
                  info.onFormOperation(operation,code);
            }),
          ],
        ),
      ),
    );
  }

  String? getSpeciesName(String id,List<ISpeciesItem> species){
    for (var value in species) {
      if(value.id == id){
        return value.name;
      }
      var find = getSpeciesName(id, value.children);
      if (find != null) {
        return find;
      }
    }
    return null;
  }
}
