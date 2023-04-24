import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

class ClassificationWork extends StatelessWidget {
  final SpeciesItem species;

  const ClassificationWork({Key? key, required this.species})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CommonWidget.commonDocumentWidget(
                title: ["办事名称", "需求主体", "创建时间", "备注"],
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
