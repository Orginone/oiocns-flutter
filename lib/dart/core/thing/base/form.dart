import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/store/propclass.dart';
import 'package:orginone/dart/core/thing/store/thingclass.dart';
import 'package:orginone/main.dart';

import 'species.dart';


abstract class IForm {
  /// 表单元数据
  late XForm metadata;

  /// 表单分类
  late ISpeciesItem species;

  /// 表单特性
  late List<XAttribute> attributes;

  /// 更新表单
  Future<bool> update(FormModel data);

  /// 删除表单
  Future<bool> delete();

  /// 加载表单特性
  Future<List<XAttribute>> loadAttributes({bool reload});

  /// 新建表单特性
  Future<XAttribute?> createAttribute(AttributeModel data, XProperty property);

  /// 更新表单特性
  Future<bool> updateAttribute(AttributeModel data, [XProperty? property]);

  /// 删除表单特性
  Future<bool> deleteAttribute(XAttribute data);
}


class Form implements IForm {
  Form(this.metadata, this.species) {
    attributes = [];
  }

  @override
  late List<XAttribute> attributes;

  @override
  late ISpeciesItem species;

  @override
  late XForm metadata;

  @override
  Future<XAttribute?> createAttribute(AttributeModel data,
      XProperty property) async {
    data.formId = metadata.id;
    data.propId = property.id;
    if (data.authId != null || data.authId!.length < 5) {
      data.authId = species.metadata.authId;
    }
    final res = await kernel.createAttribute(data);
    if (res.success && res.data?.id != null) {
      res.data!.property = property;
      res.data!.linkPropertys = [property];
      attributes.add(res.data!);
      return res.data;
    }
    return null;
  }


  @override
  Future<bool> deleteAttribute(XAttribute data) async{
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
  Future<List<XAttribute>> loadAttributes({bool reload = false}) async{
    if (attributes.isEmpty || reload) {
      final res = await kernel.queryFormAttributes(
          GainModel(id: metadata.id!, subId: species.belongId));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;

  }



  @override
  Future<bool> updateAttribute(AttributeModel data,
      [XProperty? property]) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.formId = metadata.id;
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

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteForm(IdReq(id: metadata.id));
    if (res.success) {
      if (species.metadata.typeName == SpeciesType.thing.label) {
        var species = this.species as IThingClass;
        species.forms.removeWhere((i) => i == this);
      }
    }
    return res.success;
  }

  @override
  Future<bool> update(FormModel data) async {
    data.shareId = metadata.shareId;
    data.speciesId = metadata.speciesId;
    var res = await kernel.updateForm(data);
    if (res.success && res.data != null) {
      metadata = res.data!;
    }
    return res.success;
  }
}