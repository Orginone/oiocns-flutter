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

enum CohortEvent {
  create("创建群组"),
  update("修改群组"),
  role("角色管理"),
  identity("身份管理"),
  transfer("转移权限"),
  dissolution("解散群组"),
  exit("退出群组");

  final String funcName;

  const CohortEvent(this.funcName);
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

  /// 搜索回调
  searchingCallback(String filter) async {
    _searchedCohorts.clear();
    List<Cohort> cohorts = _currentPerson.joinedCohorts.where((item) {
      return item.target.name.contains(filter);
    }).toList();
    _searchedCohorts.addAll(cohorts);
  }

  /// 切换空间
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
      messageCtrl.cohortChange(CohortEvent.create, cohort.target);
    }
  }

  /// 更新群组
  updateCohort(Map<String, dynamic> value) async {
    var cohort = Target.fromMap(value);
    Target updatedTarget = await currentPerson.updateCohort(
      id: cohort.id,
      code: cohort.code,
      name: cohort.name,
      typeName: cohort.typeName,
      remark: cohort.team?.remark ?? "",
      belongId: cohort.belongId ?? "",
      thingId: cohort.thingId,
    );
    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      messageCtrl.cohortChange(CohortEvent.update, updatedTarget);
    }
  }

  cohortFunc(CohortEvent func, Target cohort) async {
    switch (func) {
      case CohortEvent.update:
        var json = cohort.toJson();
        json["remark"] = cohort.team?.remark;
        Map<String, dynamic> args = {
          "func": func,
          "cohort": json,
        };
        Get.toNamed(Routers.cohortMaintain, arguments: args);
        break;
      case CohortEvent.role:
        break;
      case CohortEvent.identity:
        break;
      case CohortEvent.transfer:
        break;
      case CohortEvent.dissolution:
        await CohortApi.delete(cohort.id);
        break;
      case CohortEvent.exit:
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
      case CohortEvent.create:
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
