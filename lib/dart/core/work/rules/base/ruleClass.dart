import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/rules/base/ruleBase.dart';
import 'package:orginone/dart/core/work/rules/lib/tools.dart';
import 'package:orginone/dart/core/work/rules/type.dart';

// import 'ruleClass.dart'{ RuleTriggers } from '../../../public/enums';
// import 'ruleClass.dart'RuleBase, { IRuleBase } from '../base/ruleBase';

// import 'ruleClass.dart'type { RuleTypes } from '../type.d';
// import 'ruleClass.dart'{
//   getSpecialChartcterContent,
//   findKeyByName,
//   replaceString,
//   removeNullObj,
// } from '../lib/tools';
/**
 *@desc 公式类型 规则
  规定 公式取值必须使用「」作为中文字包裹特殊字符
 */

// abstract class FormulaRuleType extends IRuleBase {}
class FormulaRule extends RuleBase {
  FormulaRule(dynamic data) : super(data) {
    ruleType = RuleType.formula;
  }

  @override
  var dealRule_ = ({$formData, $attrs}) async {
    var ruleStr = ''; //content;

    // 切分字符为目标内容和公式内容区
    List<String> roleList = ruleStr.split('=');
    String targetContent = roleList.first, formulaContent = roleList.last;

    // 获取目标键（id）
    String targetKey = findKeyByName(
            getSpecialChartcterContent(targetContent) as String, $attrs) ??
        '';

    if (targetKey == null) {
      return {
        "success": false,
        "data": null,
        "errMsg": '未找到：$targetContent对应特性，请检查',
      };
    }

    try {
      // 处理特殊标记「」
      String resultString = await replaceString(
        formulaContent.trim(),
        $formData,
        $attrs,
      );

      // 最终处理 JavaScript 函数
      dynamic result = ''; //eval(resultString);

      if (result == null) {
        return {"success": false, "data": null, "errMsg": '计算结果非数字'};
      }

      var finalResult = {
        [targetKey]: result,
      };

      return {
        "success": true,
        "data": finalResult,
        "errMsg": '',
      };
    } catch (err) {
      return {"success": false, "data": null, "errMsg": '处理公式有误'};
    }
  };

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// @desc:函数类型 规则
/// 初始化返回结果 data=>{key：value，key2：value2}
/// 运行中返回结果 data=>{key：value，key2：value2}
/// 提交时返回结果 data=>boolean
abstract class MethodRuleData extends IRuleBase {
  late String targetId;
}

class MethodRule extends RuleBase {
  late String targetId;

  MethodRule(MethodRuleData data) : super(data) {
    ruleType = RuleType.method;
    targetId = data.targetId;
  }

  /* 执行js，生成结果 */
  @override
  Future<dynamic> dealRule(dynamic props) async {
    try {
      const data = ''; //eval(this.content)(props);
      var result = await _handleResult(data);
      return {"success": true, "data": result, "errMsg": ''};
    } catch (err) {
      return {"success": false, "data": null, "errMsg": '处理函数有误'};
    }
  }

  /* 处理最终展示结果 */
  Future<Map<String, dynamic>> _handleResult(dynamic resValue) async {
    if (trigger == RuleTriggers.submit) {
      return resValue;
    }

    Map<String, dynamic> data = resValue is Map<String, dynamic>
        ? resValue
        : {}.putIfAbsent(targetId, () => resValue);
    return removeNullObj(data);
  }
}
