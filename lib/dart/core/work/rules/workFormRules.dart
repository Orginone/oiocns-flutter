import 'dart:convert';

import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/work/rules/base/enum.dart';
import 'package:orginone/dart/core/work/rules/lib/tools.dart';
import 'package:orginone/dart/core/work/rules/type.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/log/log_util.dart';
import 'package:orginone/utils/toast_utils.dart';

// import OrgCtrl from '../../../controller';

// import { Emitter } from '../../..//base/common';
// import { sleep } from '../../../base/common';
// import { RuleTypes } from './type.d';
// // import { IRuleBase } from './base/ruleBase';
// // import { debounce } from '@/utils/tools';
// import { DataType } from 'typings/globelType';
// import { filterRules, setFormRules } from './lib/tools';
// import * as Tools from './lib';
// import { RuleTriggers } from '../../public';
// import { EffectEnum } from './base/enum';
// import { XEntity } from '../../..//base/schema';
// import { IBelong } from '../../target/base/belong';
// import { model } from '../../..//base';

// 定义表单规则的类型
abstract class WorkFormRulesType {
  /* 是否完成 */
  late bool isReady;
  /* 办事归属权 */
  late XEntity companyMeta;
  /* 当前选中 主表的id标识 */
  late String currentMainFormId;
  // /* 初始化规则*/
  // late Function(List<dynamic> forms, IBelong belone) initRules;
  // /* 加载远程规则*/
  // late Function(String path) loadRemoteRules;
  // /* 处理表单规则*/
  // late Function(
  //   RuleTypes trigger,
  //   Map<String, String> formData,
  //   Map<String, dynamic>? changeObj, //变动项
  // ) waitingTask;
  // /* 收集关键数据  = 'formsType' | 'hotData' | 'formCallBack'*/
  // late Function(String type, dynamic data) collectData;
  // /* 执行所有表单的最终提交规则 Map<String, FormEditData>*/
  // late Function(
  //   FormData formData,
  // ) handleSubmit;
}

class WorkFormRules extends Emitter implements WorkFormRulesType {
  WorkFormRules() {
    companyMeta = {} as XEntity;
    currentMainFormId = '';
  }
  // 当前主表id
  @override
  late String currentMainFormId;
  // 是否所有规则都已加载完毕
  @override
  bool isReady = false;
  // 单位信息
  @override
  late XEntity companyMeta;
  // 所有表单规则
  Map<String, MapType> _AllFormRules = {};
  // 所有表单id，对应的主子表信息
  Map<String, List<String>> _FormsTypeMap = {};
  /* 当前办事所有表单数据 */
  Map<String, FormEditData> _hotData = {};

  // 初始化表单规则
  initRules(List<dynamic> forms, IBelong belone) {
    _clearData();
    // var companyMeta = belone.metadata.belong as XEntity;
    var count = 0;
    // 遍历每个表单，获取其中的规则
    for (var formItem in forms) {
      var jsonObj = json.decode(formItem.metadata?.rule ?? '{}');
      var ruleList = jsonObj.list ?? [];
      // 将表单的规则存入 _AllFormRules 中
      _AllFormRules.putIfAbsent(
          formItem.id,
          {
            "rules": setFormRules(ruleList),
            "attrs": formItem.fields,
            "callback": null,
          } as MapType Function());
      count++;

      // 如果所有的表单规则已经全部加载完毕，将 isReady 设为 true，并通知回调
      if (count == forms.length) {
        isReady = true;
        changCallback();
      }
    }
  }

  /* 收集数据 */
  //'formsType' | 'hotData' | 'formCallBack'
  @override
  collectData(
    String type,
    dynamic data,
  ) {
    switch (type) {
      /* 收集主子表信息 */
      case 'formsType':
        for (var key in data) {
          _FormsTypeMap.putIfAbsent(
            key == 'primaryFormIds' ? '主表' : '子表',
            data[key],
          );
        }
        break;
      /* 收集当前表展示信息 */
      case 'hotData':
        _hotData = data as Map<String, FormEditData>;
        break;
      /*   设置表单的回调函数，表单首次渲染时触发 */
      case 'formCallBack':
        {
          var formId = data.formId;
          var callback = data.callback;
          var FormInfo = _AllFormRules[formId]!;
          // 如果该表单没有回调函数，则将该回调函数赋值给它，并执行一个 "Start" 触发器-即表单初始化
          if (FormInfo.callback == null) {
            _AllFormRules.putIfAbsent(
                formId, {FormInfo, callback} as MapType Function());
            waitingTask(
                RuleTriggers.start, {"id": formId, "data": {}} as FormData);
          }
        }
        break;
      default:
        break;
    }
  }

  //TODO: 加载远程的规则库
  @override
  loadRemoteRules(String path) async {
    // await sleep(500);
    LogUtil.d('$path暂无远程规则库');
  }

