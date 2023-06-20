import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';

import 'file_info.dart';

class SpeciesItem {
  late XSpeciesItem metadata;
  late String typeName;

  SpeciesItem(this.metadata) {
    typeName = '分类项';
  }
}

abstract class IFormView {
  //类目项
  late XForm metadata;

  //表单特性
  late List<SpeciesItem> items;

  //加载类目项
  late List<XAttribute> attributes;

  //加载类目项
  Future<List<SpeciesItem>> loadItems({bool reload = false});

  //加载表单特性
  Future<List<XAttribute>> loadAttributes({bool reload = false});
}

abstract class IForm implements IFileInfo<XForm>, IFormView {
  /// 更新表单
  Future<bool> update(FormModel data);

  ///删除表单
  Future<bool> delete();

  /// 加载表单特性
  Future<List<XAttribute>> loadAttributes({bool reload});

  /// 新建表单特性
  Future<XAttribute?> createAttribute(AttributeModel data,
      [XProperty? property]);

  /// 更新表单特性
  Future<bool> updateAttribute(AttributeModel data, [XProperty? property]);

  /// 删除表单特性
  Future<bool> deleteAttribute(XAttribute data);
}

class FormView implements IFormView {
  FormView(this.metadata) {
    attributes = [];
    items = [];
  }

  @override
  late List<XAttribute> attributes;

  @override
  late List<SpeciesItem> items;

  @override
  late XForm metadata;

  @override
  Future<List<XAttribute>> loadAttributes({bool reload = false}) async {
    if (attributes.isEmpty || reload) {
      final res = await kernel.queryFormAttributes(
          GainModel(id: metadata.id!, subId: metadata.belongId!));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;
  }

  @override
  Future<List<SpeciesItem>> loadItems({bool reload = false}) async {
    if (items.isEmpty || reload) {
      items = [];
      for (final attr in attributes) {
        if (attr.property?.valueType == '分类型') {
          final res = await kernel.querySpeciesItems(IdReq(
            id: attr.property?.speciesId ?? "",
          ));
          if (res.success && res.data != null) {
            for (var item in res.data!.result!) {
              items.add(SpeciesItem(item));
            }
          }
        }
      }
    }
    return items;
  }
}

class Form extends FileInfo<XForm> implements IForm {
  Form(super.metadata, super.directory) {
    attributes = [];
    items = [];
  }

  @override
  late List<XAttribute> attributes;

  @override
  late List<SpeciesItem> items;

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
  Future<bool> loadContent({bool reload = false}) async{
    await loadAttributes(reload: reload);
    await loadItems(reload: reload);
    return true;
  }

  @override
  Future<XAttribute?> createAttribute(AttributeModel data,
      [XProperty? property]) async {
    data.formId = id;
    data.propId = property?.id;
    if (data.authId != null || data.authId!.length < 5) {
      data.authId = OrgAuth.superAuthId.label;
    }
    final res = await kernel.createAttribute(data);
    if (res.success && res.data?.id != null) {
      if(property!=null){
        res.data!.property = property;
        res.data!.linkPropertys = [property];
      }
      attributes.add(res.data!);
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteForm(IdReq(id: id!));
    if (res.success) {
       directory.forms.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<bool> deleteAttribute(XAttribute data) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      final res = await kernel.deleteAttribute(IdReq(id:  data.id!));
      if (res.success) {
        attributes.removeAt(index);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<List<XAttribute>> loadAttributes({bool reload = false}) async {
    if (attributes.isEmpty || reload) {
      final res = await kernel.queryFormAttributes(
          GainModel(id: id, subId: metadata.belongId!));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;
  }

  @override
  Future<List<SpeciesItem>> loadItems({bool reload = false}) async {
    if (items.isEmpty || reload) {
      items = [];
      for (final attr in attributes) {
        if (attr.property?.valueType == '分类型') {
          final res = await kernel.querySpeciesItems(IdReq(
            id: attr.property?.speciesId ?? "",
          ));
          if (res.success && res.data != null) {
            for (var item in res.data!.result!) {
              items.add(SpeciesItem(item));
            }
          }
        }
      }
    }
    return items;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id &&
        destination.metadata.belongId == directory.metadata.belongId) {
      var success = await update(FormModel.fromJson(metadata.toJson()));
      if (success) {
        directory.forms.removeWhere((i) => i.id == id);
        directory = destination;
        destination.forms.add(this);
      }
      return success;
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async {
    var data = FormModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(FormModel data) async {
    data.id = id!;
    data.directoryId = metadata.directoryId;
    data.typeName = metadata.typeName!;
    var res = await kernel.updateForm(data);
    return res.success;
  }

  @override
  Future<bool> updateAttribute(AttributeModel data,
      [XProperty? property]) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.formId = id;
      if (property != null) {
        data.propId = property.id;
      }
      final res = await kernel.updateAttribute(data);
      if (res.success && res.data?.id != null) {
        res.data!.property = attributes[index].property;
        res.data!.linkPropertys = attributes[index].linkPropertys;
        if (property != null) {
          res.data!.linkPropertys = [property];
        }
        attributes[index] = res.data!;
      }
      return res.success;
    }
    return false;
  }
}
