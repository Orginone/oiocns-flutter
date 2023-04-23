import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

class ClassificationForm extends StatelessWidget {
  final SpeciesItem species;

  const ClassificationForm({Key? key, required this.species})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CommonWidget.commonDocumentWidget(
                title: ["业务编号", "业务名称", "特性分类", "共享组织"],
                content: species.attrs.map((e){
                  String speciesName = '';
                  try{
                    speciesName = CommonTreeManagement().species?.getAllList().firstWhere((element) => element.id == e.speciesId).name??"";
                  }catch(e){
                    speciesName = '';
                  }
                  return [e.code??"",e.name??"",speciesName,species.name];
                }).toList()),
          ],
        ),
      ),
    );
  }
}
