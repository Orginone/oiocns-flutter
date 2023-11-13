import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';

class PersonInfo extends StatelessWidget {
  final XTarget data;
  const PersonInfo({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonFormWidget(formItem: [
            CommonWidget.commonFormItem(title: "名称", content: data.name ?? ""),
            CommonWidget.commonFormItem(
                title: "类型", content: data.typeName ?? ""),
            CommonWidget.commonFormItem(title: "代码", content: data.code ?? ""),
            CommonWidget.commonFormItem(title: "简称", content: data.name ?? ""),
            CommonWidget.commonFormItem(title: "标识", content: data.code ?? ""),
            CommonWidget.commonFormItem(
                title: "创建时间",
                content: DateTime.tryParse(data.createTime ?? "")
                        ?.format(format: "yyyy-MM-dd HH:mm") ??
                    ""),
            CommonWidget.commonFormItem(
                title: "更新时间",
                content: DateTime.tryParse(data.updateTime ?? "")
                        ?.format(format: "yyyy-MM-dd HH:mm") ??
                    ""),
            CommonWidget.commonFormItem(
                title: "简介", content: data.remark ?? ""),
          ]),
        ],
      ),
    );
  }
}
