/* 定义特殊字符 */

final List<String> FixedCharacters = [
  '「单位名称」',
  '「单位编码」',
  '「使用人名称」',
  '「使用人编码」',
  '「系统时间」',
  '「」',
];

// 定义规则类型常量
enum RuleType {
  FORMULA('formula'),
  METHOD('method');

  const RuleType(this.name);

  final String name;

  static String getName(RuleType opreate) {
    return opreate.name;
  }
}
