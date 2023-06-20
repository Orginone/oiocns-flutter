

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';

class BasicInfo extends StatelessWidget {
  final dynamic data;
  const BasicInfo({Key? key, required this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool isSpecies = data is XSpecies;
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonFormWidget(formItem:[
            CommonWidget.commonFormItem(title: "共享用户",userId: data.shareId??""),
            CommonWidget.commonFormItem(title: "归属用户",userId: data.belongId??""),
            CommonWidget.commonFormItem(title: "创建人",userId: data.createUser??""),
            CommonWidget.commonFormItem(title: "${isSpecies?"分类":"表单"}代码",content: data.code??""),
            isSpecies?CommonWidget.commonFormItem(title: "类型",content: data.typeName):SizedBox(),
            CommonWidget.commonFormItem(title: "创建时间",content: DateTime.tryParse(data.createTime??"")?.format(format: "yyyy-MM-dd HH:mm")??""),
            CommonWidget.commonFormItem(title: "分类定义",content: data.remark??""),
          ]),
        ],
      ),
    );
  }
}
