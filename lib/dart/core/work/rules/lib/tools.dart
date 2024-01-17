import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/rules/base/ruleBase.dart';
import 'package:orginone/dart/core/work/rules/base/ruleClass.dart';
import 'package:orginone/dart/core/work/rules/lib/const.dart';
import 'package:orginone/main_bean.dart';

// import { DataType } from 'typings/globelType';
// import { RuleTypes } from '../type';
// import { IRuleBase } from '../base/ruleBase';
// import { RuleTriggers } from '../../../public';
// import { FormulaRule, MethodRule } from '../base/ruleClass';
// import { FixedCharacters, RuleType } from './const';
// import OrgCtrl from '../../../../controller';
// import dayjs from 'dayjs';

//去重函数
List uniqueArray(dynamic array) {
  var isArray = array is List;
  if (!isArray) {
    //不是数组则返回空数组
    return [];
  }
  var result = <dynamic>{};
  for (var ele in array) {
    result.add(ele);
  }
  return result.toList();
}

//获取规则字符串中所有特殊字符，默认为「」
Iterable<RegExpMatch> getAllSpecialCharacter(String str,
    [String reg = r"「(.*?)」"]) {
  RegExp re = RegExp(reg);
  return re.allMatches(str);
}

//获取特殊字符中的内容，默认为「」
RegExpMatch? getSpecialChartcterContent(String str, [String reg = r'「(.*?)」']) {
  RegExp re = RegExp(reg);
  var match = re.allMatches(str);
  //如果匹配成功则返回匹配到的内容
  //如果未找到匹配的内容，则返回 null 或其他自定义的值
  return match.first;
}

class BaseObj {
  late String name;
  late String code;
  late String id;
}

//通过name获取特性对应的id
String? findKeyByName(
  String name,
  List<BaseObj> ObjArr,
) {
  return ObjArr.singleWhere((v) => v.name == name).id;
}

//过滤对象里的空值
Map<String, dynamic> removeNullObj(Map<String, dynamic> data) {
  Map<String, dynamic> obj = {};
  data.forEach((key, value) {
    if (data[key] != null) {
      obj[key] = data[key];
    }
  });
  return obj;
}

//根据触发条件过滤规则
List<IRuleBase> filterRules(
  List<IRuleBase> rules, //规则数组
  RuleTriggers trigger, //触发条件
  [
  dynamic changeObj = 'all',
] //表单数据变化的对象，选填，默认为 undefined
    ) {
  List<IRuleBase> waitTask = []; //将要处理的规则数组

  switch (trigger) {
    case RuleTriggers.start:
    case RuleTriggers.thingsChanged:
    case RuleTriggers.submit:
      //如果触发条件是 "Start" 或 "ThingsChanged"，则过滤出规则的 trigger 属性等于该条件的规则
      waitTask = rules.where((item) => item.trigger == trigger).toList();
      break;
    case RuleTriggers.running:
      {
        String changeId = '';
        if (changeObj) {
          changeId = changeObj == 'all' ? '0' : changeObj[0];
        }

        //如果触发条件是 "Running"，则过滤出规则的 trigger 属性等于该条件并且与表单数据变化对象有关联的规则
        waitTask = rules.where((item) {
          if (changeId == '0') {
            return item.trigger == trigger;
          } else {
            return (item.linkAttrs.any((v) => v.id == changeId) &&
                item.trigger == trigger);
          }
        }).toList();
      }
      break;

    default:
      break;
  }
  return waitTask;
}

// 获取表单的规则
var setFormRules = (List<dynamic> ruleList) {
  List list = [];

  // 遍历所有规则，根据规则类型创建不同的规则对象
  for (var r in ruleList) {
    switch (r.ruleType) {
      case RuleType.FORMULA:
        list.add(FormulaRule(r));
        break;
      case RuleType.METHOD:
        list.add(MethodRule(r));
        break;
      default:
        stderr.writeln('暂不支持规则类型：' + r.ruleType);
        break;
    }
  }

  return list;
};

//定义replaceString函数，接收3个参数：ruleStr, formData, attrs
Future<String> replaceString(
  String ruleStr,
  Map<String, dynamic> formData,
  List<dynamic> attrs,
) async {
  //将ruleStr中的特殊字符「」 提取出来，放到一个数组中，用uniqueArray去重
  var AttrSet = uniqueArray(getAllSpecialCharacter(ruleStr));
  Future<String> replacedStr;
  //定义一个数组用来存储缺少的属性
  List<String> missingAttrs = [];
  //一、判断是否有限定字符FixedCharacters，替换所有限定字符为对应数据值
  replacedStr = fixedCharacterResolver(ruleStr);
  //二、替换所有表单特性为对应数据值 使用reduce对AttrSet数组进行遍历和处理,
  replacedStr = formAttrResolver(
    ruleStr,
    AttrSet.where((v) => !FixedCharacters.contains(v)).toList(),
    formData,
    attrs,
    missingAttrs,
  );
  //三、根据已有数据 执行内部函数，获取对应数据,
  //TODO:
  //如果missingAttrs数组中有缺少的属性，打印错误信息并返回空字符串
  if (missingAttrs.isNotEmpty) {
    stderr.writeln(
      '公式处理失败：${missingAttrs.map((item) => '$item数据缺失').join('、')}',
    );
    return '';
  }

  //如果没有缺少的属性，返回替换后的字符串
  return replacedStr;
}

