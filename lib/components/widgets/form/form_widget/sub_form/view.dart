import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/form/form_widget/index.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/dart/base/model.dart';

import 'package:orginone/dart/base/schema.dart';

import 'index.dart';

class SubFormPage extends GetView<SubFormController> {
  const SubFormPage(this.forms, {Key? key}) : super(key: key);
  final List<XForm> forms;
  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildHeaderView(),
      _buildFormView(),
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
          .height(18)
          .width(4)
          .paddingLeft(10)
          .paddingRight(5)
          .paddingTop(4),
      TextWidget.title3(form.name ?? ''),
    ].toRow(
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  _buildFormView() {
    if (forms.isEmpty || forms.first.data!.after.isEmpty) {
      return Container();
    }

    return ListView.builder(
      itemCount: forms.first.data?.after.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        AnyThingModel thingModel = forms.first.data!.after[index];

        return _buildSubFormItem(thingModel, index);
      },
    );
  }

  _buildSubFormItem(AnyThingModel thingModel, int index) {
    return <Widget>[
      ..._buildField(forms.first, index),
      ButtonWidget.iconText(
        IconWidget.icon(
          Icons.call_made,
          color: AppColors.blue,
          size: 16,
        ),
        '查看详情',
        textColor: AppColors.blue,
        onTap: () => controller.toDetail(forms.first, index),
      )
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingOnly(left: 10, right: 10, top: 10)
        .backgroundColor(AppColors.lightPrimary) //
        .marginSymmetric(horizontal: 10, vertical: 10)
        .borderRadius(all: 10)
        .clipRRect(all: 10, topLeft: 10);
  }

  _buildField(XForm form, int index) {
    if (forms.isEmpty) {
      return Container();
    }
    XForm? form = forms.first;
    List<FieldModel> fileds = form.fields;
    // FieldModel fieldModel = fileds[index];
    Map<String, dynamic> info = {};
    if (forms.first.data?.after.isNotEmpty ?? false) {
      info = forms.first.data!.after[index].otherInfo;
    }
    // LogUtil.e('_buildField-info');
    // LogUtil.e(info);
    fileds = (fileds.isNotEmpty && fileds.length > 5)
        ? fileds.sublist(0, 5)
        : fileds;
    List<Widget> ws = [];
    for (var i = 0; i < fileds.length; i++) {
      FieldModel fieldModel = fileds[i];
      var w = FutureBuilder<List<List<String>>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return Container();
          }
          var content = snapshot.data![index][i];

          Widget row = <Widget>[
            Text('${fieldModel.name}:  '),
            Text(content),
          ].toRow();

          return row;
        },
        future: FormTool.loadSubFieldData(form, form.fields),
      );
      ws.add(w);
    }
    return ws;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubFormController>(
      init: SubFormController(),
      id: "sub_form",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
