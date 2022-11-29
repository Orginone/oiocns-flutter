import 'package:get/get.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/base_target.dart';
import 'package:orginone/core/target/cohort.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/target/hospital.dart';
import 'package:orginone/core/target/university.dart';

class Person extends BaseTarget {
  final Company _selfCompany;
  final Rx<Company?> _currentCompany;
  final RxList<Company> _joinedCompanies;
  final RxList<Cohort> _joinedCohorts;
  final RxList<Person> _joinedFriends;

  Person(Target target)
      : _selfCompany = Company(Target.copyWith(target)..name = "个人空间"),
        _currentCompany = Rxn(),
        _joinedCompanies = <Company>[].obs,
        _joinedCohorts = <Cohort>[].obs,
        _joinedFriends = <Person>[].obs,
        super(target);

  get companyTypes => <TargetType>[
        TargetType.company,
        TargetType.university,
        TargetType.hospital
      ];

  /// 获取个人工作空间
  Company get selfCompany => _selfCompany;

  /// 获取当前工作空间
  Company get currentCompany => _currentCompany.value ?? _selfCompany;

  /// 获取加入的单位
  List<Company> get joinedCompanies => _joinedCompanies;

  /// 获取加入的群组
  List<Cohort> get joinedCohorts => _joinedCohorts;

  /// 获取所有好友
  List<Person> get joinedFriends => _joinedFriends;

