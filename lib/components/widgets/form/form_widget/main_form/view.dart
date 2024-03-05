import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common/others/mapping_components.dart';
import 'package:orginone/components/widgets/form/form_widget/index.dart';
import 'package:orginone/config/colors.dart';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main_base.dart';

import 'index.dart';

class MainFormPage extends GetView<MainFormController> {
  const MainFormPage(this.forms, {Key? key, this.infoIndex}) : super(key: key);
  final List<XForm> forms;
  final int? infoIndex; //表单info需要展示第几个
  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildHeaderView(),
      _buildMainFormView(),
    ].toColumn();
  }

  _buildHeaderView() {
    if (forms.isEmpty) {
      return Container();
    }
    XForm form = forms[0];
    return <Widget>[
      Container()
          .backgroundColor(AppColors.blue)
          .width(4)
          .paddingLeft(10)
          .height(16)
          .paddingRight(5),
      // .paddingTop(4),
      TextWidget.title3(form.name ?? '').paddingBottom(2),
    ]
        .toRow(
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .backgroundColor(AppColors.white)
        .height(30);
    // .paddingTop(15);
  }

  _buildMainFormView() {
    List<FieldModel> fileds = forms.isNotEmpty ? forms.first.fields : [];

    return ListView.builder(
      itemCount: fileds.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        FieldModel fieldModel = fileds[index];
        Map<String, dynamic> info = {};
        if (forms.first.data?.after.isNotEmpty ?? false) {
          info = forms.first.data!.after[infoIndex ?? 0].otherInfo;
        }
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done &&
                !snapshot.hasData) {
              return Container();
            }
            Widget child = mappingComponents[fieldModel.field.type ?? ""]!(
                fieldModel.field, relationCtrl.user!);
            return child;
          },
          future: FormTool.loadMainFieldData(fieldModel, info),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainFormController>(
      init: MainFormController(),
      id: "main_form",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
