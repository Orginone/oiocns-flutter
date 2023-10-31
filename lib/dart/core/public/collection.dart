import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';

import '../../base/schema.dart';

class XCollection<T extends Xbase> {
  late bool _loaded;
  late List<T> _cache = [];
  late String _collName;
  late XTarget _target;
  late List<String> _relations = [];
  late List<String> _keys;

  ///构造方法
  XCollection(
      XTarget target, String name, List<String> relations, List<String> keys) {
    _cache = [];
    _keys = keys;
    _loaded = false;
    _collName = name;
    _target = target;
    _relations = relations;
  }

  List<T> get cache {
    return _cache;
  }

  String get collName {
    return _collName;
  }

  String subMethodName({String? id}) {
    return '${this._target.belongId}-${id ?? this._target.id}-${this._collName}';

    ///
  }

  Future<List<T>> all({bool reload = false}) async {
    if (!_loaded || reload) {
      _cache = await load({});
      _loaded = true;
    }
    return _cache;
  }

  Future<List<T>> find({required List<String> ids}) async {
    if (ids != '' && ids.isNotEmpty) {
      Map<String, dynamic> options = {
        'match': {
          '_id': {'_in_': ids}
        }
      };
      return await loadSpace(options);
    }
    return [];
  }

  Future<List<T>> loadSpace(dynamic options) async {
    options = options ?? {};
    options['userData'] = options['userData'] ?? [];
    options['collName'] = _collName;
    options['options'] = options['options'] ?? {};
    options['options']['match'] = options['options']['match'] ?? {};
    // options['options']['match']['isDeleted'] = false;
    var res = await kernel.collectionLoad(
      _target.belongId!,
      _relations,
      options,
    );
    if (res.success && res.data != null) {
      if (res.data.length > 0) {
        return res.data.cast<T>();
      } else {
        return Future(() => []);
      }
    }
    return [];
  }

  Future<List<T>> load(dynamic options) async {
    options = {};
    options['options'] = {
      "match": {"shareId": _target.id}
    };
    // options.options.match = {};
    // options.options.match.shareId = _target.id;
    return await loadSpace(options);
  }

  Future<T?> insert(T data, {String? copyId}) async {
    data.id = data.id ?? 'snowId()';
    data.shareId = _target.id;
    data.belongId = data.belongId ?? _target.belongId;
    var res = await kernel.collectionInsert(
      _target.belongId!,
      _relations,
      _collName,
      data,
      copyId,
    );
    if (res.success) {
      if (res.data != null && _loaded) {
        _cache.add(res.data!);
      }
      return res.data!;
    }
    return null;
  }

  Future<List<T>?> insertMany(List<T> data, String? copyId) async {
    data = data.map((a) {
      a.id = a.id ?? 'snowId()';
      a.shareId = _target.id;
      a.belongId = a.belongId ?? _target.belongId;
      return a;
    }).toList();
    var res = await kernel.collectionInsert<List<T>>(
      _target.belongId!,
      _relations,
      _collName,
      data,
      copyId,
    );
    if (res.success) {
      if (res.data != [] && _loaded) {
        _cache.addAll(res.data as List<T>);
      }
      return res.data;
    }
    return [];
  }

  Future<T?> replace(T data, {String? copyId}) async {
    data.shareId = this._target.id;
    data.belongId = data.belongId ?? this._target.belongId;
    var res = await kernel.collectionReplace<T>(
      _target.belongId!,
      _relations,
      _collName,
      data,
      copyId,
    );
    if (res.success) {
      if (res.data != [] && this._loaded) {
        _cache = _cache.map((i) {
          if (i.id == res.data?.id) {
            return res.data!;
          }
          return i;
        }).toList();
      }
      return res.data!;
    }
    return null;
  }

