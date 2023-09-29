import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/asset_creation_config.dart';

import '../fileinfo.dart';

class SpeciesItem {
  late XSpeciesItem metadata;
  late String typeName;

  SpeciesItem(this.metadata) {
    typeName = '分类项';
    metadata.typeName = '分类项';
  }
}

abstract class IForm implements IStandardFileInfo<XForm> {
  late List<XAttribute> attributes;
  late List<FieldModel> fields;

  late List<AnyThingModel> things;

  @override
  Future<bool> update(FormModel data);

  late List<XSpeciesItem> items;

  Future<void> createFields();

  Future<List<XSpeciesItem>> loadItems({bool reload = false});

  Future<List<XAttribute>> loadAttributes({bool reload = false});

  Future<XAttribute?> createAttribute(AttributeModel data,
      [XProperty? property]);

  Future<bool> updateAttribute(AttributeModel data, [XProperty? property]);

  Future<bool> deleteAttribute(XAttribute data);

  Future<void> reset();

  void setThing(AnyThingModel thing);
}

class Form extends StandardFileInfo<XForm> implements IForm {
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
      data.directoryId = directory.id;
      var res = await destination.createForm(data);
      return res != null;
    }
    return false;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    if (reload && !isLoaded) {
      await Future.wait([
        loadAttributes(reload: reload),
        loadItems(reload: reload),
      ]);
    }
    isLoaded = reload;
    return true;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteForm(IdReq(id: id));
    if (res.success) {
      directory.forms.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<bool> deleteAttribute(XAttribute data) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      final res = await kernel.deleteAttribute(IdReq(id: data.id));
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
  List<PopupMenuItem> get popupMenuItem {
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
    return items;
  }

  @override
  Future<void> reset() async {
    for (var element in fields) {
      element.field.defaultData.value = null;
    }
  }

  Future<Fields> initFields(FieldModel attr) async {
    String? type;
    String? router;
    String? regx;
    Map<dynamic, String> select = {};
    Map rule = jsonDecode(attr.rule ?? "{}");
    String widget = rule['widget'] ?? "";
    switch (attr.valueType) {
      case "描述型":
        type = "input";
        break;
      case "数值型":
        regx = r'[0-9]';
        type = "input";
        break;
      case "选择型":
      case "分类型":
        for (var value in attr.lookups ?? []) {
          select[value.value] = value.text ?? "";
        }
        if (widget == 'switch') {
          type = "switch";
        } else {
          type = "select";
        }
        break;
      case "日期型":
        type = "selectDate";
        break;
      case "时间型":
        if (widget == "dateRange") {
          type = "selectDateRange";
        } else if (widget == "timeRange") {
          type = "selectTimeRange";
        } else {
          type = "selectTime";
        }
        break;
      case "用户型":
        if (widget.isEmpty) {
          type = "selectPerson";
        } else if (widget == 'group') {
          type = "selectGroup";
        } else if (widget == 'dept') {
          type = "selectDepartment";
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
        regx: regx);
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';

  @override
  late List<AnyThingModel> things;

  @override
  void setThing(AnyThingModel thing) {
    for (var element in fields) {
      if (element.field.type == "input") {
        thing.otherInfo[element.id!] = element.field.controller!.text;
      }
      if (element.field.defaultData.value != null) {
        switch (element.field.type) {
          case "selectPerson":
          case "selectDepartment":
          case "selectGroup":
            thing.otherInfo[element.id!] = element.field.defaultData.value.id;
            break;
          case "select":
            thing.otherInfo[element.id!] =
                element.field.defaultData.value.keys?.first;
            break;
          case "upload":
            thing.otherInfo[element.id!] =
                element.field.defaultData.value.toJson();
            break;
          default:
            thing.otherInfo[element.id!] = element.field.defaultData.value!;
            break;
        }
      }
    }
  }

  @override
  Future<void> createFields() async {
    for (var element in fields) {
      element.field = await initFields(element);
    }
  }
}
