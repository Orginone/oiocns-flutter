import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/form/form_widget/main_form/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/utils/index.dart';

// ignore: must_be_immutable
class FormDetailPage extends OrginoneStatefulWidget {
  FormDetailPage({super.key, super.data});

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends OrginoneStatefulState<FormDetailPage> {
  // 主视图
  Widget _buildView(XForm xForm, int infoIndex) {
    if (xForm == null) {
      return Container();
    }
    return SingleChildScrollView(
        child: MainFormPage(
      [xForm],
      infoIndex: infoIndex,
    ));
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    LogUtil.d(Get.arguments);
    return _buildView(data, Get.arguments.datas['infoIndex'] ?? 0);
  }
}
