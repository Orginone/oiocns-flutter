

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';

class ClassificationBasicInfo extends StatelessWidget {
  final  SpeciesItem species;
  const ClassificationBasicInfo({Key? key, required this.species}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingController  setting = Get.find();
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonFormWidget(formItem:[
            CommonWidget.commonFormItem(title: "共享组织",content: species.belongInfo.name),
            CommonWidget.commonFormItem(title: "分类编码",content: species.target.code),
            CommonWidget.commonFormItem(title: "开放域",content: species.target.public?"开放":"私有"),
            CommonWidget.commonFormItem(title: "创建人",content: setting.findTargetShare(species.target.createUser)),
            CommonWidget.commonFormItem(title: "创建时间",content: DateTime.tryParse(species.target.createTime)!.format(format: "yyyy-MM-dd HH:mm")),
            CommonWidget.commonFormItem(title: "备注",content: species.target.remark),
          ]),
        ],
      ),
    );
  }
}