/* 表单特性处理 */
var formAttrResolver = (
  String ruleStr,
  List<dynamic> ruleAttrs,
  Map<String, dynamic> formData,
  List<dynamic> formAttr,
  List<String> missingAttrs,
) async {
  if (ruleStr == null) {
    return '';
  }
  var replacedStr = ruleAttrs
      .map((_str) => getSpecialChartcterContent(_str))
      .reduce((ruleContent, item) {
    //在attrs数组中查找是否有name等于item的对象
    var attrObj = formAttr.singleWhere((v) => v.name == item);

    //如果没找到，则将item加入到missingAttrs数组中，返回ruleContent
    if (attrObj.isNotEmpty) {
      missingAttrs.add(item!.toString());
      return ruleContent;
    }

    //如果找到了，从formData中获取该属性的值
    var attrValue = formData[attrObj.id];

    //如果有值，则使用属性值替换掉规则字符串中的「item」，返回替换后的结果
    if (attrValue && ruleContent != null) {
      // return ruleContent.toString().replaceAll('「$item」', attrValue);
      return ruleContent;
    } else {
      //如果没有值，将item加入到missingAttrs数组中，返回ruleContent
      missingAttrs.add(item!.toString());
      return ruleContent;
    }
  });

  return replacedStr.toString() ?? '';
};

/* 固定字符处理 */
var fixedCharacterResolver = (String ruleStr) async {
  // var _company = (await import('../workFormRules')).default.companyMeta;
  var company;
  if (ruleStr == null) {
    return '';
  }
  //一、判断是否有限定字符FixedCharacters，替换所有限定字符为对应数据值
  //将FixedCharacters数组转化为一个正则表达式，匹配规则字符串中的所有固定字符，并将其替换为对应的数据值
  var fixedRegex = RegExp(r"(${FixedCharacters.join('|')})");
  var replacedStr = ruleStr.replaceAllMapped(fixedRegex, (char) {
    switch (char[1]) {
      case '「单位名称」':
        return company.name;
      case '「单位编码」':
        return company.id;
      case '「使用人名称」':
        return relationCtrl.user.metadata.name ?? "";
      case '「使用人编码」':
        return relationCtrl.user.metadata.id;
      case '「系统时间」':
        return '${DateTime.new}';
      default:
        return '';
    }
  });
  return replacedStr ?? '';
};

/// 获取html文本中的字符串
var parseHtmlToText = (String html) {
  var text = html.replaceAll(RegExp(r'\s*'), ''); //去掉空格
  text = text.replaceAll(RegExp(r'<[^>]+>'), ''); //去掉所有的html标记
  text = text.replaceAll(RegExp(r'↵'), ''); //去掉所有的↵符号
  return text.replaceAll(RegExp(r'[\r\n]'), ''); //去掉回车换行
};

/// 获取文件的实际地址
String shareOpenLink(String? link, [bool download = false]) {
  if (link!.startsWith('/orginone/kernel/load/')) {
    return download
        ? '${Constant.host}$link?download=1'
        : '${Constant.host}$link';
  }
  return '${Constant.host}/orginone/kernel/load/$link${download ? '?download=1' : ''}';
}

/// @description: 聊天间隔时间
/// @param {moment} chatDate
/// @return {*}
String showChatTime(String chatDate) {
  DateTime? cdate = DateUtil.getDateTime(chatDate);
  var days = DateTime.now().difference(cdate!).inDays;
  switch (days) {
    case 0:
      return DateUtil.formatDateStr(chatDate, format: 'HH:mm:ss');
    case 1:
      return '昨天 ${DateUtil.formatDateStr(chatDate, format: 'HH:mm:ss')}';
    case 2:
      return '前天 ${DateUtil.formatDateStr(chatDate, format: 'HH:mm:ss')}';
  }
  var year = DateTime.now().year - cdate.year;
  if (year == 0) {
    return DateUtil.formatDateStr(chatDate, format: 'MM月dd日 HH:mm');
  }
  return DateUtil.formatDateStr(chatDate, format: 'yy年 MM月dd日 HH:mm');
}
