import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

/// 可为空的字典
// const INullDict = IDict | null;
/// 可为空的进度回调
// const onProgressType = (double p) => void;

/// 字典系统项接口
abstract class IDict {

  late String belongId;


  /// 加载字典子项
  Future<XDictItemArray> loadDictItems(String id, PageRequest page);

  Future<XDictArray> loadDict(PageRequest page);

  ///
  /// 创建字典
  /// @param data 创建参数

  Future<XDict?> createDict(DictModel data);

  ///
  /// 更新字典
  /// @param data 创建参数

  Future<XDict?> updateDict(DictModel data);

  ///
  /// 创建字典子项
  /// @param data 创建参数

  Future<bool> createItem(DictItemModel data);

  ///
  /// 更新字典子项
  /// @param data 创建参数

  Future<bool> updateDictItem(DictItemModel data);

  ///
  /// 删除字典子项
  /// @param id 子项id

  Future<bool> deleteDictItem(String id);

  ///
  /// 删除字典

  Future<bool> deleteDict(String id);
}
