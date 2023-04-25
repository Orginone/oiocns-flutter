import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/itarget.dart';

import '../../base/common/uint.dart';
import '../../base/schema.dart';
import 'base.dart';

class FlowTarget extends BaseTarget implements IFlow {
  late List<XOperation> defineRelations;
  FlowTarget(XTarget target,ISpace? space,) : super(target,space);
  @override
  Future<List<XFlowDefine>> getDefines({bool reload = false}) async {
    if (!reload && defines.isNotEmpty) {
      return defines;
    }

    final res = await kernel.queryDefine(QueryDefineReq(
        spaceId: target.id,
        speciesId: '',
        page: PageRequest(
          offset: 0,
          filter: "",
          limit: Constants.maxUint16,
        )));
    if (res.success && res.data?.result != null) {
      defines = res.data!.result!;
    }
    return defines;
  }

  @override
  Future<List<XOperation>> queryFlowRelation({bool reload = false}) async {
    if (!reload && defineRelations.isNotEmpty) {
      return defineRelations;
    }
    final res = await kernel.queryDefineRelation(IDBelongReq(id: id));
    if (res.success && res.data?.result != null) {
      defineRelations = res.data!.result!;
    }
    return defineRelations;
  }

  @override
  Future<XFlowDefine?> publishDefine(CreateDefineReq data) async {
    data.belongId = id;
    final res = await kernel.publishDefine(data);
    if (res.success) {
      if (data.id != '') {
        defines = defines.where((a) => a.id != data.id).toList();
      }
      if (res.data != null) {
        defines.add(res.data!);
      }
    }
    return res.data;
  }

  @override
  Future<bool> deleteDefine(String id) async {
    final res = await kernel.deleteDefine(IdReq(id: id));
    if (res.success) {
      defines = defines.where((a) => a.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<XFlowInstance?> createInstance(FlowInstanceModel data) async {
    final res = await kernel.createInstance(data);
    return res.data;
  }

  @override
  Future<bool> bindingFlowRelation(FlowRelationModel data) async {
    final res = await kernel.createFlowRelation(data);
    return res.success;
  }

  @override
  late List<XFlowDefine> defines;
}
