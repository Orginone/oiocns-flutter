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
import 'package:orginone/dart/core/thing/store/propclass.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../dialog.dart';
import 'logic.dart';


class FormPage
    extends BaseGetPageView<
        FormController,
        FormState> {

  final List<XProperty> propertys;

  final IPropClass propClass;

  FormPage(this.propertys, this.propClass);

  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return CommonWidget.commonDocumentWidget(
                  title: ["表单名称", "表单编号", "特性名称", "特性定义"],
                  content: state.form.map((e) {
                    return [
                      e.form?.name??"",
                      e.code??"" ,
                      e.name??"" ,
                      e.remark??"",
                    ];
                  }).toList(),
                 );
            }),
          ],
        ),
      ),
    );
  }

  @override
  FormController getController() {
    return FormController(this.propertys,this.propClass);
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


  final List<XProperty> propertys;

  final IPropClass propClass;

  FormController(this.propertys, this.propClass);

  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadForm();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadForm({bool reload = false}) async {
     state.form.clear();
     for (var data in propertys) {
       var value = await propClass.loadPropAttributes(data);
       state.form.addAll(value);
     }
  }


  // Future<void> createForm({XForm? form}) async {
  //   showCreateFormDialog(context,
  //       code: form?.code ?? "",
  //       name: form?.name ?? "",
  //       isEdit: form != null,
  //       onCreate: (name, code, public) async {
  //         var model = FormModel();
  //         model.speciesId = species.metadata.id;
  //         model.name = name;
  //         model.code = code;
  //         if (form != null) {
  //           await species.updateForm(model);
  //         } else {
  //           await species.createForm(model);
  //         }
  //         loadForm(reload: true);
  //       });
  // }
  //
  //
  // void onFormOperation(operation, String code) async {
  //   try {
  //     var op = state.form.firstWhere((element) => element.code == code);
  //     if (operation == "delete") {
  //       var success = await await species.deleteForm(op);
  //       if (success) {
  //         state.form.remove(op);
  //         state.form.refresh();
  //         ToastUtils.showMsg(msg: "删除成功");
  //       }
  //     } else if (operation == 'edit') {
  //       await createForm(form: op);
  //     }
  //   } catch (e) {}
  // }
}


class FormState extends BaseGetState {
  var form = <XAttribute>[].obs;
}