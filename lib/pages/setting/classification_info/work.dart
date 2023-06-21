import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'logic.dart';

class WorkPage extends BaseGetPageView<
    WorkController, WorkState> {
  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              CommonWidget.commonDocumentWidget(
                  title: ["办事名称", "办事标识", "创建时间", "备注"],
                  content: state.work.map((e) {
                    return [
                      e.metadata.name ?? "",
                      e.metadata.code ?? "",
                      DateTime.tryParse(e.metadata.createTime ?? "")
                          ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                          "",
                      e.metadata.remark ?? ""
                    ];
                  }).toList(),
                  showOperation: true,
                  popupMenus: [
                    const PopupMenuItem(
                      value: "edit",
                      child: Text("编辑"),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Text("删除"),
                    ),
                  ],
                  onOperation: (operation, name) {
                    controller.onWorkOperation(operation, name);
                  }),
            ],
          );
        }),
      ),
    );
    ;
  }

  @override
  WorkController getController() {
    return WorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "work";
  }
}

class WorkController extends BaseController<WorkState> {
  final WorkState state = WorkState();

  ClassificationInfoController get info => Get.find();

  IApplication get species => info.state.species;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadWork();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadWork({bool reload = false}) async {
    state.work.value = await species.loadWorks(reload: reload);
  }

  void onWorkOperation(operation, String name) async {
    try {
      var work = state.work.firstWhere((element) => element.metadata.name == name);
      if (operation == "delete") {
        var success = await species.delete();
        if (success) {
          state.work.remove(work);
          state.work.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        }
      } else if (operation == 'edit') {
        createWork(work: work);
      }
    } catch (e) {}
  }

  Future<void> createWork({IWork? work}) async {
    showCreateWorkDialog(context, info.state.data.space!.directory.specieses,
        isEdit: work != null,
        share: species.directory.target.space.shareTarget,
        name: work?.metadata.name ?? "",
        remark: work?.metadata.remark ?? "",
        allowAdd: work?.metadata.allowAdd ?? true,
        allowEdit: work?.metadata.allowEdit ?? true,
        allowSelect: work?.metadata.allowSelect ?? true,
        code: work?.metadata.code ?? '',
        onCreate: (name, code, remark, allowAdd, allowEdit, allowSelect,share) async {
      var model = WorkDefineModel();
      model.remark = remark;
      model.name = name;
      model.code = code;
      model.shareId = share.id;
      model.rule = jsonEncode({
        "allowAdd": allowAdd,
        "allowEdit": allowEdit,
        "allowSelect": allowSelect
      });
      if (work != null) {
        await work.updateDefine(model);
      } else {
        await species.createWork(model);
      }
      await loadWork(reload: true);
    });
  }
}

class WorkState extends BaseGetState {
  var work = <IWork>[].obs;
}
