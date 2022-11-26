import 'package:get/get.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/core/target/base_target.dart';
import 'package:orginone/core/target/cohort.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/target/hospital.dart';
import 'package:orginone/core/target/university.dart';

class Person extends BaseTarget {
  final Rx<Company?> _currentCompany = Rxn();
  final RxList<Company> _joinedCompanies = <Company>[].obs;
  final RxList<Cohort> _joinedCohorts = <Cohort>[].obs;

  Person(super.target);

  List<TargetType> get companyTypes => <TargetType>[
        TargetType.company,
        TargetType.university,
        TargetType.hospital,
      ];

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
    Cohort cohort = Cohort(await _create(targetModel));
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
    TargetModel targetModel = TargetModel(
        name: name,
        code: code,
        teamName: teamName,
        teamCode: teamCode,
        typeName: type.label,
        teamRemark: teamRemark);
    Target target = await _create(targetModel);
    late Company company;
    if (target.typeName == TargetType.university.name) {
      company = University(target);
    } else if (target.typeName == TargetType.hospital.name) {
      company = Hospital(target);
    } else {
      company = Company(target);
    }
    _joinedCompanies.add(company);
    await company.pullPersons([super.target.id]);
  }

  Future<Target> _create(TargetModel target) async {
    target.belongId = super.target.id;
    target.typeName = super.target.typeName;
    if (_currentCompany.value != null) {
      var companyTarget = _currentCompany.value!.target;
      target.belongId = companyTarget.id;
      target.typeName = companyTarget.typeName;
    }
    return await kernelApi.createTarget(target);
  }
}
