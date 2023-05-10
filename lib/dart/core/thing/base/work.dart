import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';

import 'species.dart';

abstract class IWork extends ISpeciesItem {
  //流程定义
  late List<XWorkDefine> defines;

  //加载所有可选表单
  Future<List<XForm>> loadForms();

  //表单特性
  Future<List<XAttribute>> loadAttributes();

  //加载办事
  Future<List<XWorkDefine>> loadWorkDefines({bool reload = false});

  //加载办事节点
  Future<WorkNodeModel?> loadWorkNode(String id);

  //新建办事
  Future<XWorkDefine?> createWorkDefine(WorkDefineModel data);

  //新建办事实例
  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data);

  //更新办事
  Future<bool> updateWorkDefine(WorkDefineModel data);

  //删除办事
  Future<bool> deleteWorkDefine(XWorkDefine data);
}

abstract class Work extends SpeciesItem implements IWork {
  Work(super.metadata, super.current,[super.parent]){
    defines = [];
  }

  @override
  late List<XWorkDefine> defines;

  @override
  Future<List<XWorkDefine>> loadWorkDefines({bool reload = false}) async{
    if (defines.isEmpty || reload) {
      final res = await kernel.queryWorkDefine(GetSpeciesResourceModel(id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        defines = res.data?.result ?? [];
      }
    }
    return defines;
  }

  @override
  Future<WorkNodeModel?> loadWorkNode(String id) async{
    return (await kernel.queryWorkNodes(IdReq(id: id))).data;
  }

  @override
  Future<XWorkDefine?> createWorkDefine(WorkDefineModel data) async{
    data.shareId = current.metadata.id;
    data.speciesId = metadata.id;
    final res = await kernel.createWorkDefine(data);
    if (res.success && res.data != null) {
      defines.add(res.data!);
      return res.data;
    }
    return null;
  }

  @override
  Future<XWorkInstance?> createWorkInstance(WorkInstanceModel data) async{
    return (await kernel.createWorkInstance(data)).data;
  }

  @override
  Future<bool> updateWorkDefine(WorkDefineModel data) async{
    final index = defines.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.shareId = current.metadata.id;
      data.speciesId = metadata.id;
      final res = await kernel.createWorkDefine(data);
      if (res.success && res.data?.id != null) {
        defines[index] = res.data!;
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<bool> deleteWorkDefine(XWorkDefine data) async{
    final index = defines.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      final res = await kernel.deleteWorkDefine(IdReq(id:  data.id!));
      if (res.success) {
        defines.removeAt(index);
      }
      return res.success;
    }
    return false;
  }
}