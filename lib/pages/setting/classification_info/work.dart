import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
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
                  content: state.flow.map((e) {
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

class WorkController
    extends BaseController<WorkState> {
  final WorkState state = WorkState();

  ClassificationInfoController get info => Get.find();

  dynamic get species => info.state.species;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadFlow();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadFlow({bool reload = false}) async {
    state.flow.value = await species.loadWorkDefines(reload: reload);
  }

  void onWorkOperation(operation, String name) async {
    try {
      var flow = state.flow.firstWhere((element) => element.metadata.name == name);
      if (operation == "delete") {
        var success = await species.delete();
        if (success) {
          state.flow.remove(flow);
          state.flow.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        }
      } else if (operation == 'edit') {
        createWork(flow: flow);
      }
    } catch (e) {}
  }

  Future<void> createWork({IWorkDefine? flow}) async {
    showCreateWorkDialog(context, info.state.data.space!.species,
        isEdit: flow != null,
        name: flow?.metadata.name ?? "",
        remark: flow?.metadata.remark ?? "",
        create: flow?.metadata.isCreate ?? false,
        code: flow?.metadata.code??'',
        onCreate: (name, code,remark, isCreate) async {
      var model = WorkDefineModel();
      model.remark = remark;
      model.name = name;
      model.code = code;
      model.isCreate = isCreate;
      if(flow!=null){
        await flow.updateDefine(model);
      }else{
        await species.createWorkDefine(model);
      }
      await loadFlow(reload: true);
    });
  }
}

class WorkState extends BaseGetState {
  var flow = <IWorkDefine>[].obs;
}
