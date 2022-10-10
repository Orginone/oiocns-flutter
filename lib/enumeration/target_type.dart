enum TargetType {
  person("人员"),
  company("单位"),
  cohort("群组"),
  department("部门");

  const TargetType(this.name);

  final String name;

  static String getName(TargetType targetType) {
    return targetType.name;
  }
}
