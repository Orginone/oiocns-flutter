import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';

import 'dictclass.dart';

abstract class IDict{
  //数据实体
  late XDict metadata;
  //加载权限的自归属用户
  late DictClass species;
  //共享信息
  late  TargetShare share;
  //字典项
  late List<XDictItem> items;

  //更新字典
  Future<bool> update(DictModel data);
  //删除字典
  Future<bool> delete();
  //加载字典项
  Future<List<XDictItem>> loadItems({bool reload = false});
  //新增字典项
  Future<XDictItem?> createItem(DictItemModel data);
  //删除字典项
  Future<bool> deleteItem(XDictItem item);
  //更新字典项
  Future<bool> updateItem(DictItemModel data);
}

class Dict  implements IDict{

  Dict(this.metadata,this.species){
    items = [];
    share = TargetShare(name: metadata.name??"", typeName: '字典',avatar: FileItemShare.parseAvatar(metadata.icon));
    ShareIdSet[metadata.id!]=share;
  }
  @override
  late List<XDictItem> items;

  @override
  late XDict metadata;

  @override
  late TargetShare share;

  @override
  late DictClass species;

  @override
  Future<XDictItem?> createItem(DictItemModel data) async{
    data.dictId = metadata.id;
    final res = await kernel.createDictItem(data);
    if (res.success && res.data?.id != null) {
      items.add(res.data!);
      return res.data!;
    }
    return null;
  }

  @override
  Future<bool> delete() async{
    final res = await kernel.deleteDict(IdReq(id: metadata.id!));
    if (res.success) {
      species.propertyChanged('deleted', [this]);
    }
    return res.success;
  }

  @override
  Future<bool> deleteItem(XDictItem item) async{
    final res = await kernel.deleteDictItem(IdReq(id: item.id));
    if (res.success) {
      items.removeWhere((i) => i.id == item.id);
    }
    return res.success;
  }

  @override
  Future<List<XDictItem>> loadItems({bool reload = false}) async{
    if (items.isEmpty || reload) {
      final res = await kernel.queryDictItems(IdReq(id: metadata.id!));
      if (res.success) {
        items = res.data?.result ?? [];
      }
    }
    return items;
  }

  @override
  Future<bool> update(DictModel data) async{
    data.id = metadata.id;
    data.speciesId = species.metadata.id;
    final res = await kernel.updateDict(data);
    if (res.success && res.data?.id != null) {
      metadata = res.data!;
    }
    return res.success;
  }

  @override
  Future<bool> updateItem(DictItemModel data) async{
    data.dictId = metadata.id;
    final res = await kernel.updateDictItem(data);
    if (res.success) {
      items.removeWhere((i) => i.id == data.id);
      items.add(res.data!);
    }
    return res.success;
  }

}