  /// 切换当前工作空间
  Future<void> changeSpaces(Company company) async {
    if (auth.spaceId == company.target.id) {
      return;
    }

    // 调用接口切换空间，加载当前空间权限
    LoginResp loginResp = await PersonApi.changeWorkspace(company.target.id);
    setAccessToken = loginResp.accessToken;
    await loadAuth();
    _currentCompany.value = company;

    // 空间会话置顶
    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      messageCtrl.setGroupTop(company.target.id);
    }
  }

  /// 创建群组
  Future<Cohort> createCohort({
    required String code,
    required String name,
    required String remark,
  }) async {
    TargetModel targetModel = TargetModel(
      name: name,
      code: code,
      teamName: name,
      teamCode: code,
      teamRemark: remark,
    );
    Cohort cohort = Cohort(await _createCohort(targetModel));
    _joinedCohorts.add(cohort);
    await cohort.pullPersons([super.target.id]);
    return cohort;
  }

  /// 修改群组
  Future<void> updateCohort({
    required String id,
    required String code,
    required String name,
    required String typeName,
    required String remark,
    required String thingId,
    required String belongId,
  }) async {
    var target = TargetModel(
      id: id,
      code: code,
      name: name,
      typeName: typeName,
      teamCode: code,
      teamName: name,
      teamRemark: remark,
      thingId: thingId,
      belongId: belongId,
    );
    Target updatedTarget = await Kernel.getInstance.updateTarget(target);
    for (int i = 0; i < _joinedCohorts.length; i++) {
      var cohort = _joinedCohorts[i];
      if (cohort.target.id == updatedTarget.id) {
        _joinedCohorts[i] = Cohort(updatedTarget);
      }
    }
  }

  /// 解散群组
  Future<void> dissolutionCohort({
    required String id,
    required String typeName,
    required String belongId,
  }) async {
    var model = IdReqModel(
      id: id,
      typeName: typeName,
      belongId: belongId,
    );
    await Kernel.getInstance.deleteTarget(model);
    _joinedCohorts.removeWhere((item) => item.target.id == id);
  }

  /// 创建单位
  createCompany({
    required String name,
    required String code,
    required String teamName,
    required String teamCode,
    required String teamRemark,
    TargetType type = TargetType.company,
  }) async {
    if (!companyTypes.contains(type)) {
      throw Exception("未定义的类型");
    }
    TargetModel companyModel = TargetModel(
      name: name,
      code: code,
      teamName: teamName,
      teamCode: teamCode,
      typeName: type.label,
      teamRemark: teamRemark,
    );
    Target companyTarget = await Kernel.getInstance.createTarget(companyModel);
    Company company = _addCompany(companyTarget);
    await company.pullPersons([super.target.id]);
  }

  /// 申请加入群组
  applyJoinCohort(String cohortId) async {
    await _applyJoinTeam(cohortId, TargetType.cohort);
  }

  /// 申请加入个人
  applyJoinPerson(String personId) async {
    await _applyJoinTeam(personId, TargetType.person);
  }

  /// 申请加入单位
  applyJoinCompany(String companyId) async {
    await _applyJoinTeam(companyId, TargetType.company);
  }

  /// 申请加入组织
  _applyJoinTeam(String targetId, TargetType targetType) async {
    await Kernel.getInstance.applyJoinTeam(JoinTeamModel(
      id: targetId,
      teamType: targetType.label,
      targetId: super.target.id,
      targetType: super.target.typeName,
    ));
  }

  /// 删除好友
  removeFriends(List<String> targetIds) async {
    await remove(targetType: TargetType.person.label, targetIds: targetIds);
    _joinedFriends.removeWhere((item) => targetIds.contains(item.target.id));
  }

  /// 解散群组

  /// 退出群组，当前空间只加载当前空间的群组，如果不是退出当前空间的群组
  /// 那么尝试退出群组
  exitCohort(String cohortId) async {
    for (var joinedCohort in joinedCohorts) {
      if (joinedCohort.target.id == cohortId) {
        await exit(
            targetType: joinedCohort.target.typeName, targetId: cohortId);
        _joinedCohorts.remove(joinedCohort);
        return;
      }
    }
  }

  /// 退出单位
  exitCompany(String companyId) async {
    for (var joinedCompany in joinedCompanies) {
      if (joinedCompany.target.id == companyId) {
        await exit(
            targetType: joinedCompany.target.typeName, targetId: companyId);
        joinedCompanies.remove(joinedCompany);
        if (currentCompany.target.id == companyId) {
          await changeSpaces(selfCompany);
        }
        return;
      }
    }
  }

  /// 获取加入的群组列表
  Future<void> loadJoinedCohorts() async {
    if (_joinedCohorts.isNotEmpty) {
      return;
    }
    var cohorts = await _getJoinedCohorts();
    for (var targetCohort in cohorts) {
      _joinedCohorts.add(Cohort(targetCohort));
    }
  }

  /// 刷新加载的单位列表
  Future<void> refreshJoinedCohorts() async {
    _joinedCohorts.clear();
    var cohorts = await _getJoinedCohorts();
    for (var targetCohort in cohorts) {
      _joinedCohorts.add(Cohort(targetCohort));
    }
  }

  /// 获取加入的组织
  Future<List<Target>> _getJoinedCohorts() async {
    PageResp<Target> cohorts = await getJoined(
      spaceId: super.target.id,
      joinTypeNames: [TargetType.cohort, TargetType.jobCohort],
    );
    return cohorts.result;
  }

  /// 刷新加载的单位列表
  Future<void> refreshJoinedCompanies() async {
    _joinedCompanies.clear();
    List<Target> companies = await _getJoinedCompanies();
    for (var targetCompany in companies) {
      _addCompany(targetCompany);
    }
  }

  /// 加载加入的单位列表
  Future<void> loadJoinedCompanies() async {
    if (_joinedCompanies.isNotEmpty) {
      return;
    }
    List<Target> companies = await _getJoinedCompanies();
    for (var targetCompany in companies) {
      _addCompany(targetCompany);
    }
  }

  /// 获取加入的组织
  Future<List<Target>> _getJoinedCompanies() async {
    PageResp<Target> companies = await getJoined(
      spaceId: super.target.id,
      joinTypeNames: companyTypes,
    );
    return companies.result;
  }

  /// 创建对象
  Future<Target> _createCohort(TargetModel target) async {
    target.belongId = super.target.id;
    target.typeName = TargetType.cohort.label;
    if (_currentCompany.value != null) {
      var companyTarget = _currentCompany.value!.target;
      target.belongId = companyTarget.id;
      target.typeName = TargetType.jobCohort.label;
    }
    return await Kernel.getInstance.createTarget(target);
  }

  /// 添加一个 company
  Company _addCompany(Target companyTarget) {
    late Company company;
    if (companyTarget.typeName == TargetType.university.name) {
      company = University(companyTarget);
    } else if (companyTarget.typeName == TargetType.hospital.name) {
      company = Hospital(companyTarget);
    } else {
      company = Company(companyTarget);
    }
    _joinedCompanies.add(company);
    return company;
  }
}
