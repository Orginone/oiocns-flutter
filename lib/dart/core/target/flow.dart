import 'package:./../../base/index.dart';
import 'package:../../base/model.dart';
import 'package:../../base/schema.dart';

class FlowTarget extends BaseTarget{
  schema.XFlowDefine[] defines = [];
  schema.XFlowRelation[] defineRelations = [];
  Future<schema.XFlowDefine[]> getDefines(bool reload) async {
    if (!reload && defines.isNotEmpty) {
      return defines;
    }
    var res = await kernel.queryDefine({ id: this.target.id });

    if (res.success && res.data.result) {
      defines = res.data.result;
    }
    return defines;
  }
  Future<schema.XFlowRelation[]> queryFlowRelation(bool reload) async{
    if (!reload && defineRelations.isNotEmpty) {
      return defineRelations;
    }
    var res = await kernel.queryDefineRelation({
      id: this.target.id,
    });
    if (res.success && res.data.result) {
      defineRelations = res.data.result;
    }
    return defineRelations;
  }
  Future<schema.XFlowDefine> publishDefine(model.CreateDefineReq data) async{
    var res = await kernel.publishDefine({ ...data, belongId: this.target.id });
    if (res.success) {
      if (data.id) {
        defines = defines.filter((a) => {
          a.id != data.id
        });
      }
      defines.add(res.data);
    }
    return res.data;
  }
  Future<bool> deleteDefine(String id) async{
    var res = await kernel.deleteDefine({ id });
    if (res.success) {
      defines = defines.filter((a) => {
        a.id != id
      });
    }
    return res.success;
  }
  Future<schema.XFlowInstance> createInstance(model.FlowInstanceModel) async{
    return (await kernel.createInstance(data)).data;
  }
  Future<schma.XFlowRelation> bindingFlowRelation(model.FlowRelationModel data) async{
    var res = await kernel.createFlowRelation(data);
    if (res.success) {
      defineRelations = defineRelations.filter(
            (a) => a.productId != data.productId || a.functionCode != data.functionCode,
      );
      defineRelations.add(res.data);
    }
    return res.data;
  }
  Future<bool> unbindingFlowRelation(model.FlowRelationModel data) async{
    var res = await kernel.deleteFlowRelation(data);
    if (res.success) {
      defineRelations = defineRelations.filter(
            (a) => a.productId != data.productId || a.functionCode != data.functionCode,
      );
    }
    return res.success;
  }
}