import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

/// 可为空的字典
// const INullDict = IDict | null;
/// 可为空的进度回调
// const onProgressType = (double p) => void;

/// 字典系统项接口
abstract class IDict {
  // 主键,唯一
  late String id;
  // 名称
  late String name;
  // 字典对应的目标
  late XDict target;

  /// 上级字典  用于级联
  /// parent: INullDict;
  /// 下级字典数组 用于级联
  /// children: IDict[];
  /// 归属信息
  late TargetShare? belongInfo;

  /// 加载信息
  Future<IDict> loadInfo(TargetShare info);

  /// 加载字典子项
  Future<XDictItemArray> loadItems(String spaceId, PageRequest page);

  ///
  /// 创建字典
  /// @param data 创建参数

  Future<IDict?> create(DictModel data);

  ///
  /// 更新字典
  /// @param data 创建参数

  Future<IDict> update(DictModel data);

  ///
  /// 创建字典子项
  /// @param data 创建参数

  Future<bool> createItem(DictItemModel data);

  ///
  /// 更新字典子项
  /// @param data 创建参数

  Future<bool> updateItem(DictItemModel data);

  ///
  /// 删除字典子项
  /// @param id 子项id

  Future<bool> deleteItem(String id);

  ///
  /// 删除字典

  Future<bool> delete();
}
