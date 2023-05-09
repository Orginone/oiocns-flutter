// import '../target/species/idict.dart' show INullDict;
// import {
//   AttributeModel,
//   DictModel,
//   OperationModel,
//   PageRequest,
//   SpeciesModel,
//   TargetShare,
// } from '../../base/model';
// import { XAttributeArray, XOperationArray, XSpecies } from '../../base/schema';

/* 可为空的标准分类 */
// export type INullSpeciesItem = ISpeciesItem | undefined;
/* 可为空的进度回调 */
// export type OnProgressType = (p: number) => void | undefined;
import 'package:orginone/dart/core/target/itarget.dart';

import '../../base/model.dart';
import '../../base/schema.dart';
import 'idict.dart';

/*
 * 标准分类系统项接口
 */
abstract class ISpeciesItem {
  /* 主键,唯一 */
  late String id;
  /* 名称 */
  late String name;
  /* 标准分类项对应的目标 */
  late XSpecies target;
  /* 上级标准分类项 */
  ISpeciesItem? parent;
  /* 下级标准分类项数组 */
  late List<ISpeciesItem> children;
  /* 归属信息 */
  late TargetShare belongInfo;
  /* 属性 */
  late List<XAttribute> attrs;
  /* 表单 */
  late List<XOperation> operation;

  late ITarget team;
  late bool isSelected;

  late String spaceId;

  String get belongId;

  /* 加载信息 */
  Future<ISpeciesItem> loadInfo(TargetShare info);
  /* 加载分类特性 */
  Future<List<XAttribute>> loadAttrs(String id,{bool reload});
  /* 加载业务标准 */
  Future<List<XOperation>> loadOperations(String id, bool filterAuth,
      bool recursionOrg, bool recursionSpecies, PageRequest page,{bool reload = false});
  /* 加载流程设计 */
  Future<XFlowDefineArray> loadFlowDefines(String id, PageRequest page);
  /*
   * 创建标准分类项
   * @param data 创建参数
   */
  Future<ISpeciesItem?> create(SpeciesModel data);
  /*
   * 更新标准分类项
   * @param data 创建参数
   */
  Future<ISpeciesItem> update(SpeciesModel data);
  /*
   * 创建分类特性项
   * @param data 创建参数
   */
  Future<bool> createAttr(AttributeModel data);
  /*
   * 更新分类特性项
   * @param data 创建参数
   */
  Future<bool> updateAttr(AttributeModel data);
  /*
   * 删除分类特性项
   * @param id 特性项id
   */
  Future<bool> deleteAttr(String id);
  /*
   * 创建流程设计
   * @param data 创建参数
   */
  Future<XFlowDefine?> createFlowDefine(CreateDefineReq data);
  /*
   * 更新流程设计
   * @param data 创建参数
   */
  Future<bool> updateFlowDefine(CreateDefineReq data);
  /*
   * 删除流程设计
   * @param id 流程设计id
   */
  Future<bool> deleteFlowDefine(String id);
  /*
   * 创建业务标准
   * @param data 创建参数
   */
  Future<bool> createOperation(OperationModel data);
  /*
   * 更新业务标准
   * @param data 创建参数
   */
  Future<bool> updateOperation(OperationModel data);
  /*
   * 删除业务标准
   * @param id 特性项id
   */
  Future<bool> deleteOperation(String id);
  /*
   * 删除标准分类项
   */
  Future<bool> delete();

  ///加载办事
  Future<List<XFlowDefine>> loadWork({PageRequest? page});

  ///发布办事
  Future<XFlowDefine?> publishWork(CreateDefineReq data);

  ///删除办事
  Future<bool> deleteWork(String id);

  ///查询办事节点
  Future<FlowNode?> loadWorkNode(String id);

  bool isAllLast() {
    if (children.isEmpty) {
      return true;
    }
    return children.where((element) => element.children.isNotEmpty).isEmpty;
  }

  List<ISpeciesItem> getAllList() {
    List<ISpeciesItem> list = [this];

    for (var element in children) {
      list.add(element);
      if (element.children.isNotEmpty) {
        list.addAll(element.getAllLastList());
      }
    }

    return list;
  }

  List<ISpeciesItem> getAllLastList() {
    List<ISpeciesItem> list = [];

    for (var element in children) {
      if (element.children.isEmpty) {
        list.add(element);
      } else {
        list.addAll(element.getAllLastList());
      }
    }

    return list;
  }

}
