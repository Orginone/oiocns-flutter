import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'logic.dart';

class SpeciesPage extends BaseGetPageView<SpeciesController, SpeciesState> {
  @override
  Widget buildView() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              CommonWidget.commonDocumentWidget(
                  title: ["名称", "编号", "信息", "备注", "创建时间"],
                  content: state.species.map((e) {
                    return [
                      e.name ?? "",
                      e.code ?? "",
                      e.info ?? "",
                      e.remark ?? "",
                      DateTime.tryParse(e.createTime ?? "")
                              ?.format(format: "yyyy-MM-dd HH:mm:ss") ??
                          "",
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
  SpeciesController getController() {
    return SpeciesController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "species";
  }
}

class SpeciesController extends BaseController<SpeciesState> {
  final SpeciesState state = SpeciesState();

  ClassificationInfoController get info => Get.find();

  ISpecies get species => info.state.species;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadSpecies();
    LoadingDialog.dismiss(context);
  }

  Future<void> loadSpecies({bool reload = false}) async {
    state.species.value = await species.loadItems(reload: reload);
  }

  void onWorkOperation(operation, String name) async {
    try {
      var xspecies =
          state.species.firstWhere((element) => element.name == name);
      if (operation == "delete") {
        var success = await species.deleteItem(xspecies);
        if (success) {
          state.species.remove(xspecies);
          state.species.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        }
      } else if (operation == 'edit') {
        createSpecies(xspecies: xspecies);
      }
    } catch (e) {}
  }

  Future<void> createSpecies({XSpeciesItem? xspecies}) async {
    showCreateSpeciesDialog(context,
        isEdit: xspecies != null,
        name: xspecies?.name ?? "",
        info: xspecies?.info ?? "",
        remark: xspecies?.remark ?? "", callBack: (name, info, remark) async {
      SpeciesItemModel model = SpeciesItemModel();
      model.remark = remark;
      model.info = info;
      model.name = name;
      if (xspecies != null) {
        model.id = xspecies.id;
        await species.updateItem(model);
      } else {
        await species.createItem(model);
      }
      await loadSpecies(reload: true);
    });
  }
}

class SpeciesState extends BaseGetState {
  var species = <XSpeciesItem>[].obs;
}
