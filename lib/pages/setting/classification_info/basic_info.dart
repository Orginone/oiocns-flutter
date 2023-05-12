

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';

class BasicInfo extends StatelessWidget {
  final  SpeciesItem species;
  const BasicInfo({Key? key, required this.species}) : super(key: key);

  SettingController get setting => Get.find();

  @override
  Widget build(BuildContext context) {
    SettingController  setting = Get.find();
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonFormWidget(formItem:[
            CommonWidget.commonFormItem(title: "共享用户",userId: species.metadata.shareId),
            CommonWidget.commonFormItem(title: "归属用户",userId: species.metadata.belongId),
            CommonWidget.commonFormItem(title: "创建人",userId: species.metadata.createUser),
            CommonWidget.commonFormItem(title: "分类代码",content: species.metadata.code),
            CommonWidget.commonFormItem(title: "类型",content: species.metadata.typeName),
            CommonWidget.commonFormItem(title: "创建时间",content: DateTime.tryParse(species.metadata.createTime??"")?.format(format: "yyyy-MM-dd HH:mm")??""),
            CommonWidget.commonFormItem(title: "分类定义",content: species.metadata.remark),
          ]),
        ],
      ),
    );
  }
}
