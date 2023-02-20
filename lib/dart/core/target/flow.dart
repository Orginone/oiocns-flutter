import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/itarget.dart';

import '../../base/schema.dart';
import 'base.dart';

class FlowTarget extends BaseTarget implements IFlow {
  late List<XFlowRelation> defineRelations;
  FlowTarget(XTarget target) : super(target);
  @override
  Future<List<XFlowDefine>> getDefines({bool reload = false}) async {
    if (!reload && defines.isNotEmpty) {
      return defines;
    }

    final res = await kernel.queryDefine(IdReq(id: target.id));
    if (res.success && res.data?.result != null) {
      defines = res.data!.result!;
    }
    return defines;
  }

  @override
  Future<List<XFlowRelation>> queryFlowRelation({bool reload = false}) async {
    if (!reload && defineRelations.isNotEmpty) {
      return defineRelations;
    }
    final res = await kernel.queryDefineRelation(IdReq(id: id));
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
  Future<XFlowRelation?> bindingFlowRelation(FlowRelationModel data) async {
    final res = await kernel.createFlowRelation(data);
    if (res.success) {
      defineRelations = defineRelations
          .where(
            (a) =>
                a.productId != data.productId ||
                a.functionCode != data.functionCode,
          )
          .toList();
      if (res.data != null) {
        defineRelations.add(res.data!);
      }
    }
    return res.data;
  }

  @override
  Future<bool> unbindingFlowRelation(FlowRelationModel data) async {
    final res = await kernel.deleteFlowRelation(data);
    if (res.success) {
      defineRelations = defineRelations
          .where(
            (a) =>
                a.productId != data.productId ||
                a.functionCode != data.functionCode,
          )
          .toList();
    }
    return res.success;
  }

  @override
  late List<XFlowDefine> defines;
}
