// import { IRuleBase } from './base/ruleBase';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/rules/base/ruleBase.dart';

enum RuleType {
  method("method"),
  formula("formula");

  const RuleType(this.type);

  final String type;

  static String getName(RuleType opreate) {
    return opreate.type;
  }
}

// enum AcceptedType {
//   number('数值型'),
//   remark('描述型'),
//   select('选择型'),
//   species('分类型'),
//   file('附件型'),
//   time('时间型'),
//   date('日期型'),
//   target('用户型');

//   const AcceptedType(this.type);

//   final String type;

//   static String getName(RuleType opreate) {
//     return opreate.type;
//   }
// }

// TriggerType = 'Start' | 'Running' | 'Submit' | 'ThingsChanged'

class CallBackType {
  late String formId;
  late Function(dynamic data) callback;
}

class AttrType {
  late String name;
  late String id;
  String? code;
}

class MapType {
  late List<IRuleBase> rules;
  late List<dynamic> attrs;
  Function(dynamic data)? callback;
}

class RuleTypes {
  /* 规则类型 */
  late RuleType ruleType;
  /* 关联特性 */
  late AttrType attrType;
  // 定义表单规则的键值对类型
  late MapType mapType;
  /* 规则支持的数据类型 */
  late ValueType acceptedType;
  /* 规则触发方式 初始化-运行中-提交时-子表变动时*/
  late RuleTriggers triggerType;

  /* 规则运行返回结果类型 */
  late ResultType<dynamic> resultType;
  late Map<String, dynamic> dataType;
/* 表单变化时，返回类型 */
  late CallBackType callBackType;
}
