import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/asset_creation_config.dart';

import 'file_info.dart';

class SpeciesItem {
  late XSpeciesItem metadata;
  late String typeName;

  SpeciesItem(this.metadata) {
    typeName = '分类项';
    metadata.typeName = '分类项';
  }
}


abstract class IForm implements IFileInfo<XForm> {
  late List<XAttribute> attributes;
  late List<FieldModel> fields;

  late List<AnyThingModel> things;

  Future<bool> update(FormModel data);

  late List<XSpeciesItem> items;

  Future<List<XSpeciesItem>> loadItems({bool reload = false});

  Future<List<XAttribute>> loadAttributes({bool reload = false});

  Future<XAttribute?> createAttribute(AttributeModel data,
      [XProperty? property]);

  Future<bool> updateAttribute(AttributeModel data, [XProperty? property]);

  Future<bool> deleteAttribute(XAttribute data);

  Future<void> reset();


  void setThing(AnyThingModel thing);
}


class Form extends FileInfo<XForm> implements IForm {
  Form(super.metadata, super.directory) {
    attributes = [];
    items = [];
    fields = [];
    things = [];
  }

  @override
  late List<XAttribute> attributes;

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
  Future<bool> loadContent({bool reload = false}) async{
    if(reload && !isLoaded){
     await Future.wait([loadAttributes(reload: reload),
      loadItems(reload: reload),]);
    }
    isLoaded = reload;
    return true;
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
      final res = await kernel
          .queryFormAttributes(GainModel(id: id, subId: metadata.belongId!));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;
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
    data.id = id;
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

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem{
    List<PopupMenuKey> key = [];
    key.addAll([
      PopupMenuKey.updateInfo,
      PopupMenuKey.rename,
      PopupMenuKey.delete,
      PopupMenuKey.shareQr,
    ]);
    return key
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }

  @override
  bool isLoaded = false;

  @override
  late List<FieldModel> fields;

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  Future<XAttribute?> createAttribute(AttributeModel data,
      [XProperty? property]) async {
    data.formId = id;
    if (property != null) {
      data.propId = property.id;
    }
    if (data.authId == null || data.authId!.length < 5) {
      data.authId = OrgAuth.superAuthId.label;
    }
    final res = await kernel.createAttribute(data);
    if (res.success && res.data!.id != null) {
      if (property != null) {
        res.data!.property = property;
        res.data!.linkPropertys = [property];
      }
      attributes.add(res.data!);
      return res.data!;
    }
    return null;
  }

  @override
  Future<List<XSpeciesItem>> loadItems({bool reload = false}) async {
    if (items.isEmpty || reload) {
      items = [];
      fields = [];
      for (final attr in attributes) {
        if (attr.linkPropertys != null && attr.linkPropertys!.isNotEmpty) {
          final property = attr.linkPropertys![0];
          final field = FieldModel(
            id: attr.id,
            rule: attr.rule,
            name: attr.name,
            code: property.code,
            remark: attr.remark,
            lookups: [],
            valueType: property.valueType,
          );
          if (property.speciesId != null && property.speciesId!.isNotEmpty) {
            final res =
                await kernel.querySpeciesItems(IdReq(id: property.speciesId!));
            if (res.success) {
              if (property.valueType == '分类型') {
                items.addAll(res.data!.result ?? []);
              }
              field.lookups = (res.data!.result ?? []).map((i) {
                return FiledLookup(
                  id: i.id,
                  text: i.name,
                  value: i.code,
                  icon: i.icon,
                  parentId: i.parentId,
                );
              }).toList();
            }
          }
          fields.add(field);
        }
      }
    }
    for (var element in fields) {
      element.fields = await initFields(attributes.firstWhere((attr) => attr.id == element.id));
      if(element.fields.type == "select"){
        var field = fields.firstWhere((f) => f.code == element.fields.code);
        Map<dynamic,String> select = {};
        for (var value in field.lookups!) {
          select[value.id] = value.text??"";
        }
        element.fields.select = select;
      }
    }
    return items;
  }

  Future<void> reset() async {
    for (var element in fields) {
      element.fields = await initFields(attributes.firstWhere((attr) => attr.id == element.id));
    }
  }

  Future<Fields> initFields(XAttribute attr) async {
    String? type;
    String? router;
    Map<dynamic, String> select = {};
    switch (attr.property?.valueType) {
      case "描述型":
      case "数值型":
        type = "input";
        break;
      case "选择型":
      case "分类型":
        type = "select";
        break;
      case "日期型":
      case "时间型":
        type = "selectDate";
        break;
      case "用户型":
        if(attr.rule!=null){
          Map widget = jsonDecode(attr.rule!);
          if(widget.isEmpty){
            type = "selectPerson";
          }else if(widget['widget'] == 'group'){
            type = "selectGroup";
          }else if(widget['widget'] == 'dept'){
            type = "selectDepartment";
          }
        }
        break;
      case '附件型':
        type = "upload";
        break;
      default:
        type = 'input';
        break;
    }

    return Fields(
      title: attr.name,
      type: type,
      code: attr.code,
      select: select,
      router: router,
    );
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';

  @override
  late List<AnyThingModel> things;

  @override
  void setThing(AnyThingModel thing) {
    for (var element in fields) {
      if (element.fields.type == "input") {
        thing.otherInfo[element.id!] =
            element.fields.controller!.text;
      }
      if (element.fields.defaultData.value != null) {
        if (element.fields.type == "selectPerson") {
          thing.otherInfo[element.id!] =
              element.fields.defaultData.value.id;
        } else if (element.fields.type == "selectDepartment" ||
            element.fields.type == "selectGroup") {
          thing.otherInfo[element.id!] =
              element.fields.defaultData.value.metadata.id;
        } else if (element.fields.type == "select") {
          thing.otherInfo[element.id!] =
              element.fields.defaultData.value.keys?.first;
        }
      }
    }
  }

}
