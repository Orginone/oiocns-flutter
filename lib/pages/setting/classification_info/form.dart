import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../dialog.dart';
import 'logic.dart';


class FormPage
    extends BaseGetPageView<
        FormController,
        FormState> {
  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return CommonWidget.commonDocumentWidget(
                  title: ["编号", "名称", "表单类型", "共享用户", "归属用户"],
                  content: state.form.map((e) {
                    return [
                      e.code ?? "",
                      e.name ?? "",
                      e.species ?? "",
                      e.share ?? "",
                      e.belong ?? ""
                    ];
                  }).toList(),
                  showOperation: true,
                  popupMenus: [
                    const PopupMenuItem(child: Text("编辑"), value: "edit",),
                    const PopupMenuItem(child: Text("删除"), value: "delete",),
                  ],
                  onOperation: (operation, code) {
                    controller.onFormOperation(operation, code);
                  });
            }),
          ],
        ),
      ),
    );
  }

  @override
  FormController getController() {
    return FormController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'form';
  }
}


class FormController
    extends BaseController<FormState> {
  final FormState state = FormState();

  ClassificationInfoController get info => Get.find();

  dynamic get species =>info.state.species;
  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadForm();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadForm({bool reload = false}) async {
    state.form.value = await species.loadForms(reload: reload);
  }


  Future<void> createForm({XForm? form}) async {
    showCreateFormDialog(context,
        code: form?.code ?? "",
        name: form?.name ?? "",
        public: form?.public ?? true,
        isEdit: form != null,
        onCreate: (name, code, public) async {
          var model = FormModel();
          model.speciesId = species.metadata.id;
          model.name = name;
          model.code = code;
          if (form != null) {
            await species.updateForm(model);
          } else {
            await species.createForm(model);
          }
          loadForm(reload: true);
        });
  }


  void onFormOperation(operation, String code) async {
    try {
      var op = state.form.firstWhere((element) => element.code == code);
      if (operation == "delete") {
        var success = await await species.deleteForm(op);
        if (success) {
          state.form.remove(op);
          state.form.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        }
      } else if (operation == 'edit') {
        await createForm(form: op);
      }
    } catch (e) {}
  }
}


class FormState extends BaseGetState {
  var form = <XForm>[].obs;
}