import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';

abstract class IWorkApply {
  /// 办事空间
  late IBelong belong;

  /// 元数据
  late WorkInstanceModel metadata;

  /// 实例携带的数据
  late InstanceDataModel instanceData;

  /// 发起申请
  Future<bool> createApply(
    String applyId,
    String content,
    Map<String, FormEditData> fromData,
  );
}

class WorkApply implements IWorkApply{


  WorkApply(this.belong,this.metadata,this.instanceData);

  @override
  late IBelong belong;

  @override
  late InstanceDataModel instanceData;

  @override
  late WorkInstanceModel metadata;

  @override
  Future<bool> createApply(String applyId, String content, Map<String, FormEditData> fromData) async{
    fromData.forEach((key, data) {
      instanceData.data[key] = [data];
    });

    // String data = jsonEncode(instanceData.toJson());
    // print(data);
    // return data==null;
    final res = await kernel.createWorkInstance(
      WorkInstanceModel(
        defineId: metadata.defineId,
        content: content,
        contentType: 'Text',
        data: jsonEncode(instanceData.toJson()),
        childrenData: '',
        applyId: applyId,
        hook: metadata.hook,
        taskId: metadata.taskId,
      ),
    );

    return res.success;
  }

}