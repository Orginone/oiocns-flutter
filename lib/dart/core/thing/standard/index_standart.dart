import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/resource.dart';
import 'package:orginone/dart/core/thing/standard/page.dart';
import 'package:orginone/dart/core/thing/standard/transfer.dart';

import 'index.dart';

class StandardFiles {
  /// 目录对象
  IDirectory directory;

  /// 表单
  List<IForm> forms = [];

  /// 迁移配置
  List<ITransfer> transfers = [];

  /// 属性
  List<IProperty> propertys = [];

  /// 分类字典
  List<ISpecies> specieses = [];

  /// 目录
  List<IDirectory> directorys = [];

  /// 应用
  List<IApplication> applications = [];

  /// 页面模板
  List<IPageTemplate> templates = [];

  /// 表单加载完成标志
  bool formLoaded = false;

  /// 迁移配置加载完成标志
  bool transfersLoaded = false;

  /// 分类字典加载完成标志
  bool speciesesLoaded = false;

  /// 属性加载完成标志
  bool propertysLoaded = false;
  StandardFiles(this.directory) {
    if (directory.parent == null) {
      subscribeNotity(directory);
    }
  }
  String get id {
    return directory.id;
  }

  DataResource get resource {
    return directory.resource;
  }

//  List<IStandard> get standardFiles {
  List<IStandardFileInfo<XStandard>> get standardFiles {
    return [
      ...forms,
      ...transfers,
      ...propertys,
      ...specieses,
      ...directorys,
      ...applications,
      ...templates,
    ];
  }

  Future<List<IStandardFileInfo<XStandard>>> loadStandardFiles(
      {bool reload = false}) async {
    await Future.wait([
      loadForms(reload: reload),
      loadTransfers(reload: reload),
      loadPropertys(reload: reload),
      loadSpecieses(reload: reload),
      loadTemplates(reload: reload),
    ]);
    return standardFiles;
  }

  Future<List<IForm>> loadForms({bool reload = false}) async {
    if (formLoaded == false || reload) {
      formLoaded = true;
      var data = await resource.formColl.load({
        "options": {
          "match": {"directoryId": id}
        },
      });
      forms = data.map((i) => Form(i, directory)).toList();
    }
    return forms;
  }

  Future<List<IProperty>> loadPropertys({bool reload = false}) async {
    if (propertysLoaded == false || reload) {
      propertysLoaded = true;
      var data = await resource.propertyColl.load({
        'options': {
          'match': {'directoryId': id}
        },
      });
      propertys = data.map((i) => Property(i, directory)).toList();
    }
    return propertys;
  }

  Future<List<ISpecies>> loadSpecieses({bool reload = false}) async {
    if (speciesesLoaded == false || reload) {
      speciesesLoaded = true;
      var data = await resource.speciesColl.load({
        'options': {
          'match': {'directoryId': id}
        },
      });
      specieses = data.map((i) => Species(i, directory)).toList();
    }
    return specieses;
  }

  Future<List<ITransfer>> loadTransfers({bool reload = false}) async {
    if (transfersLoaded == false || reload) {
      transfersLoaded = true;
      var data = await resource.transferColl.load({
        'options': {
          'match': {'directoryId': id}
        },
      });
      transfers = data.map((i) => Transfer(i, directory)).toList();
    }
    return transfers;
  }

  Future<List<IApplication>> loadApplications({bool reload = false}) async {
    var apps = resource.applicationColl.cache
        .where(
          (i) => i.directoryId == directory.id,
        )
        .toList();
    applications = apps
        .where((a) => !(a.parentId != null && a.parentId!.length > 5))
        .toList()
        .map((a) => Application(a, directory, applications: apps))
        .toList();
    return applications;
  }

  Future<List<IDirectory>> loadDirectorys({bool reload = false}) async {
    var dirs = resource.directoryColl.cache
        .where(
          (i) => i.directoryId == directory.id,
        )
        .toList();
    directorys = dirs
        .map(
          (a) => Directory(a, directory.target, parent: directory),
        )
        .toList();
    for (var dir in directorys) {
      await dir.loadDirectoryResource();
    }
    return directorys;
  }

