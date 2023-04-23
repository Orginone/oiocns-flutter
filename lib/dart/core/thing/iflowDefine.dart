

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

abstract class IFlowDefine{
   late String belongId;


   ///加载办事
   Future<XFlowDefineArray?> loadFlowDefine(String speciesId);

   ///发布办事
   Future<XFlowDefine?> publishDefine(CreateDefineReq data);

   ///删除办事
   Future<bool> deleteDefine(String id);

   ///查询办事节点
   Future<FlowNode?> queryNodes(String id);
}