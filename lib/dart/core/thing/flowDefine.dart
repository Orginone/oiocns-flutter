


import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

import 'iflowDefine.dart';

class FlowDefine extends IFlowDefine{

  KernelApi kernel = KernelApi.getInstance();

  FlowDefine(String id){
    belongId = id;
  }

  @override
  Future<bool> deleteDefine(String id) async{
   var result = await kernel.deleteDefine(IdReq(id: id));
   return result.data??false;
  }

  @override
  Future<XFlowDefineArray?> loadFlowDefine(String speciesId) async{
    var result = await kernel.queryDefine(QueryDefineReq(speciesId: speciesId,spaceId: belongId));
    return result.data;
  }

  @override
  Future<XFlowDefine?> publishDefine(CreateDefineReq data) async{
    data.belongId = belongId;
    var result = await kernel.publishDefine(data);
    return result.data;
  }

  @override
  Future<FlowNode?> queryNodes(String id) async{
    var result = await kernel.queryNodes(IdSpaceReq(id: id, spaceId: ''));
    return result.data;
  }

}