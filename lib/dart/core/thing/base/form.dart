


import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/store/propclass.dart';
import 'package:orginone/main.dart';

import 'species.dart';

abstract class IForm implements ISpeciesItem {
  //表单
  late List<XForm> forms;

  //表单特性
  late List<XAttribute> attributes;

  //加载可选属性
  Future<List<XProperty>> loadPropertys();

  //加载表单
  Future<List<XForm>> loadForms({bool reload = false});

  //新建表单
  Future<XForm?> createForm(FormModel data);

  //更新表单
  Future<bool> updateForm(FormModel data);

  //删除表单
  Future<bool> deleteForm(XForm data);

  //加载表单特性
  Future<List<XAttribute>> loadAttributes({bool reload = false});

  //新建表单特性
  Future<XAttribute?> createAttribute(AttributeModel data);
  //更新表单特性
  Future<bool> updateAttribute(AttributeModel data);
//删除表单特性
  Future<bool> deleteAttribute(XAttribute data);
}


abstract class Form extends SpeciesItem implements IForm {
  Form(super.metadata, super.current,super.parent){
    attributes = [];
    forms = [];
  }

  @override
  late List<XAttribute> attributes;

  @override
  late List<XForm> forms;

  @override
  Future<XAttribute?> createAttribute(AttributeModel data) async{
    data.shareId = current.metadata.id;
    data.speciesId = metadata.id;
    final res = await kernel.createAttribute(data);
    if (res.success && res.data?.id != null) {
      attributes.add(res.data!);
      return res.data;
    }
  }

  @override
  Future<XForm?> createForm(FormModel data) async{
    data.shareId = current.metadata.id;
    data.speciesId = metadata.id;
    final res = await kernel.createForm(data);
    if (res.success && res.data!= null) {
      forms.add(res.data!);
      return res.data;
    }
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
  Future<bool> deleteForm(XForm data) async{
    final index = forms.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      final res = await kernel.deleteForm(IdReq(id: data.id!));
      if (res.success) {
        forms.removeAt(index);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<List<XAttribute>> loadAttributes({bool reload = false}) async{
    if (attributes.isEmpty || reload) {
      final res = await kernel.querySpeciesAttrs(GetSpeciesResourceModel( id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;

  }

  @override
  Future<List<XForm>> loadForms({bool reload = false}) async{
    if (forms.isEmpty || reload) {
      final res = await kernel.querySpeciesForms(GetSpeciesResourceModel( id: current.metadata.id,
        speciesId: metadata.id,
        belongId: current.space.metadata.id,
        upTeam: current.metadata.typeName == TargetType.group.label,
        upSpecies: true,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),));
      if (res.success) {
        forms = res.data?.result ?? [];
      }
    }
    return forms;
  }

  @override
  Future<List<XProperty>> loadPropertys() async{
    List<XProperty> result = [];
    for (ISpeciesItem item in current.space.species) {
      switch (SpeciesType.getType(item.metadata.typeName)) {
        case SpeciesType.store:
        case SpeciesType.propClass:
          result.addAll(await (item as IPropClass).loadAllProperty());
          break;
      }
    }
    return result;
  }

  @override
  Future<bool> updateAttribute(AttributeModel data) async{
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.shareId = current.metadata.id;
      data.speciesId = metadata.id;
      final res = await kernel.updateAttribute(data);
      if (res.success && res.data?.id != null) {
        attributes[index] = res.data!;
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<bool> updateForm(FormModel data) async{
    final index = forms.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      data.shareId = current.metadata.id;
      data.speciesId = metadata.id;
      final res = await kernel.updateForm(data);
      if (res.success && res.data?.id != null) {
        forms[index] = res.data!;
      }
      return res.success;
    }
    return false;
  }



}