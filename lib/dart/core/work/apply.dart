import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main_base.dart';

abstract class IWorkApply {
  /// 办事空间
  late IBelong belong;

  /// 元数据
  late WorkInstanceModel metadata;

  /// 实例携带的数据
  late InstanceDataModel instanceData;

//TODO 需要新增
  /// 业务规则触发器
  // late WorkFormRulesType ruleService;

  /// 发起申请
  Future<bool> createApply(
    String applyId,
    String content,
    Map<String, FormEditData> fromData,
  );
}

class WorkApply implements IWorkApply {
  WorkApply(
    this.metadata,
    this.instanceData,
    this.belong,
    this.forms,
  );

  @override
  late WorkInstanceModel metadata;
  @override
  late InstanceDataModel instanceData;
  @override
  late IBelong belong;

  final List<IForm> forms;

  @override
  Future<bool> createApply(String applyId, String content,
      Map<String, FormEditData> fromData) async {
    fromData.forEach((key, data) {
      instanceData.data?[key] = [data];
    });

    WorkInstanceModel workInstanceModel =
        WorkInstanceModel.fromJson(metadata.toJson());

    workInstanceModel.applyId = applyId;
    workInstanceModel.content = content;
    workInstanceModel.contentType = 'Text';
    workInstanceModel.data = jsonEncode(instanceData.toJson());
    final res = await kernel.createWorkInstance(workInstanceModel);

    return res.success;
  }
}