  /// 触发表单规则的处理
  /// @param trigger 触发方式
  /// @param formData 当前表单数据，用于处理运行中、提交时读取表单数据
  /// @param changeObj 表单操作变化的值
  waitingTask(RuleTriggers trigger, FormData formData,
      [Map<String, dynamic>? changeObj]) async {
    var id = formData.id;
    var data = formData.data;

    // 根据触发类型确定待处理规则所属的表单ID
    var formId = trigger == RuleTriggers.thingsChanged ? currentMainFormId : id;

    if (_AllFormRules.containsKey(formId)) {
      var info = _AllFormRules[formId]!;

      // 构建执行规则所需参数
      var params = {
        "data": data,
        "attrs": info.attrs,
      } as FormData;

      /* 收集子表数据 */
      if (trigger == RuleTriggers.thingsChanged) {
        params.things = _hotData[id]!.after;
      }

      // 执行符合条件的规则，并将结果保存到 resultObj 中
      var resultObj = await renderRules(
        filterRules(info.rules, trigger, changeObj),
        params,
      );
      /* 提交验证直接返回 */
      if (trigger == RuleTriggers.submit) {
        return resultObj;
      }

      // 如果该表单设置了回调函数，则调用回调函数将数据传递给页面
      if (info.callback != null) {
        info.callback!(resultObj as Object);

        /* 若初始化结束，需执行一次运行态规则 */
        if (trigger == RuleTriggers.start) {
          waitingTask(RuleTriggers.running,
              {"id": formId, "data": resultObj} as FormData);
        }
      } else {
        LogUtil.d('未设置回调函数：$formId');
      }
    }
  }

  handleSubmit(Map<String, FormEditData> formData) async {
    var Results = [];
    var forms = _FormsTypeMap['主表'] ?? [];
    for (var item in forms) {
      var params = {"id": item, "data": _hotData[item]?.after[0]} as FormData;
      Results.add(await waitingTask(RuleTriggers.submit, params));
    }

    var subValues = {}; // 提交时赋值
    List<bool> boolArr = []; // 提交时 判断拦截提交
    for (var v in Results) {
      // 提交时赋值
      if (v[0] is Object) {
        subValues = {...subValues, ...v[0]};
      } else {
        // 提交时 判断拦截提交
        boolArr.add(v[0]);
      }
    }
    var changedForm = formData[currentMainFormId];
    if (changedForm != null) {
      formData.putIfAbsent(
          currentMainFormId,
          {
            changedForm,
            {
              "after": [
                {changedForm.after[0], subValues}
              ]
            },
          } as FormEditData Function());
    }
    return {
      "values": formData,
      "success": boolArr.isNotEmpty ? boolArr.any((v) => v == false) : true,
    };
  }

  /// 执行过滤后的最终规则，并返回所有要回显至表单的数据
  /// @param trigger 触发方式
  /// @param formData 当前表单数据，用于处理运行中、提交时读取表单数据
  ///  //TODO:通过增加 权重参数，修改规则执行顺序；当前为 按顺序执行
  renderRules(
    List<dynamic> Rules,
    FormData formData,
  ) async {
    if (Rules.isEmpty) {
      return;
    }
    dynamic resultObj = {};
    if (Rules[0].trigger == RuleTriggers.submit) {
      resultObj = {};
    }
    List<dynamic> other = [];

    // 遍历该表单的所有规则，并执行每一个规则
    // await Promise.all(
    Rules.map((R) async {
      try {
        if (null != relationCtrl.user) {
          // 执行该规则，并将规则返回的数据保存到 res 中
          var res = await R.dealRule({
            "#formData": formData.data, //主表数据
            "#attrs": formData.attrs, //主表所有特性
            "#things": formData.things ?? [], //子表数据
            "#company": companyMeta, //单位信息
            "#user": relationCtrl.user!.metadata, //用户信息
            "tools": {} //Tools, //方法库
          });

          // 如果规则执行成功，则将规则返回的数据合并到 resultObj 中
          if (res.success) {
            // 判断赋值类型
            if (R.effect == EffectEnum.mainVals || !R.effect) {
              if (resultObj is List) {
                resultObj.add(res.data);
              } else {
                resultObj = {resultObj, res.data};
              }
            } else {
              other.add(res);
            }
          }
        } else {
          ToastUtils.showMsg(msg: "用户信息异常，请重新登陆");
        }
      } catch (error) {
        throw Exception('规则解析错误：${R.name}');
      }
    });
    // );

    LogUtil.d('所有规则最终数据结果$Rules===>$resultObj====非赋值操作===》$other');
    return resultObj;
  }

  _clearData() {
    _AllFormRules = <String, MapType>{};
    _FormsTypeMap = <String, List<String>>{};
    _hotData = <String, FormEditData>{};
    companyMeta = {} as XEntity;
    isReady = false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
