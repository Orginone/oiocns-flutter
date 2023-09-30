import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';

abstract class ISpecies implements IStandardFileInfo<XSpecies> {
  /// 类目项
  late List<XSpeciesItem> items;

  /// 加载类目项
  Future<List<XSpeciesItem>> loadItems({bool reload = false});

  /// 新增类目项
  Future<XSpeciesItem?> createItem(XSpeciesItem data);

  /// 删除类目项
  Future<bool> deleteItem(XSpeciesItem item);

  /// 更新类目项
  Future<bool> updateItem(XSpeciesItem data);
}

class Species extends StandardFileInfo<XSpecies> implements ISpecies {
  @override
  final IDirectory directory;
  @override
  final XSpecies metadata;
  @override
  List<XSpeciesItem> items = [];
  bool _itemLoaded = false;
  @override
  String get cacheFlag => 'species';

  ///构造函数
  Species(
    this.metadata,
    this.directory,
  ) : super(metadata, directory, directory.resource.speciesColl) {
    items = [];
  }
  @override
  Future<bool> delete() async {
    var success = true;
    if (items.isNotEmpty) {
      success = await directory.resource.speciesItemColl.deleteMatch({
        'speciesId': id,
      });
    }
    return success && await super.delete();
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    if (reload && !isLoaded) {
      await loadItems(reload: reload);
    }
    isLoaded = true;
    return true;
  }

  @override
  Future<List<XSpeciesItem>> loadItems({bool reload = false}) async {
    if (!_itemLoaded || reload) {
      final res = await directory.resource.speciesItemColl.loadSpace({
        'options': {
          'match': {'speciesId': id}
        },
      });
      _itemLoaded = true;
      items = res ?? [];
    }
    return items;
  }

  @override
  Future<XSpeciesItem?> createItem(XSpeciesItem data) async {
    data.speciesId = id;
    final res = await directory.resource.speciesItemColl.insert(data);
    if (res != null) {
      items.add(res);
    }
    return res;
  }

  @override
  Future<bool> deleteItem(XSpeciesItem item) async {
    final success = await directory.resource.speciesItemColl.delete(item);
    if (success) {
      items = items.where((i) => i.id != item.id).toList();
    }
    return success;
  }

  @override
  Future<bool> updateItem(XSpeciesItem data) async {
    data.speciesId = id;
    final res = await directory.resource.speciesItemColl.replace(data);
    if (res != null) {
      final index = items.indexWhere((i) => i.id == data.id);
      if (index > -1) {
        items[index] = res;
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      await super
          .copyTo(destination.id, coll: destination.resource.speciesColl);
      final items = await directory.resource.speciesItemColl.loadSpace({
        'options': {
          'match': {
            'speciesId': id,
          },
        },
      });
      await destination.resource.speciesItemColl.replaceMany(items);
      return true;
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (allowMove(destination)) {
      return await super
          .moveTo(destination.id, coll: destination.resource.speciesColl);
    }
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
