// 目录操作的接口

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/resource.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/thing/standard/transfer.dart';

abstract class IDirectoryOperate {
  late bool isEmpty;
  Future<void> loadResource({bool reload = false});
  List<T> getContent<T>(List<String> typeNames);
  Future<bool> receiveMessage<T extends XStandard>(
    String operate,
    T data,
    XCollection<T> coll,
    StandardFileInfo<T> Function(T data, IDirectory dir) create,
  );
}

// 目录操作的实现类
class DirectoryOperate implements IDirectoryOperate {
  late IDirectory directory;
  late DataResource _resource;
  List<StandardFileInfo<XStandard>> standardFiles = [];

  DirectoryOperate(this.directory, DataResource resource) : super() {
    _resource = resource;
    if (directory.parent != null) {
      // 订阅资源类型的变更
      _subscribe<XForm>(
        _resource.formColl,
        (s, l) => Form(s, l),
      );
      _subscribe<XProperty>(
        _resource.propertyColl,
        (s, l) => Property(s, l),
      );
      _subscribe<XSpecies>(
        _resource.speciesColl,
        (s, l) => Species(s, l),
      );
      _subscribe<XTransfer>(
        _resource.transferColl,
        (s, l) => Transfer(s, l),
      );
      _subscribe<XApplication>(
        _resource.applicationColl,
        (s, l) => Application(s, l),
      );
      _subscribe<XDirectory>(
        _resource.directoryColl,
        (s, l) => Directory(s, directory.target),
      );
    }
  }
  @override
  List<T> getContent<T>(List<String> typeNames) {
    return standardFiles
        .where(
            (StandardFileInfo<XStandard> a) => typeNames.contains(a.typeName))
        .cast<T>()
        .toList();
  }

  @override
  bool get isEmpty => standardFiles.isEmpty;

  @override
  Future<void> loadResource({bool reload = false}) async {
    if (directory.parent == null || reload) {
      await _resource.preLoad(reload: reload);
    }
    standardFiles = [];
    // 加载文件类型资源
    standardFiles.addAll(
      _resource.transferColl.cache
          .where((i) => i.directoryId == directory.id)
          .map((l) => Transfer(l, directory)),
    );
    standardFiles.addAll(
      _resource.formColl.cache
          .where((i) => i.directoryId == directory.id)
          .map((l) => Form(l, directory)),
    );
    standardFiles.addAll(
      _resource.speciesColl.cache
          .where((i) => i.directoryId == directory.id)
          .map((l) => Species(l, directory)),
    );
    standardFiles.addAll(
      _resource.propertyColl.cache
          .where((i) => i.directoryId == directory.id)
          .map((l) => Property(l, directory)),
    );
    final apps = _resource.applicationColl.cache
        .where((i) => i.directoryId == directory.id)
        .toList();
    standardFiles.addAll(
      apps.where((a) => a.parentId != null || a.parentId!.isEmpty).map(
          (a) => Application(a, directory, parent: null, applications: apps)),
    );
    // 加载子目录资源
    for (final child in _resource.directoryColl.cache
        .where((i) => i.directoryId == directory.id)) {
      final subDir = Directory(child, directory.target);
      await subDir.loadDirectoryResource();
      standardFiles.add(subDir);
    }
  }

  @override
  Future<bool> receiveMessage<T extends XStandard>(
    String operate,
    T data,
    XCollection<T> coll,
    StandardFileInfo<T> Function(T data, IDirectory dir) create,
  ) async {
    if (data.directoryId == directory.id) {
      if (data.typeName == '模块') {
        // 对于模块类型的资源，传递消息给应用类型的资源
        for (final app in getContent<IApplication>(['应用'])) {
          if (await app.receiveMessage(operate, data as XApplication)) {
            return true;
          }
        }
      }
      switch (operate) {
        case 'insert':
          coll.cache.add(data);
          final standard = create(data, directory);
          standardFiles.add(standard);
          break;
        case 'replace':
          final index = coll.cache.indexWhere((a) => a.id == data.id);
          if (index != -1) {
            coll.cache[index] = data;
            standardFiles.firstWhere((i) => i.id == data.id).setMetadata(data);
          }
          break;
        case 'delete':
          await coll.removeCache(data.id);
          standardFiles.removeWhere((a) => a.id == data.id);
          break;
        case 'refresh':
          directory.structCallback();
          return true;
      }
      directory.taskEmitter.changCallback();
      return true;
    } else {
      // 传给其他子目录进行消息传递
      for (final child in standardFiles) {
        if (child.metadata.typeName == '目录' &&
            await (child as IDirectory).operater.receiveMessage(
                  operate,
                  data,
                  coll,
                  create,
                )) {
          return true;
        }
      }
    }
    return false;
  }

  _subscribe<T extends XStandard>(
    XCollection<T> coll,
    StandardFileInfo<T> Function(T data, IDirectory dir) create,
  ) {
    coll.subscribe([directory.key], (Map a) async {
      String operate = a['operate'];
      List<T> data = a['data'];
      for (var s in data) {
        receiveMessage<T>(operate, s, coll, create);
      }
    });
  }

  @override
  set isEmpty(bool isEmpty) {
    this.isEmpty = isEmpty;
  }
}
