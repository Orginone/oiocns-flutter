enum TargetType {
  group("集团"),
  person("人员"),
  cohort("群组"),
  company("单位"),
  college("学院"),
  section("科室"),
  office("办事处"),
  hospital("医院"),
  working("工作组"),
  university("大学"),
  department("部门"),
  research("研究所"),
  jobCohort("工作群"),
  laboratory("实验室");

  const TargetType(this.label);

  final String label;

  static String getName(TargetType targetType) {
    return targetType.label;
  }
}
