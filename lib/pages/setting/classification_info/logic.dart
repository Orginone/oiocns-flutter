import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

SettingController get setting => Get.find();

class ClassificationInfoController
    extends BaseController<ClassificationInfoState>
    with GetTickerProviderStateMixin {
  final ClassificationInfoState state = ClassificationInfoState();

  ClassificationInfoController() {
    state.tabTitle = [
      ClassificationEnum.info,
      ClassificationEnum.attrs,
      ClassificationEnum.form
    ];
    if (findHasMatters(state.species)) {
      state.tabTitle.add(ClassificationEnum.work);
    }
    state.tabController =
        TabController(length: state.tabTitle.length, vsync: this);
  }

  bool findHasMatters(SpeciesItem species) {
    if (species.target.code == 'matters') {
      return true;
    } else if (species.parent != null) {
      return findHasMatters((species.parent!) as SpeciesItem);
    }
    return false;
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);

    await loadFlow();
    await loadAttrs();
    await loadOperation();
    LoadingDialog.dismiss(context);
  }

  void changeIndex(int index) {
    if (index != state.currentIndex.value) {
      state.currentIndex.value = index;
    }
  }

  void create() {
    if (state.currentIndex.value == 1) {
      createAttr();
    }
    if (state.currentIndex.value == 2) {
      createForm();
    }
    if (state.currentIndex.value == 3) {
      createWork();
    }
  }

  void onWorkOperation(operation, String name) async {
    try {
      var flow = state.flow.firstWhere((element) => element.name == name);
      if (operation == "delete") {
        var success = await state.species.deleteWork(flow.id!);
        if (success) {
          state.flow.remove(flow);
          state.flow.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        } else {
          ToastUtils.showMsg(msg: "删除失败");
        }
      } else if (operation == 'edit') {
        createWork(flow: flow);
      }
    } catch (e) {}
  }

  void onFormOperation(operation, String code) async {
    try {
      var op = state.operation.firstWhere((element) => element.code == code);
      if (operation == "delete") {
        var success = await state.species.deleteOperation(op.id!);
        if (success) {
          state.operation.remove(op);
          state.operation.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        } else {
          ToastUtils.showMsg(msg: "删除失败");
        }
      } else if (operation == 'edit') {
        await createForm(xOperation: op);
      }
    } catch (e) {}
  }

  void onDocumentOperation(operation, String code) async {
    try {
      var attr = state.attrs.firstWhere((element) => element.code == code);
      if (operation == "copy") {
        SettingController settingController = Get.find();
        var property =
            await state.data.space.property.createProperty(PropertyModel(
          sourceId: attr.belongId,
          belongId: settingController.user?.id,
          id: attr.property?.id,
          name: attr.property?.name,
          code: attr.property?.code,
          valueType: attr.property?.valueType,
          dictId: attr.property?.dictId,
        ));
        if (property != null) {
          var attrModel = AttributeModel.fromJson(attr.toJson());
          attrModel.propId = property.id;
          var success = await state.species.updateAttr(attrModel);
          if (success) {
            ToastUtils.showMsg(msg: "复制成功");
          } else {
            ToastUtils.showMsg(msg: "复制失败");
          }
        } else {
          ToastUtils.showMsg(msg: "复制失败");
        }
      }
    } catch (e) {}
  }

  Future<void> createForm({XOperation? xOperation}) async {
    showCreateFormDialog(context,
        code: xOperation?.code ?? "",
        name: xOperation?.name ?? "",
        public: xOperation?.public ?? true,
        isEdit: xOperation != null, onCreate: (name, code, public) async {
      var model = OperationModel.fromJson(xOperation?.toJson() ?? {});
      model.public = public;
      model.speciesId = state.species.id;
      model.name = name;
      model.code = code;
      if (xOperation != null) {
        var success = await state.species.updateOperation(model);
        if (success) {
          await loadOperation(reload: true);
        }
      } else {
        var success = await state.species.createOperation(model);
        if (success) {
          await loadOperation(reload: true);
        }
      }
    });
  }

  Future<void> createAttr() async {
    List<IAuthority> auth = [];
    IAuthority? authority = await state.data.space.loadAuthorityTree();
    if (authority != null) {
      auth.add(authority);
    }
    showCreateAttrDialog(
        context, auth, state.attrs.map((element) => element.property!).toList(),
        onCreate: (name, code, remark, property, authority, public) async {
      bool success = await state.species.createAttr(AttributeModel(
        authId: authority.id,
        public: public,
        propId: property.id,
        name: name,
        code: code,
        remark: remark,
      ));
      if (success) {
        await loadAttrs(reload: true);
      }
    });
  }

  Future<void> createWork({XFlowDefine? flow}) async {
    showCreateWorkDialog(context, state.data.space.species,
        isEdit: flow != null,
        name: flow?.name ?? "",
        remark: flow?.remark ?? "",
        selected: flow?.sourceIds?.split(',') ?? [],
        create: flow?.isCreate ?? false,
        onCreate: (name, remark, isCreate, selected) async {
      var data;
      var model;
      if (flow != null) {
       model = CreateDefineReq.fromJson(flow.toJson())
          ..remark = remark
          ..name = name
          ..isCreate = isCreate
          ..sourceIds = selected.map((e) => e.id).join(',');
      } else {
       model = CreateDefineReq(
            name: name,
            isCreate: isCreate,
            remark: remark,
            code: name,
            speciesId: state.species.id,
            sourceIds: selected.map((e) => e.id).join(','));

      }
      data = await state.species.publishWork(model);
      if (data != null) {
        await loadFlow();
      }
    });
  }

  Future<void> loadFlow() async {
    state.flow.value =
        await state.species.loadWork();
  }

  Future<void> loadAttrs({bool reload = false}) async {
    state.attrs.value = await state.species.loadAttrs(state.data.space.id);
  }

  Future<void> loadOperation({bool reload = false}) async {
    state.operation.value = await state.species.loadOperations(
        state.data.space.id,
        false,
        true,
        true,
        PageRequest(offset: 0, limit: 999, filter: ''),
        reload: reload);
  }
}
