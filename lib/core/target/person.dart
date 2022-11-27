import 'package:get/get.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
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
      : _selfCompany = Company(target..name = "个人空间"),
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

  /// 设置当前工作空间
  setCurrentCompany(String companyId) {
    for (var company in _joinedCompanies) {
      if (company.target.id == companyId) {
        _currentCompany.value = company;
        return;
      }
    }
    _currentCompany.value = _selfCompany;
  }

  /// 创建群组
  createCohort({
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
    await remove(targetType: TargetType.person, targetIds: targetIds);
    _joinedFriends.removeWhere((item) => targetIds.contains(item.target.id));
  }

  /// 退出群组
  exitCohort(List<String> targetIds) async {
    await remove(targetType: TargetType.cohort, targetIds: targetIds);
    _joinedCohorts.removeWhere((item) => targetIds.contains(item.target.id));
  }

  /// 获取加入的群组列表
  Future<void> loadJoinedCohorts() async {
    if (_joinedCohorts.isNotEmpty) {
      return;
    }
    PageResp<Target> cohorts = await getJoined(
      spaceId: super.target.id,
      joinTypeNames: [TargetType.cohort],
    );
    for (var targetCohort in cohorts.result) {
      _joinedCohorts.add(Cohort(targetCohort));
    }
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
  _getJoinedCompanies() async {
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