  Future<List<T>> replaceMany(List<T> data, {String? copyId}) async {
    if (data.isEmpty) return data;
    data = data.map((a) {
      a.shareId = _target.id;
      a.belongId = a.belongId ?? _target.belongId;
      return a;
    }).toList();
    var res = await kernel.collectionReplace<List<T>>(
      _target.belongId!,
      this._relations,
      this._collName,
      data,
      copyId,
    );
    if (res.success) {
      return res.data ?? [];
    }
    return [];
  }

  Future<T?> update(String id, dynamic update, {String? copyId}) async {
    var res = await kernel.collectionSetFields<T>(
      _target.belongId!,
      this._relations,
      this._collName,
      {
        id,
        update,
      },
      copyId,
    );
    if (res.success) {
      return res.data;
    }
    return null;
  }

  Future<List<T>?> updateMany(List<String> ids, dynamic update,
      {String? copyId}) async {
    var res = await kernel.collectionSetFields<List<T>>(
      _target.belongId!,
      this._relations,
      this._collName,
      {
        ids,
        update,
      },
      copyId,
    );
    if (res.success) {
      return res.data;
    }
    return [];
  }

  Future<bool> delete(T data, {String? copyId}) async {
    Map<String, dynamic> update = {
      'match': {'_id': data.id},
      'update': {
        '_set': {'isDeleted': true}
      }
    };
    var res = await kernel.collectionUpdate(
      _target.belongId!,
      this._relations,
      this._collName,
      update,
      copyId,
    );
    if (res.success) {
      return res.data?.MatchedCount > 0;
    }
    return false;
  }

  Future<bool> deleteMany(List<T> data, {String? copyId}) async {
    Map<String, dynamic> update = {
      'match': {
        '_id': {'_in': data.map((i) => i.id)}
      },
      'update': {
        '_set_': {'isDeleted': true}
      }
    };
    var res = await kernel.collectionUpdate(
      _target.belongId!,
      this._relations,
      this._collName,
      update,
      copyId,
    );
    if (res.success) {
      return res.data?.MatchedCount > 0;
    }
    return false;
  }

  Future<bool> deleteMatch(dynamic match, {String? copyId}) async {
    Map<String, dynamic> update = {
      'match': match,
      'update': {
        '_set_': {'isDeleted': true}
      }
    };
    var res = await kernel.collectionUpdate(
      _target.belongId!,
      this._relations,
      this._collName,
      update,
      copyId,
    );
    if (res.success) {
      return res.data?.MatchedCount > 0;
    }
    return false;
  }

  Future<bool> remove(T data, {String? copyId}) async {
    Map<String, dynamic> match = {'_id': data.id};
    var res = await kernel.collectionRemove(
      this._target.belongId!,
      this._relations,
      this._collName,
      match,
      copyId,
    );
    if (res.success) {
      return res.data?.MatchedCount > 0;
    }
    return false;
  }

  Future<bool> removeMany(List<T> data, {String? copyId}) async {
    Map<String, dynamic> match = {
      '_id': {'_in_': data.map((i) => i.id)}
    };
    var res = await kernel.collectionRemove(
      this._target.belongId!,
      this._relations,
      this._collName,
      match,
      copyId,
    );
    if (res.success) {
      return res.data?.MatchedCount > 0;
    }
    return false;
  }

  Future removeCache(String id) async {
    this._cache = this._cache.where((element) => element.id != id).toList();
  }

  Future<bool> notity(
    dynamic data, {
    bool? ignoreSelf,
    String? targetId,
    bool? onlyTarget,
    bool onlineOnly = true,
  }) async {
    DataNotityType req = DataNotityType(
      data: data,
      flag: this.collName,
      onlineOnly: onlineOnly,
      belongId: this._target.belongId!,
      relations: this._relations,
      onlyTarget: onlyTarget == true,
      ignoreSelf: ignoreSelf == true,
      targetId: targetId ?? this._target.id,
      subTargetId: null,
    );
    var res = await kernel.dataNotify(req);
    return res.success;
  }

  void subscribe(List<String> keys, Function callback, {String? id}) {
    kernel.subscribe(
        subMethodName(id: id), keys, (data) => callback.call(data));
  }
}
