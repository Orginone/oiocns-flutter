import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/model.dart';

import 'idict.dart';

abstract class ISpeciesItem {
  /// 主键,唯一
  late String id;

  /// 名称
  late String name;

  /// 标准分类项对应的目标
  late XSpecies target;

  /// 上级标准分类项
  late ISpeciesItem? parent;

  /// 下级标准分类项数组
  late List<ISpeciesItem> children;

  /// 归属信息
  late TargetShare belongInfo;

  /// 加载信息
  Future<ISpeciesItem> loadInfo(TargetShare info);

  /// 加载分类特性
  Future<XAttributeArray> loadAttrs(String id, PageRequest page);

  /// 加载业务标准
  Future<XOperationArray> loadOperations(String id, PageRequest page);

  ///
  /// 创建标准分类项
  /// @param data 创建参数

  Future<ISpeciesItem?> create(SpeciesModel data);

  ///
  /// 创建字典
  /// @param data 创建参数

  Future<IDict?> createDict(DictModel data);

  ///
  /// 更新字典
  /// @param data 创建参数

  Future<bool> updateDict(DictModel data);

  ///
  /// 删除字典
  /// @param id 特性项id

  Future<bool> deleteDict(String id);

  ///
  /// 更新标准分类项
  /// @param data 创建参数

  Future<ISpeciesItem> update(SpeciesModel data);

  ///
  /// 创建分类特性项
  /// @param data 创建参数

  Future<bool> createAttr(AttributeModel data);

  ///
  /// 更新分类特性项
  /// @param data 创建参数

  Future<bool> updateAttr(AttributeModel data);

  ///
  /// 删除分类特性项
  /// @param id 特性项id

  Future<bool> deleteAttr(String id);

  ///
  /// 创建业务标准
  /// @param data 创建参数

  Future<bool> createOperation(OperationModel data);

  ///
  /// 更新业务标准
  /// @param data 创建参数

  Future<bool> updateOperation(OperationModel data);

  ///
  /// 删除业务标准
  /// @param id 特性项id

  Future<bool> deleteOperation(String id);

  ///
  /// 删除标准分类项

  Future<bool> delete();
}
