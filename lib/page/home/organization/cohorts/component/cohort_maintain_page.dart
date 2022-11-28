import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/core/target/cohort.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/api/hub/chat_server.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_controller.dart';
import 'package:orginone/util/widget_util.dart';

List<FormItem> formConfig = [
  const FormItem(
    fieldKey: 'name',
    fieldName: "群组名称",
    itemType: ItemType.text,
  ),
  const FormItem(
    fieldKey: 'code',
    fieldName: "群组编号",
    itemType: ItemType.text,
  ),
  const FormItem(
    fieldKey: 'remark',
    fieldName: "群组简介",
    itemType: ItemType.text,
  ),
];

class CohortMaintainPage extends GetView<CohortMaintainController> {
  const CohortMaintainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text(controller.label, style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarCenterTitle: true,
      body: FormWidget(
        formConfig,
        initValue: controller.old,
        submitCallback: (Map<String, dynamic> value) async {
          if (controller.func == CohortFunction.update) {
            controller.updateCohort(value).then((value) {
              if (Get.isRegistered<CohortsController>()) {
                Get.find<CohortsController>().onLoad();
              }
              Get.back();
            });
          } else {
            var targetCtrl = Get.find<TargetController>();
            Cohort cohort = await targetCtrl.currentPerson.createCohort(
              code: value["code"],
              name: value["name"],
              remark: value["remark"],
            );
            if (Get.isRegistered<CohortsController>()) {
              Get.find<CohortsController>().onLoad();
            }
            if (Get.isRegistered<MessageController>()) {
              var messageCtrl = Get.find<MessageController>();
              await messageCtrl.refreshMails();
              await loadAuth();
              var chat = messageCtrl.ref(auth.spaceId, cohort.target.id);
              chat?.openChat();
              Timer(const Duration(seconds: 1), () {
                chat?.sendMsg(
                  msgType: MsgType.createCohort,
                  msgBody: "${auth.userInfo.name}创建了群聊",
                );
              });
            }
          }
        },
      ),
    );
  }
}

class CohortMaintainController extends GetxController {
  late String label;
  late CohortFunction func;
  late Map<String, dynamic> old;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> args = Get.arguments;
    func = args["func"];
    old = args["cohort"] ?? {};
    if (func == CohortFunction.update) {
      label = CohortFunction.update.funcName;
    } else {
      label = CohortFunction.create.funcName;
    }
  }

  Future<dynamic> updateCohort(Map<String, dynamic> value) async {
    Target cohort = await CohortApi.update(value);
    Fluttertoast.showToast(msg: "修改成功！");

    String oldName = old["name"];
    if (oldName != cohort.name) {
      var msgBody = "${auth.userInfo.name}将群名称修改为${cohort.name}";
      await chatServer.send(
        spaceId: value["belongId"],
        itemId: cohort.id,
        msgBody: msgBody,
        msgType: MsgType.updateCohortName,
      );
    }
  }
}

class CohortMaintainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CohortMaintainController());
  }
}
