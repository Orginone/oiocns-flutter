import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/work/work_start/logic.dart';
import 'package:orginone/pages/work/work_start/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'dialog.dart';
import 'state.dart';

class CreateWorkController extends BaseController<CreateWorkState>
    with GetTickerProviderStateMixin {
  final CreateWorkState state = CreateWorkState();

  WorkStartController get work => Get.find<WorkStartController>();

  SettingController get setting => Get.find<SettingController>();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
  }

  Future<void> loadMainTable() async {
    WorkNodeModel? node = (await state.define.loadWorkNode());
    List<XForm> forms = node?.forms ?? [];

    state.workForm.value =
        forms.firstWhere((element) => element.shareId == element.belongId);

    if (state.workForm.value != null) {
      try {
        var iForm = forms
            .firstWhere((element) => state.workForm.value!.id == element.id);
        state.workForm.value!.attributes = await setting.provider.work!
            .loadAttributes(iForm.id, state.define.workItem.belongId);
      } catch (e) {}
    }
  }

  Future<void> loadSubTable() async {
    WorkNodeModel? node = (await state.define.loadWorkNode());
    List<XForm> forms = node?.forms ?? [];

    state.thingForm.value =
        forms.where((element) => element.shareId == element.belongId).toList();

    for (var form in state.thingForm) {
      try {
        var iForm = forms.firstWhere((element) => form.id == element.id);
        form.attributes = await setting.provider.work!
            .loadAttributes(iForm.id, state.define.workItem.belongId);
      } catch (e) {}
    }
    state.tabController =
        TabController(length: state.thingForm.length, vsync: this);
  }

  Future<void> submit() async {
    for (var element in state.workForm.value?.attributes ?? []) {
      if (element.fields?.required ?? false) {
        if (element.fields!.defaultData.value == null) {
          return ToastUtils.showMsg(msg: element.fields!.hint!);
        }
      }
    }
    Map<String, dynamic> headerData = {};
    for (var element in state.workForm.value?.attributes ?? []) {
      if (element.fields?.defaultData.value != null) {
        headerData[element.id!] = element.fields?.defaultData.value;
      }
    }

    List<Map<String, dynamic>> formData = [];
    for (var form in state.thingForm) {
      if(form.things.isNotEmpty){
        Map<String,dynamic> data = {
          'isHeader':false,
          'resourceData':'[]',
          'changeData':form.things.map((e) =>{e.id:e.data??""}).toList(),
        };
        formData.add(data);
      }
    }
    WorkStartNetWork.createInstance(state.define, headerData,formData);
  }

  void jumpEntity(XForm form) {
    List<String> ids =
        form.things.map((element) => element.id ?? "").toList() ?? [];
    Get.toNamed(Routers.choiceThing, arguments: {"ids": ids})?.then((value) {
      if (value != null) {
        form.things = value;
        state.thingForm.refresh();
      }
    });
  }

  void subTableOperation(SubTableEnum function) {
    int subTableIndex = state.tabController.index;
    XForm form = state.thingForm[subTableIndex];

    if (function == SubTableEnum.choiceTable) {
      jumpEntity(form);
    } else {
      showCreateAuthDialog(context, form, onSuceess: (model) {
        if (function == SubTableEnum.addTable) {
          form.things.add(model);
        } else {
          for (var value in form.things) {
            value.data = model.data;
          }
        }
        state.thingForm.refresh();
      }, isAllChange: function == SubTableEnum.allChange);
    }
  }

  void subTableFormOperation(String function, String key) {
    int subTableIndex = state.tabController.index;
    XForm form = state.thingForm[subTableIndex];
    var thing = form.things.firstWhere((element) => element.id == key);
    if (function == 'delete') {
      form.things.remove(thing);
      state.thingForm.refresh();
    }
    if (function == 'edit') {
      showCreateAuthDialog(context, form, onSuceess: (model) {
        thing = model;
        state.thingForm.refresh();
      }, thing: thing);
    }
  }
}
