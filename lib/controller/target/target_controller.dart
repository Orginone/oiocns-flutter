import 'package:get/get.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/target/cohort.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/target/person.dart';

enum TargetEvent {
  createCohort("创建群组"),
  updateCohort("修改群组"),
  deleteCohort("解散群组"),
  exitCohort("退出群组"),
  role("角色管理"),
  identity("身份管理"),
  transfer("转移权限");

  final String funcName;

  const TargetEvent(this.funcName);
}

class TargetController extends GetxController {
  late Person _currentPerson;

  final RxList<Cohort> _searchedCohorts = <Cohort>[].obs;

  final Rx<Company?> _maintainCompany = Rxn();

  Company? get maintainCompany => _maintainCompany.value;

  Person get currentPerson => _currentPerson;

  Company get currentCompany => _currentPerson.currentCompany;

  List<Cohort> get searchedCohorts => _searchedCohorts;

  @override
  void onInit() {
    super.onInit();
    _currentPerson = Person(auth.userInfo);
    _currentPerson.loadJoinedCompanies();
  }

  setCurrentMaintain(Company target) {
    _maintainCompany.value = target;
  }

  /// 搜索回调
  searchingCallback(String filter) async {
    _searchedCohorts.clear();
    List<Cohort> cohorts = _currentPerson.joinedCohorts.where((item) {
      return item.target.name.contains(filter);
    }).toList();
    _searchedCohorts.addAll(cohorts);
  }

  /// 通知会话控制器
  notification(TargetEvent event, Target target) {
    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      messageCtrl.targetChange(event, target);
    }
  }

  /// 创建群组
  createCohort(Map<String, dynamic> value) async {
    Cohort cohort = await currentPerson.createCohort(
      code: value["code"],
      name: value["name"],
      remark: value["remark"],
    );
    notification(TargetEvent.createCohort, cohort.target);
  }

  /// 更新群组
  updateCohort(Map<String, dynamic> value) async {
    var cohort = Target.fromMap(value);
    notification(TargetEvent.updateCohort, cohort);
    await currentPerson.updateCohort(
      id: cohort.id,
      code: cohort.code,
      name: cohort.name,
      typeName: cohort.typeName,
      remark: cohort.team?.remark ?? "",
      belongId: cohort.belongId ?? "",
      thingId: cohort.thingId,
    );
  }

  /// 解散群组
  deleteCohort(Target cohort) async {
    await notification(TargetEvent.deleteCohort, cohort);
    await currentPerson.dissolutionCohort(
      id: cohort.id,
      typeName: cohort.typeName,
      belongId: cohort.belongId ?? "",
    );
  }

  /// 解散群组
  exitCohort(Target cohort) async {
    notification(TargetEvent.exitCohort, cohort);
    await currentPerson.exitCohort(cohort.id);
  }

  targetEvent(TargetEvent func, Target cohort) async {
    switch (func) {
      case TargetEvent.updateCohort:
        break;
      case TargetEvent.role:
        break;
      case TargetEvent.identity:
        break;
      case TargetEvent.transfer:
        break;
      case TargetEvent.deleteCohort:
        await CohortApi.delete(cohort.id);
        break;
      case TargetEvent.exitCohort:
        await currentPerson.exitCohort(cohort.id);
        break;
      case TargetEvent.createCohort:
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
