import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';

import 'species.dart';


abstract class IWorkDefine {
  /// 办事分类
  late IWork workItem;

  /// 数据
  late XWorkDefine metadata;

  /// 共享信息
  late TargetShare share;

  /// 更新办事定义
  Future<bool> updateDefine(WorkDefineModel data);

  /// 加载事项定义节点
  Future<WorkNodeModel?> loadWorkNode();

  /// 删除办事定义
  Future<bool> deleteDefine();

  /// 删除办事实例
  Future<bool> deleteInstance(String id);

  /// 新建办事实例
  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data);
}

class FlowDefine  implements IWorkDefine{

  FlowDefine(this.metadata,this.workItem){
    share =  TargetShare(name: metadata.name??"", typeName: '办事项',avatar: FileItemShare.parseAvatar(metadata.icon));
  }

  @override
  late XWorkDefine metadata;

  @override
  late TargetShare share;

  @override
  late IWork workItem;

  @override
  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data) async{
    return (await kernel.createWorkInstance(data)).data;
  }

  @override
  Future<bool> deleteDefine() async{
    final res = await kernel.deleteWorkDefine(IdReq(id: metadata.id!));
    if (res.success) {
      workItem.defines.removeWhere((a) => a.metadata.id == metadata.id);
    }
    return res.success;
  }

  @override
  Future<bool> deleteInstance(String id) async{
    return (await kernel.recallWorkInstance(IdReq(id: id))).success;
  }

  @override
  Future<WorkNodeModel?> loadWorkNode() async{
    final res = await kernel.queryWorkNodes(IdReq(id: metadata.id!));
    if (res.success) {
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> updateDefine(WorkDefineModel data) async{
    data.shareId = workItem.current.metadata.id;
    data.speciesId = metadata.speciesId;
    final res = await kernel.createWorkDefine(data);
    if (res.success && res.data != null) {
      metadata = res.data!;
    }
    return res.success;
  }

}

abstract class IWork extends ISpeciesItem {
  //流程定义
  late List<IWorkDefine> defines;

  //加载所有可选表单
  Future<List<XForm>> loadForms();

  //表单特性
  Future<List<XAttribute>> loadAttributes();

  //加载办事
  Future<List<IWorkDefine>> loadWorkDefines({bool reload = false});

  //新建办事
  Future<IWorkDefine?> createWorkDefine(WorkDefineModel data);

}

abstract class Work extends SpeciesItem implements IWork {
  Work(super.metadata, super.current,[super.parent]){
    defines = [];
  }

  @override
  late List<IWorkDefine> defines;

  @override
  Future<List<IWorkDefine>> loadWorkDefines({bool reload = false}) async{
    if (defines.isEmpty || reload) {
      final res = await kernel.queryWorkDefine(GetSpeciesResourceModel(id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        defines = (res.data?.result ?? []).map((e) => FlowDefine(e,this)).toList();
      }
    }
    return defines;
  }

  @override
  Future<IWorkDefine?> createWorkDefine(WorkDefineModel data) async{
    data.shareId = current.metadata.id;
    data.speciesId = metadata.id;
    final res = await kernel.createWorkDefine(data);
    if (res.success && res.data != null) {
      var flow = FlowDefine(res.data!, this);
      defines.add(flow);
      return flow;
    }
    return null;
  }
}