import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/core/target/cohort.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/target/person.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/routers.dart';

enum CohortFunction {
  create("创建群组"),
  update("修改群组"),
  role("角色管理"),
  identity("身份管理"),
  transfer("转移权限"),
  dissolution("解散群组"),
  exit("退出群组");

  final String funcName;

  const CohortFunction(this.funcName);
}

class TargetController extends GetxController {
  late Person _currentPerson;

  Person get currentPerson => _currentPerson;

  Company get currentCompany => _currentPerson.currentCompany;

  final RxList<Cohort> _searchedCohorts = <Cohort>[].obs;

  List<Cohort> get searchedCohorts => _searchedCohorts;

  @override
  void onInit() {
    super.onInit();
    _currentPerson = Person(auth.userInfo);
    _currentPerson.loadJoinedCompanies();
  }

  searchingCallback(String filter) async {
    _searchedCohorts.clear();
    List<Cohort> cohorts = _currentPerson.joinedCohorts.where((item) {
      return item.target.name.contains(filter);
    }).toList();
    _searchedCohorts.addAll(cohorts);
  }

  Future<void> switchSpaces(String spaceId) async {
    if (auth.spaceId == spaceId) {
      return;
    }

    LoginResp loginResp = await PersonApi.changeWorkspace(spaceId);
    setAccessToken = loginResp.accessToken;
    _currentPerson.setCurrentCompany(spaceId);

    await loadAuth();
    if (auth.isCompanySpace()) {
      await currentCompany.loadTree();
    }

    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      messageCtrl.setGroupTop(spaceId);
    }
  }

  /// 创建群组
  createCohort(Map<String, dynamic> value) async {
    var targetCtrl = Get.find<TargetController>();
    Cohort cohort = await targetCtrl.currentPerson.createCohort(
      code: value["code"],
      name: value["name"],
      remark: value["remark"],
    );
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

  /// 更新群组
  updateCohort(Map<String, dynamic> value) async {
    Target updatedTarget = await currentPerson.updateCohort(
      id: value["id"],
      code: value["code"],
      name: value["name"],
      remark: value["remark"],
    );

    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      IChat? chat = messageCtrl.ref(auth.spaceId, updatedTarget.id);
      var msgBody = "${auth.userInfo.name}将群名称修改为${updatedTarget.name}";
      chat?.sendMsg(msgType: MsgType.updateCohortName, msgBody: msgBody);
    }
  }

  cohortFunc(CohortFunction func, Target cohort) async {
    switch (func) {
      case CohortFunction.update:
        Map<String, dynamic> args = {
          "func": func,
          "cohort": {
            "id": cohort.id,
            "name": cohort.name,
            "code": cohort.code,
            "remark": cohort.team?.remark,
            "thingId": cohort.thingId,
            "belongId": cohort.belongId
          },
        };
        Get.toNamed(Routers.cohortMaintain, arguments: args);
        break;
      case CohortFunction.role:
        break;
      case CohortFunction.identity:
        break;
      case CohortFunction.transfer:
        break;
      case CohortFunction.dissolution:
        await CohortApi.delete(cohort.id);
        break;
      case CohortFunction.exit:
        // await CohortApi.exit(cohort.id);
        //
        // String msgBody = "${auth.userInfo.name}退出了群聊";
        // await chatServer.send(
        //   spaceId: cohort.belongId!,
        //   itemId: cohort.id,
        //   msgBody: msgBody,
        //   msgType: MsgType.exitCohort,
        // );
        break;
      case CohortFunction.create:
        break;
    }
  }
}

class TargetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TargetController());
  }
}
