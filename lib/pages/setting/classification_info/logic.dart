import 'package:flutter/material.dart' hide Form;
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
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
    if (species.metadata.code == 'matters') {
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
        var success = await state.species.delete();
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
      var op = state.operation.firstWhere((element) => element.metadata.code == code);
      if (operation == "delete") {
        var success = await op.delete();
        if (success) {
          state.operation.remove(op);
          state.operation.refresh();
          ToastUtils.showMsg(msg: "删除成功");
        } else {
          ToastUtils.showMsg(msg: "删除失败");
        }
      } else if (operation == 'edit') {
        await createForm(form: op as Form);
      }
    } catch (e) {}
  }

  void onDocumentOperation(operation, String code) async {
    try {
      var attr = state.attrs.firstWhere((element) => element.code == code);
      if (operation == "copy") {
        SettingController settingController = Get.find();
        var property =
            await state.data.source.createProperty(PropertyModel(
          sourceId: attr.belongId,
          id: attr.property?.id,
          name: attr.property?.name,
          code: attr.property?.code,
          valueType: attr.property?.valueType,
          dictId: attr.property?.dictId,
        ));
        if (property != null) {
          var attrModel = AttributeModel.fromJson(attr.toJson());
          attrModel.propId = property.id;
          var success = await state.data.source.update(attrModel);
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

  Future<void> createForm({Form? form}) async {
    showCreateFormDialog(context,
        code: form?.metadata.code ?? "",
        name: form?.metadata.name ?? "",
        public: form?.metadata.public ?? true,
        isEdit: form != null, onCreate: (name, code, public) async {
      var model = OperationModel.fromJson(form?.metadata.toJson() ?? {});
      model.public = public;
      model.speciesId = state.species.metadata.id;
      model.name = name;
      model.code = code;
      if (form != null) {
        var success = await state.data.source.updateForm(model);
        if (success) {
          await loadOperation(reload: true);
        }
      } else {
        var success = await state.data.source.createForm(model);
        if (success) {
          await loadOperation(reload: true);
        }
      }
    });
  }

  Future<void> createAttr() async {
    List<IAuthority> auth = [];
    IAuthority? authority = await state.data.space.loadSuperAuth();
    if (authority != null) {
      auth.add(authority);
    }
    showCreateAttrDialog(
        context, auth, state.attrs.map((element) => element.property!).toList(),
        onCreate: (name, code, remark, property, authority, public) async {
      bool success = await state.data.source.createAttr(AttributeModel(
        authId: authority.metadata.id,
        propId: property.id,
        name: name,
        code: code,
        remark: remark, id: authority.metadata.id, speciesId: authority.metadata.belongId, shareId: authority.metadata.shareId,
      ));
      if (success) {
        await loadAttrs(reload: true);
      }
    });
  }

  Future<void> createWork({XWorkDefine? flow}) async {
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
          ..sourceIds = selected.map((e) => e.metadata.id).join(',');
      } else {
       model = CreateDefineReq(
            name: name,
            isCreate: isCreate,
            remark: remark,
            code: name,
            speciesId: state.species.metadata.id,
            sourceIds: selected.map((e) => e.metadata.id).join(','));

      }
      data = await state.data.source.createWork(model);
      if (data != null) {
        await loadFlow();
      }
    });
  }

  Future<void> loadFlow() async {
    state.flow.value =
        await state.data.source.loadTodos();
  }

  Future<void> loadAttrs({bool reload = false}) async {
    state.attrs.value = await state.data.source.loadAttrs(state.data.space.metadata.id);
  }

  Future<void> loadOperation({bool reload = false}) async {
    state.operation.value = await state.data.source.loadOperations(
        state.data.space.metadata.id,
        false,
        true,
        true,
        PageRequest(offset: 0, limit: 999, filter: ''),
        reload: reload);
  }
}
