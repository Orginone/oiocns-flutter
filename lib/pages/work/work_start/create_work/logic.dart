import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'dialog.dart';
import 'state.dart';

class CreateWorkController extends BaseController<CreateWorkState>
    with GetTickerProviderStateMixin {
  final CreateWorkState state = CreateWorkState();

  WorkStartController get work => Get.find<WorkStartController>();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);


    await loadMainTable();
    await loadSubTable();
    state.apply = await state.work.createApply();
    ResultType<AnyThingModel> result =
    await kernel.anystore.createThing('', state.target.id);
    if (result.data != null) {
      state.mainForm.value!.things.add(result.data!);
    }
    LoadingDialog.dismiss(context);
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
  }

  Future<void> loadMainTable() async {
    var forms = (await state.work.loadWorkForms());
    state.mainForm.value =
        forms.firstWhere((element) => element.metadata.typeName == "主表");

    if (state.mainForm.value != null) {
      await state.mainForm.value!.loadAttributes();
      await state.mainForm.value!.loadItems();
      await state.mainForm.value!.createFields();
    }

    state.mainForm.refresh();
  }

  Future<void> loadSubTable() async {
    var forms = (await state.work.loadWorkForms());
    state.subForm.value =
        forms.where((element) => element.metadata.typeName == "子表").toList();

    state.tabController =
        TabController(length: state.subForm.length, vsync: this);
    for (var form in state.subForm) {
      await form.loadAttributes();
      await form.loadItems();
      await form.createFields();
    }
    state.subForm.refresh();
  }

  Future<void> submit() async {
    for (var element in state.mainForm.value?.fields ?? []) {
      if (element.field.required ?? false) {
        if (element.field!.defaultData.value == null) {
          return ToastUtils.showMsg(msg: element.fields!.hint!);
        }
      }
    }
    LoadingDialog.showLoading(context);

    if (state.apply != null) {
      state.apply!.instanceData.fields[state.mainForm.value!.id] = state.mainForm.value!.fields;
      for (var form in state.subForm) {
        state.apply!.instanceData.fields[form.id] = form.fields;
      }
      Map<String, FormEditData> fromData = {};
      var main = FormEditData(createTime: DateTime.now().toString(),nodeId: state.work.node?.id,creator: settingCtrl.user.id,);
      main.after = state.mainForm.value!.things;
      state.mainForm.value!.setThing(main.after[0]);
      state.apply!.instanceData.primary.addAll(main.after![0].otherInfo);

      fromData[state.mainForm.value!.id] = main;
      for (var element in state.subForm) {
        var sub = FormEditData(createTime: DateTime.now().toString(),nodeId: state.work.node?.id,creator: settingCtrl.user.id);
        sub.after = element.things;
        sub.before = element.things.where((element) => element.isSelected).toList();
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
    for (var thing in form.things) {
      List<String> data = [thing.id ?? "",
        thing.status ?? "",
        ShareIdSet[thing.creater]?.name??"",];
      for (var field in fields) {
        dynamic value = thing.otherInfo[field.id];
        if(value == null){
          data.add('');
        }else{
          try{
            data.add(await _converField(field, thing.otherInfo[field.id]));
          }catch(e){
            print('');
          }
        }
      }
      content.add(data);
    }
    return content;
  }


  Future<String> _converField(FieldModel field,dynamic value) async{
    if (field.field.type == "input") {
      return value??"";
    } else {
      switch (field.field.type) {
        case "selectPerson":
        case "selectDepartment":
        case "selectGroup":
          var share = await settingCtrl.user.findShareById(value);
          return share.name;
        case "select":
        case 'switch':
        Map<dynamic,String> select= {};
        for (var value in field.lookups??[]) {
          select[value.value] = value.text ?? "";
        }
        return select[value]??"";
        case "upload":
          var file = value!=null?FileItemModel.fromJson(value):null;
          return file?.name??"";
        default:
          if(field.field.type == "selectTimeRange" || field.field.type == "selectDateRange"){
            return value.join("至");
          }
          return value??"";
      }
    }
  }

  void jumpEntity(IForm form) async{

    Get.toNamed(Routers.choiceThing, arguments: {"form": form,'belongId':state.target.belong.id})?.then((value){
      state.subForm.refresh();
    });
  }

  void subTableOperation(SubTableEnum function) {
    int subTableIndex = state.tabController.index;
    IForm form = state.subForm[subTableIndex];

    if (function == SubTableEnum.choiceTable) {
      jumpEntity(form);
    } else {
      showCreateAuthDialog(context, form,state.target, onSuceess: (model) {
        form.things.add(model);
        state.subForm.refresh();
      });
    }
  }

  void subTableFormOperation(String function, String key) {
    int subTableIndex = state.tabController.index;
    IForm form = state.subForm[subTableIndex];
    var thing = form.things.firstWhere((element) => element.id == key);
    if (function == 'delete') {
      form.things.remove(thing);
      state.subForm.refresh();
    }
    if (function == 'edit') {
      showCreateAuthDialog(context, form,state.target, onSuceess: (model) {
        thing = model;
        state.subForm.refresh();
      }, thing: thing);
    }
  }
}
