import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';

import 'file_info.dart';

abstract class ISpecies implements IFileInfo<XSpecies> {
  /// 类目项
  late List<XSpeciesItem> items;

  /// 更新类目
  Future<bool> update(SpeciesModel data);

  /// 删除类目
  Future<bool> delete();

  /// 加载类目项
  Future<List<XSpeciesItem>> loadItems({bool reload = false});

  /// 新增类目项
  Future<XSpeciesItem?> createItem(SpeciesItemModel data);

  /// 删除类目项
  Future<bool> deleteItem(XSpeciesItem item);

  /// 更新类目项
  Future<bool> updateItem(SpeciesItemModel data);
}

class Species extends FileInfo<XSpecies> implements ISpecies {
  Species(super.metadata, super.directory) {
    items = [];
  }

  @override
  late List<XSpeciesItem> items;

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      var data = FormModel.fromJson(metadata.toJson());
      data.directoryId = directory.id!;
      var res = await destination.createForm(data);
      return res != null;
    }
    return false;
  }

  @override
  Future<XSpeciesItem?> createItem(SpeciesItemModel data) async {
    data.speciesId = id!;
    var res = await kernel.createSpeciesItem(data);
    if (res.success && res.data != null) {
      items.add(res.data!);
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteSpecies(IdReq(id: id!));
    if (res.success) {
      directory.specieses.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<bool> deleteItem(XSpeciesItem item) async {
    var res = await kernel.deleteSpeciesItem(IdReq(id: item.id!));
    if (res.success) {
      items.removeWhere((i) => i.id == item.id);
    }
    return res.success;
  }

  @override
  Future<List<XSpeciesItem>> loadItems({bool reload = false}) async {
    if (items.isEmpty || reload) {
      var res = await kernel.querySpeciesItems(IdReq(id: id!));
      if (res.success) {
        items = res.data?.result ?? [];
      }
    }
    return items;
  }

  @override
  Future<bool> move(IDirectory destination) async{
    if (destination.id != directory.id &&
        destination.metadata.belongId == directory.metadata.belongId) {
      var success = await update(SpeciesModel.fromJson(metadata.toJson()));
      if (success) {
        directory.forms.removeWhere((i) => i.id == id);
        directory = destination;
        destination.specieses.add(this);
      }
      return success;
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async{
    var data = SpeciesModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(SpeciesModel data) async{
    data.id = id!;
    data.directoryId = metadata.directoryId;
    var res = await kernel.updateSpecies(data);
    return res.success;
  }

  @override
  Future<bool> updateItem(SpeciesItemModel data) async{
    data.speciesId = id;
    var res = await kernel.updateSpeciesItem(data);
    if (res.success && res.data!=null) {
      items.removeWhere((i) => i.id == data.id);
      items.add(res.data!);
    }
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async{
    await loadItems(reload: reload);
    return true;
  }
}
