import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/rules/base/enum.dart';
import 'package:orginone/dart/core/work/rules/type.dart';

// import { RuleTypes } from '../type.d';
// import { EffectEnum } from './enum';
/* 基础规则数据类型 */
abstract class IRuleBase {
  /* 规则主键 */
  late String id;
  /* 规则名称 */
  late String name;
  /* 规则类型 */
  late RuleType ruleType;
  /* 触发方式 初始化-修改时-提交时-子表变动后 */
  late RuleTriggers trigger;
  /* 规则支持的数据类型 */
  late List<ValueType>? accept;
  /* 规则关联特性 */
  late List<AttrType> linkAttrs;

  /// 规则执行结果的使用方式
  EffectEnum? effect;
  /* 关联项最大数量 */
  int? max;
  /* 规则是否可扩展关联项 即增加关联数量*/
  bool? isExtend;
  /* 规则错误提示 */
  late String errorMsg;
  /* 规则内容 */
  late String content;
  /* 备注 */
  late String remark;
  // /* 处理规则生成结果 */
  // late Future<dynamic> Function(Map<String, dynamic> formData) dealRule;
}

/* 规则基础数据模型 */
abstract class RuleBase implements IRuleBase {
  /* 规则主键 */
  @override
  String id = '';
  /* 规则名称 */
  @override
  String name = '';
  /* 规则类型 方法-公式*/
  @override
  RuleType ruleType = RuleType.method;
  /* 触发方式 初始化-修改时-提交时 */
  @override
  RuleTriggers trigger = RuleTriggers.start;
  /* 规则支持的数据类型 */
  @override
  var accept = <ValueType>[];
  /* 返回值效果 */
  @override
  EffectEnum? effect;
  /* 规则关联特性 */
  @override
  var linkAttrs = <AttrType>[];
  /* 关联项最大数量 */
  @override
  var max = 5;
  /* 规则是否可扩展关联项 */
  @override
  var isExtend = false;
  /* 错误提示 */
  @override
  String errorMsg = '规则错误！';
  /* 规则执行函数 */
  @override
  String content = '';
  /* 备注 */
  @override
  String remark = '';

  RuleBase(IRuleBase data) {
    /* 对象属性赋值 */
    // Object.assign(this, data);
  }

  /// @desc 处理规则
  /// @param {'Start' | 'Running' | 'Submit'} trigger 触发时机
  /// @param {Object} formData 当前表单数据
  /// @return {} 返回处理结果 {【表单key】：value}
  Future<dynamic> dealRule(Map<String, dynamic> formData);
}