  Future<List<IPageTemplate>> loadTemplates({bool reload = false}) async {
    var templates = resource.templateColl.cache.where(
      (i) => i.directoryId == directory.id,
    );
    this.templates = templates.map((i) => PageTemplate(i, directory)).toList();
    return this.templates;
  }

  Future<XForm?> createForm(XForm data) async {
    data.directoryId = id;
    data.attributes = [];
    final res = await resource.formColl.insert(data);

    if (res != null) {
      await resource.formColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  Future<XSpecies?> createSpecies(XSpecies data) async {
    data.directoryId = id;
    final res = await resource.speciesColl.insert(data);
    if (res != null) {
      await resource.speciesColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  Future<XProperty?> createProperty(XProperty data) async {
    data.directoryId = id;
    final res = await resource.propertyColl.insert(data);
    if (res != null) {
      await resource.propertyColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  Future<XTransfer?> createTransfer(XTransfer data) async {
    data.directoryId = id;
    data.envs = [];
    data.nodes = [];
    data.edges = [];

    final res = await resource.transferColl.insert(data);
    if (res != null) {
      await resource.transferColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  Future<XApplication?> createApplication(XApplication data) async {
    data.directoryId = id;

    final res = await resource.applicationColl.insert(data);
    if (res != null) {
      await resource.applicationColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  Future<XPageTemplate?> createTemplate(XPageTemplate data) async {
    data.directoryId = id;
    var result = await resource.templateColl.insert(data);
    if (result != null) {
      await resource.templateColl.notity({data: result, 'operate': 'insert'});
      return result;
    }
    return null;
  }

  Future operateStandradFile(
      DataResource to,
      String action, //= 'replaceMany' | 'removeMany',
      bool? move) async {
    await loadStandardFiles();
    //TODO:这几行代码需要分析
    // await to.formColl[action](forms.map((a) => a.metadata));
    // await to.transferColl[action](transfers.map((a) => a.metadata));
    // await to.speciesColl[action](specieses.map((a) => a.metadata));
    // await to.propertyColl[action](propertys.map((a) => a.metadata));
    // await to.directoryColl[action](directorys.map((a) => a.metadata));
    if (action == 'replaceMany' && move == true) {
      var apps = resource.applicationColl.cache
          .where(
            (i) => i.directoryId == id,
          )
          .toList();
      resource.applicationColl.removeCache((i) => i.directoryId == id);
      var data = await to.applicationColl.replaceMany(apps);
      to.applicationColl.cache.addAll(data);
    }
    if (action == 'removeMany') {
      await to.applicationColl.removeMatch({
        'directoryId': id,
      });
      to.applicationColl.removeCache((i) => i.directoryId != id);
      await to.speciesItemColl.removeMatch({
        'speciesId': {
          '_in_': specieses.map((a) => a.id),
        },
      });
    }
    if (move == false &&
        action == 'replaceMany' &&
        to.targetMetadata.belongId != resource.targetMetadata.belongId) {
      var items = await resource.speciesItemColl.loadSpace({
        'options': {
          'match': {
            'speciesId': {
              '_in_': specieses.map((a) => a.id),
            },
          },
        },
      });
      await to.speciesItemColl.replaceMany(items);
    }
  }
}

/// 订阅标准文件变更通知
void subscribeNotity(IDirectory directory) {
  directory.resource.formColl.subscribe(
      [directory.key],
      (data) => subscribeCallback<XForm>(directory, '表单',
          data: XForm.fromJson(data), operate: data['operate']));
  directory.resource.directoryColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XDirectory>(directory, '目录',
                data: XDirectory.fromJson(data), operate: data['operate'])
          });
  directory.resource.propertyColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XProperty>(directory, '属性',
                data: XProperty.fromJson(data), operate: data['operate'])
          });
  directory.resource.speciesColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XSpecies>(directory, '分类',
                data: XSpecies.fromJson(data), operate: data['operate'])
          });
  directory.resource.transferColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XTransfer>(directory, '迁移',
                data: XTransfer.fromJson(data), operate: data['operate'])
          });
  directory.resource.applicationColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XApplication>(directory, '应用',
                data: XApplication.fromJson(data), operate: data['operate'])
          });
  directory.resource.templateColl.subscribe(
      [directory.key],
      (data) => {
            subscribeCallback<XPageTemplate>(directory, '模板',
                data: XPageTemplate.fromJson(data), operate: data['operate'])
          });
}

