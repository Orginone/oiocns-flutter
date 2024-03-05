import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/extension/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/components/widgets/form/form_widget/index.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/config/space.dart';

import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/work/widgets/approve_widget.dart';

import 'logic.dart';
import 'state.dart';

///基本信息 页面
class ProcessInfoPage
    extends BaseGetPageView<ProcessInfoController, ProcessInfoState> {
  ProcessInfoPage({super.key});
  TextEditingController comment = TextEditingController();
  @override
  Widget buildView() {
    return _mainView();
  }

  Column _mainView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormWidget(
                  mainForm: state.mainForm,
                  subForm: state.subForm,
                ),
                // _mainTable(),
                // _subTable(),
                SizedBox(
                  height: 10.h,
                ),
                _opinion()
              ],
            ),
          ),
        ),
        ApproveWidget(
          todo: state.todo,
          comment: comment,
        ),
      ],
    );
  }

  Widget _opinion() {
    if (state.todo?.metadata.status != 1) {
      return Container();
    }
    return CommonWidget.commonTextTile(
      "备注",
      "",
      required: true,
      backgroundColor: AppColors.bgColor,
      controller: comment,
      hint: "请填写备注信息",
      maxLine: 4,
    ).paddingTop(AppSpace.listItem).paddingHorizontal(AppSpace.page);
  }
  // Column _mainViewOld() {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const FormWidget(),
  //               _mainTable(),
  //               _subTable(),
  //               SizedBox(
  //                 height: 10.h,
  //               ),
  //               ApproveWidget(todo: state.todo),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _mainTable() {
    return Obx(() {
      if (state.mainForm.isEmpty) {
        return const SizedBox();
      }
      LogUtil.d('AAAAAAAAAAA${jsonEncode(state.mainForm)}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidget.commonNonIndicatorTabBar(state.mainTabController,
              state.mainForm.map((element) => element.name ?? '').toList(),
              onTap: (index) {
            controller.changeMainIndex(index);
          }, labelStyle: TextStyle(fontSize: 21.sp)),
          _buildMainFormView(),
        ],
      );
    });
  }

  _buildMainFormView() {
    List<Widget> fileds =
        state.mainForm[state.mainIndex.value].fields.map((element) {
      Map<String, dynamic> info = {};
      if (state.mainForm[state.mainIndex.value].data?.after.isNotEmpty ??
          false) {
        info = state.mainForm[state.mainIndex.value].data!.after[0].otherInfo;
      }
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return Container();
          }
          Widget child = null != relationCtrl.user
              ? mappingComponents[element.field.type ?? ""]!(
                  element.field, relationCtrl.user!)
              : Container();
          return child;
        },
        future: controller.loadMainFieldData(element, info),
      );
    }).toList();

    return Column(
      children: fileds,
    );
  }

  Widget _subTable() {
    return Obx(() {
      if (state.subForm.isEmpty) {
        return const SizedBox();
      }
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            CommonWidget.commonNonIndicatorTabBar(state.subTabController,
                state.subForm.map((element) => element.name ?? '').toList(),
                onTap: (index) {
              controller.changeSubIndex(index);
            }, labelStyle: TextStyle(fontSize: 21.sp)),
            _buildSubFormView(),
          ],
        ),
      );
    });
  }

  _buildSubFormView() {
    return Obx(() {
      var sub = state.subForm[state.subIndex.value];
      List<String> title = sub.fields.map((e) => e.name ?? "").toList() ?? [];
      return FutureBuilder<List<List<String>>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CommonWidget.commonDocumentWidget(
              title: ["唯一标识", "创建者", "状态", ...title],
              content: snapshot.data ?? [],
            );
          }
          return Container();
        },
        future: controller.loadSubFieldData(sub, sub.fields),
      );
    });
  }

  @override
  ProcessInfoController getController() {
    return ProcessInfoController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "ProcessInfo";
  }
}
