enum TargetType {
  person("人员"),
  company("单位"),
  cohort("群组"),
  department("部门");

  const TargetType(this.label);

  final String label;

  static String getName(TargetType targetType) {
    return targetType.label;
  }
}
