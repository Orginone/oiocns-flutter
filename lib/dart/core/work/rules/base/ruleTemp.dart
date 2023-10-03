import 'package:orginone/dart/core/work/rules/base/ruleBase.dart';

// import RuleBase, { IRuleBase } from './ruleBase';
abstract class IRuleTemp extends IRuleBase {
  /* 模板名称 */
  @override
  late String name;
  /* 规则执行函数构造器 */
  String Function(List<dynamic> attrs)? creatFun;
  /* 备注 */
  @override
  late String remark;
}

/* 规则基础数据模型 */
class RuleTemp extends RuleBase implements IRuleBase {
  RuleTemp(dynamic data) : super(data);

  ///@desc 处理模板为规则规则
  @override
  Future<dynamic> dealRule(Map<String, dynamic> formData) {
    throw Error.safeToString('Method not implemented.');
  }

  /// @desc 加载外部规则库文件/模板规则
  Future<dynamic> loadRemoteRules() async {
    // await sleep(2000);
    // return {
    //   name: '测试加载外部模板',
    //   creatFun: () => '',
    //   content: '',
    //   remark: '',
    // };
  }

  ///@desc 使用模板生成规则函数
  String generateRule() {
    throw Error.safeToString('Method not implemented.');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
