import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'dialog.dart';
import 'state.dart';

class CreateWorkController extends BaseController<CreateWorkState>
    with GetTickerProviderStateMixin {
  @override
  final CreateWorkState state = CreateWorkState();

  @override
  void onReady() async {
    super.onReady();
    LoadingDialog.showLoading(context);

    await loadMainTable();
    await loadSubTable();
    state.apply = await state.work.createApply();
    ResultType<AnyThingModel> result =
        // await kernel.createThing('', state.target.id);
        await kernel.createThing(
      state.target.id,
      [],
      '',
    );
    if (result.data != null) {
      for (var element in state.mainForm) {
        //TODO:IForm没有这个数据 things  用到时候要研究一下逻辑
        // element.things.add(result.data!);
      }
    }
    LoadingDialog.dismiss(context);
  }

  Future<void> loadMainTable() async {
    //TODO:IForm没有这个数据 用到时候要研究一下逻辑
    // var forms = (await state.work.loadWorkForms());
    // state.mainForm.value =
    //     forms.where((element) => element.metadata.typeName == "主表").toList();
    state.mainTabController =
        TabController(length: state.mainForm.length, vsync: this);
    for (var form in state.mainForm) {
      //TODO:IForm没有这个数据 用到时候要研究一下逻辑
      // await form.loadAttributes();
      // await form.loadItems();
      // await form.createFields();
    }

    state.mainForm.refresh();
  }

  Future<void> loadSubTable() async {
    //TODO:IForm没有这个数据 用到时候要研究一下逻辑
    // var forms = (await state.work.loadWorkForms());
    // state.subForm.value =
    //     forms.where((element) => element.metadata.typeName == "子表").toList();

    state.subTabController =
        TabController(length: state.subForm.length, vsync: this);
    for (var form in state.subForm) {
      //TODO:IForm没有这个数据 用到时候要研究一下逻辑
      // await form.loadAttributes();
      // await form.loadItems();
      // await form.createFields();
    }
    state.subForm.refresh();
  }

  Future<void> submit() async {
    // for (var element in state.mainForm.value?.fields ?? []) {
    //   if (element.field.required ?? false) {
    //     if (element.field!.defaultData.value == null) {
    //       return ToastUtils.showMsg(msg: element.fields!.hint!);
    //     }
    //   }
    // }
    LoadingDialog.showLoading(context);

    if (state.apply != null) {
      for (var form in state.mainForm) {
        state.apply!.instanceData.fields![form.id] = form.fields;
      }

      for (var form in state.subForm) {
        state.apply!.instanceData.fields![form.id] = form.fields;
      }
      Map<String, FormEditData> fromData = {};
      for (var element in state.mainForm) {
        var main = FormEditData(
          createTime: DateTime.now().toString(),
          nodeId: state.work.node?.id,
          creator: relationCtrl.user.id,
          after: [],
          before: [],
        );
        //TODO:IForm没有这个数据 things setThing 用到时候要研究一下逻辑
        // main.after = element.things;
        // element.setThing(main.after[0]);
        fromData[element.id] = main;
        state.apply!.instanceData.primary?.addAll(main.after[0].otherInfo);
      }
      for (var element in state.subForm) {
        var sub = FormEditData(
            createTime: DateTime.now().toString(),
            nodeId: state.work.node?.id,
            creator: relationCtrl.user.id,
            before: [],
            after: []);
        //TODO:IForm没有这个数据 things  用到时候要研究一下逻辑
        // sub.after = element.things;
        // sub.before =
        //     element.things.where((element) => element.isSelected).toList();
        fromData[element.id] = sub;
      }
      bool success = await state.apply!
          .createApply(state.apply!.belong.id, state.remark.text, fromData);
      LoadingDialog.dismiss(context);
      if (success) {
        ToastUtils.showMsg(msg: "提交成功");
        Get.back();
      }
    }
  }

  Future<List<List<String>>> loadSubFieldData(
      IForm form, List<FieldModel> fields) async {
    List<List<String>> content = [];
    //TODO:IForm没有这个数据 things  用到时候要研究一下逻辑
    // for (var thing in form.things) {
    //   List<String> data = [
    //     thing.id ?? "",
    //     thing.status ?? "",
    //     ShareIdSet[thing.creater]?.name ?? "",
    //   ];
    //   for (var field in fields) {
    //     dynamic value = thing.otherInfo[field.id];
    //     if (value == null) {
    //       data.add('');
    //     } else {
    //       try {
    //         data.add(await _converField(field, thing.otherInfo[field.id]));
    //       } catch (e) {
    //         print('');
    //       }
    //     }
    //   }
    //   content.add(data);
    // }
    return content;
  }

  Future<String> _converField(FieldModel field, dynamic value) async {
    if (field.field.type == "input") {
      return value ?? "";
    } else {
      switch (field.field.type) {
        case "selectPerson":
        case "selectDepartment":
        case "selectGroup":
          var share = relationCtrl.user.findShareById(value);
          return share.name;
        case "select":
        case 'switch':
          Map<dynamic, String> select = {};
          for (var value in field.lookups ?? []) {
            select[value.value] = value.text ?? "";
          }
          return select[value] ?? "";
        case "upload":
          var file = value != null ? FileItemModel.fromJson(value) : null;
          return file?.name ?? "";
        default:
          if (field.field.type == "selectTimeRange" ||
              field.field.type == "selectDateRange") {
            return value.join("至");
          }
          return value ?? "";
      }
    }
  }

  void jumpEntity(IForm form) async {
    Get.toNamed(Routers.choiceThing,
            arguments: {"form": form, 'belongId': state.target.belongId})
        ?.then((value) {
      state.subForm.refresh();
    });
  }

  void subTableOperation(SubTableEnum function) {
    int subTableIndex = state.subTabController.index;
    IForm form = state.subForm[subTableIndex];

    if (function == SubTableEnum.choiceTable) {
      jumpEntity(form);
    } else {
      showCreateAuthDialog(context, form, state.target, onSuceess: (model) {
        //TODO:IForm没有这个数据 things  用到时候要研究一下逻辑
        // form.things.add(model);
        state.subForm.refresh();
      });
    }
  }

  void subTableFormOperation(String function, String key) {
    int subTableIndex = state.subTabController.index;
    IForm form = state.subForm[subTableIndex];
    //TODO:IForm没有这个数据 things  用到时候要研究一下逻辑
    // var thing = form.things.firstWhere((element) => element.id == key);
    if (function == 'delete') {
      // form.things.remove(thing);
      state.subForm.refresh();
    }
    if (function == 'edit') {
      // showCreateAuthDialog(context, form, state.target, onSuceess: (model) {
      // thing = model;
      //   state.subForm.refresh();

      // }, thing: thing);
    }
  }

  void changeMainIndex(int index) {
    if (state.mainIndex.value != index) state.mainIndex.value = index;
  }

  void changeSubIndex(int index) {
    if (state.subIndex.value != index) state.subIndex.value = index;
  }
}
