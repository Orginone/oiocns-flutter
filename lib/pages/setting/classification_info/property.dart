import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/base/model.dart' as model;
import 'logic.dart';

class PropertyPage extends BaseGetPageView<PropertyController, PropertyState> {
  @override
  Widget buildView() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              List<List<String>> content = [];

              for (var element in state.propertys) {
                content.add([
                  element.code ?? "",
                  element.name ?? "",
                  element.valueType ?? "",
                  element.unit ?? "",
                  element.directory?.name ?? "",
                  element.belong?.name ?? "",
                  element.species?.name ?? "",
                  element.remark ?? ""
                ]);
              }
              return CommonWidget.commonDocumentWidget(
                  title: [
                    '属性代码',
                    "属性名称",
                    "属性类型",
                    "单位",
                    "选择字典",
                    "归属组织",
                    "物资类别",
                    "属性定义",
                  ],
                  content: content,
                  showOperation: true,
                  popupMenus: [
                    const PopupMenuItem(
                      value: "edit",
                      child: Text("编辑属性"),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Text("删除属性"),
                    ),
                  ],
                  onOperation: (operation, code) {
                    controller.onOperation(operation, code);
                  });
            }),
          ],
        ),
      ),
    );
  }

  @override
  PropertyController getController() {
    return PropertyController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'property';
  }
}

class PropertyController extends BaseController<PropertyState> {
  final PropertyState state = PropertyState();

  ClassificationInfoController get info => Get.find();

  dynamic get species => info.state.species;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    await loadPropertys();
    LoadingDialog.dismiss(context);
  }

  void onOperation(operation, String code) async {
    try {
      var property =
          state.propertys.firstWhere((element) => element.code == code);

      if (operation == "edit") {
        createProperty(property: property);
      } else if (operation == 'delete') {
        bool success = await species.deleteProperty(property);
        if (success) {
          state.propertys.remove(property);
          state.propertys.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        }
      }
    } catch (e) {}
  }

  void createProperty({XProperty? property}) async {
    showCreateAttributeDialog(context,
        onCreate: (name, code, type, info, remark, [unit, dict]) async {
      var models = model.PropertyModel(
        name: name,
        code: code,
        valueType: type,
        remark: remark,
        unit: unit,
        directoryId: dict?.id,
      );
      if (property != null) {
        models.id = property.id;
        await species.updateProperty(models);
      } else {
        await species.createProperty(models);
      }
      await loadPropertys(reload: true);
    },
        name: property?.name ?? "",
        code: property?.code ?? "",
        remark: property?.remark ?? "",
        valueType: property?.valueType ?? "",
        unit: property?.unit ?? "",
        dictId: property?.id,
        isEdit: true,
        dictList: info.state.data.space!.directory.specieses ?? []);
  }

  Future<void> loadPropertys({bool reload = false}) async {
    state.propertys.value = await species.loadPropertys(reload: reload);
  }
}

class PropertyState extends BaseGetState {
  var propertys = <XProperty>[].obs;
}
