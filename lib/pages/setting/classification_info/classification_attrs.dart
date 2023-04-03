import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

class ClassificationAttrs extends StatelessWidget {
  final SpeciesItem species;

  const ClassificationAttrs({Key? key, required this.species})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonDocumentWidget(
              title: ["特性编号", "特性名称", "特性分类", "特性类型", "选择字典", "共享组织", "特性定义"],
              content: species.attrs.map((e){
                String speciesName = '';
                try{
                  speciesName = CommonTreeManagement().species?.getAllList().firstWhere((element) => element.id == e.speciesId).name??"";
                }catch(e){
                  speciesName = '';
                }
                return [e.code??"",e.name??"",speciesName,e.valueType??"",e.dict?.name??"",species.name,e.remark??""];
              }).toList()),
        ],
      ),
    );
  }
}
