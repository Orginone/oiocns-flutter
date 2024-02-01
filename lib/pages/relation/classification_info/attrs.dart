import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/utils/toast_utils.dart';

import 'logic.dart';

class AttrsPage extends BaseGetPageView<AttrsController, AttrsState> {
  AttrsPage({super.key});

  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return CommonWidget.commonDocumentWidget(
                  title: ["特性编号", "特性名称", "特性分类", "属性", "共享组织", "特性定义"],
                  content: state.attrs.map((e) {
                    return [
                      e.code ?? "",
                      e.name ?? "",
                      controller.species.metadata.name!.toString(),
                      e.property?.name ?? "",
                      controller.info.state.data.space!.metadata.name!,
                      e.remark ?? ""
                    ];
                  }).toList(),
                  showOperation: true,
                  popupMenus: [
                    const PopupMenuItem(
                      value: "delete",
                      child: Text("删除"),
                    ),
                  ],
                  onOperation: (operation, code) {
                    controller.onAttrOperation(operation, code);
                  });
            }),
          ],
        ),
      ),
    );
  }

  @override
  AttrsController getController() {
    return AttrsController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "attr";
  }
}

class AttrsController extends BaseController<AttrsState> {
  @override
  final AttrsState state = AttrsState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadAttrs();
    LoadingDialog.dismiss(context);
  }

  ClassificationInfoController get info => Get.find();

  IForm get species => info.state.species;

  Future<void> loadAttrs({bool reload = false}) async {
    state.attrs.value = (await relationCtrl.provider.work!.loadInstanceDetail(
        species.metadata.id, species.metadata.belongId!)) as List<XAttribute>;
  }

  void onAttrOperation(operation, String code) async {
    try {
      var attr = state.attrs.firstWhere((element) => element.code == code);
      var success = await species.deleteAttribute(attr);
      if (success) {
        state.attrs.remove(attr);
        state.attrs.refresh();
        ToastUtils.showMsg(msg: "删除成功");
      }
    } catch (e) {}
  }
}

class AttrsState extends BaseGetState {
  var attrs = <XAttribute>[].obs;
}