/// 订阅回调方法
bool subscribeCallback<T extends XStandard>(
    IDirectory directory, String typeName,
    {T? data, String? operate}) {
  if (data != null && operate != null) {
    var entity = data;

    if (directory.id == entity.directoryId) {
      switch (operate) {
        case 'insert':
        case 'remove':
          standardFilesChanged(directory, typeName, operate, entity);
          break;
        case 'reload':
          directory.structCallback(reload: true);
          return true;
        case 'refresh':
          directory.structCallback();
          return true;
        case 'reloadFiles':
          directory
              .loadFiles(reload: true)
              .then((value) => directory.changCallback());
          return true;
        default:
          directory.standard.standardFiles
              .firstWhere((i) => i.id == entity.id)
              .receive(operate, entity);
          if (entity.typeName == '模块' || entity.typeName == '办事') {
            for (var i in directory.standard.applications) {
              i.receive(operate, entity);
            }
          }
          break;
      }
      directory.structCallback();
      return true;
    }
    for (var subdir in directory.standard.directorys) {
      if (subscribeCallback(subdir, typeName, data: data, operate: operate)) {
        return true;
      }
    }
  }
  return false;
}

/// 目录中标准文件的变更
void standardFilesChanged(
  IDirectory directory,
  String typeName,
  String operate,
  dynamic data,
) {
  switch (typeName) {
    case '表单':
      directory.standard.forms = arrayChanged<IForm>(
        directory.standard.forms,
        operate,
        data,
        () => Form(data, directory),
      );
      break;
    case '属性':
      directory.standard.propertys = arrayChanged(
        directory.standard.propertys,
        operate,
        data,
        () => Property(data, directory),
      );
      break;
    case '分类':
      directory.standard.specieses = arrayChanged(
        directory.standard.specieses,
        operate,
        data,
        () => Species(data, directory),
      );
      break;
    case '迁移':
      directory.standard.transfers = arrayChanged(
        directory.standard.transfers,
        operate,
        data,
        () => Transfer(data, directory),
      );
      break;
    case '模板':
      directory.standard.templates = arrayChanged(
        directory.standard.templates,
        operate,
        data,
        () => PageTemplate(data, directory),
      );
      if (operate == 'insert') {
        directory.resource.templateColl.cache.add(data);
      } else {
        directory.resource.templateColl.removeCache((i) => i.id != data.id);
      }
      break;
    case '目录':
      directory.standard.directorys = arrayChanged(
        directory.standard.directorys,
        operate,
        data,
        () => Directory(data, directory.target, parent: directory),
      );
      if (operate == 'insert') {
        directory.resource.directoryColl.cache.addAll(data);
      } else {
        directory.resource.directoryColl.removeCache(data.id);
      }
      break;
    case '应用':
      if (data.typeName == '模块') {
        for (var i in directory.standard.applications) {
          i.receive(operate, data);
        }
      } else {
        directory.standard.applications = arrayChanged(
          directory.standard.applications,
          operate,
          data,
          () => Application(data, directory),
        );
        if (operate == 'insert') {
          directory.resource.applicationColl.cache.addAll(data);
        } else {
          directory.resource.applicationColl.removeCache(data.id);
        }
      }
      break;
  }
}

/// 数组元素操作
List<T> arrayChanged<T extends IStandardFileInfo>(
  List<T> arr,
  String operate,
  XStandard data,
  T Function() create,
) {
  if (operate == 'remove') {
    return arr.where((i) => i.id != data.id).toList();
  }
  if (operate == 'insert') {
    var index = arr.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      arr[index].setMetadataA(data);
    } else {
      arr.add(create());
    }
  }
  return arr;
}
