import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';

class BasicInfo extends StatelessWidget {
  final XEntity data;
  const BasicInfo({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonFormWidget(formItem: [
            CommonWidget.commonFormItem(title: "名称", content: data.name ?? ""),
            CommonWidget.commonFormItem(title: "代码", content: data.code ?? ""),
            CommonWidget.commonFormItem(
                title: "归属", userId: data.belongId ?? ""),
            CommonWidget.commonFormItem(
                title: "创建人", userId: data.createUser ?? ""),
            CommonWidget.commonFormItem(
                title: "创建时间",
                content: DateTime.tryParse(data.createTime ?? "")
                        ?.format(format: "yyyy-MM-dd HH:mm") ??
                    ""),
            CommonWidget.commonFormItem(
                title: "描述信息", content: data.remark ?? ""),
          ]),
        ],
      ),
    );
  }
}
