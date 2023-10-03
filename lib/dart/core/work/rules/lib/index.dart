import 'dart:convert';

/* 规则函数库
 * Author:      SEN
 * CreateTime:  7/20/2023, 10:41:42 AM
 * LastEditor:  SEN
 * ModifyTime:  7/26/2023, 11:06:52 AM
 * Description: 用于提供规则函数
 */
/* 相加 */
int add(int a, int b) {
  return a + b;
}

/* 依次相加 */
int sum(List<int> arr) {
  return arr.reduce((acc, val) => acc + val);
}

/* 依次相减 */
int subtractArray(List<int> arr) {
  int result = arr[0];
  for (int i = 1; i < arr.length; i++) {
    result -= arr[i];
  }
  return result;
}

class RouteModel {
  late String? code;
  late String? name;
  late String id;
  late String rule;
}

/* 根据特性code获取特性id */
String findIdByCode(
  String code,
  List<RouteModel> attrs,
) {
  var matchedAttr = attrs.singleWhere((attr) {
    var Data = json.encode(attr.rule ?? '{}') as RouteModel;
    return Data.code == code;
  });

  return matchedAttr != null ? matchedAttr.id : '';
}

/* 根据特性名称获取特性id */

String findIdByName(
  String name,
  List<RouteModel> attrs,
) {
  var matchedAttr = attrs.singleWhere((RouteModel attr) {
    return attr.name == name;
  });
  return matchedAttr != null ? matchedAttr.id : '';
}
