import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/utils/index.dart';

abstract class IForm implements IStandardFileInfo<XForm> {
  ///构造函数
  IForm(this.attributes, this.fields);

  ///表单特性
  final List<XAttribute> attributes;

  ///表单字段
  final List<FieldModel> fields;

  ///新建表单特性
  Future<XAttribute?> createAttribute(XAttribute data, {XProperty? property});

  ///更新表单特性
  Future<bool> updateAttribute(XAttribute data, {XProperty? property});

  ///删除表单特性
  Future<bool> deleteAttribute(XAttribute data);
}

class Form extends StandardFileInfo<XForm> implements IForm {
  @override
  final XForm metadata;
  @override
  final IDirectory directory;
  late bool _fieldsLoaded = false;
  @override
  late List<FieldModel> fields = [];
  @override
  List<XAttribute> get attributes => metadata.attributes ?? [];
  @override
  String get id => metadata.id.replaceAll('_', '');
  @override
  String get cacheFlag => 'forms';

  ///构造函数
  Form(this.metadata, this.directory)
      : super(metadata, directory, directory.resource.formColl) {
    setEntity();
  }
  @override
  Future<bool> loadContent({bool reload = false}) async {
    List<FieldModel> fieds = await loadFieldsNew(reload: reload);
    LogUtil.d('loadContent');
    LogUtil.d(fieds);
    return true;
  }

  Future<List<FieldModel>> loadFields({bool reload = false}) async {
    if (!_fieldsLoaded || reload) {
      fields = [];
      await Future.wait(attributes.map((attr) async {
        if (attr.property != null) {
          final field = FieldModel(
            id: attr.id,
            rule: attr.rule,
            name: attr.name,
            code: 'T${attr.property?.id}',
            remark: attr.remark,
            lookups: [],
            valueType: attr.property?.valueType,
          );
          if (attr.property!.speciesId != null &&
              attr.property!.speciesId!.isNotEmpty) {
            final data = await directory.resource.speciesItemColl.loadSpace({
              'options': {
                'match': {
                  'speciesId': {'_in_': attr.property?.speciesId}
                }
              },
            });
            if (data.isNotEmpty) {
              field.lookups = data
                  .map((i) => FiledLookup(
                        id: i.id,
                        text: i.name,
                        value: i.code,
                        icon: i.icon,
                        parentId: i.parentId,
                      ))
                  .toList();
            }
          }
          fields.add(field);
        }
      }));
    }

    _fieldsLoaded = true;

    return fields;
  }

  Future<List<FieldModel>> loadFieldsNew({bool reload = false}) async {
    if (!_fieldsLoaded || reload) {
      fields = [];
      final speciesIds = attributes
          .map((i) => i.property?.speciesId)
          .toList()
          .where((i) => i != null && i.isNotEmpty)
          .toList()
          .map((i) => i!)
          .toList();
      final data = await loadItems(speciesIds);
      await Future.wait(attributes.map((attr) async {
        if (attr.property != null) {
          final field = FieldModel(
            id: attr.id,
            rule: attr.rule,
            name: attr.name,
            code: 'T${attr.property?.id}',
            remark: attr.remark,
            lookups: [],
            valueType: attr.property?.valueType,
          );
          if (attr.property!.speciesId != null &&
              attr.property!.speciesId!.isNotEmpty) {
            if (data.isNotEmpty) {
              field.lookups = data
                  .where((i) => i.speciesId == attr.property!.speciesId)
                  .toList()
                  .map((i) => FiledLookup(
                        id: i.id,
                        text: i.name,
                        value: 'S${i.id}',
                        icon: i.icon,
                        parentId: i.parentId,
                      ))
                  .toList();
            }
          }
          fields.add(field);
        }
      }));
    }

    _fieldsLoaded = true;

    return fields;
  }

  Future<List<XSpeciesItem>> loadItems(List<String> speciesIds) async {
    final ids = speciesIds.where((i) => i.isNotEmpty).toList();
    if (ids.isEmpty) return [];
    final data = await directory.resource.speciesItemColl.loadSpace({
      'options': {
        'match': {
          'speciesId': {'_in_': ids}
        }
      },
    });
    return data;
  }

  @override
  Future<XAttribute?> createAttribute(XAttribute data,
      {XProperty? property}) async {
    if (property != null) {
      data.property = property;
      data.propId = property.id;
    }
    if (data.authId != null || data.authId!.length < 5) {
      data.authId = OrgAuth.superAuthId.label;
    }
    data.id = 'snowId()';
    metadata.attributes = [...metadata.attributes ?? [], data];

    final res = await update(metadata);
    if (res) {
      return data;
    }
    return null;
  }

  @override
  Future<bool> updateAttribute(XAttribute data, {XProperty? property}) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    XAttribute oldData = attributes.firstWhere((i) => i.id == data.id);
    if (index > -1) {
      data = XAttribute.fromJson({...oldData.toJson(), ...data.toJson()});
      if (property != null) {
        data.propId = property.id;
        data.property = property;
      }
      metadata.attributes = [
        ...attributes.where((a) => a.id != data.id).toList(),
        data
      ];
      final res = await update(metadata);
      return res;
    }
    return false;
  }

  @override
  Future<bool> deleteAttribute(XAttribute data) async {
    final index = attributes.indexWhere((i) => i.id == data.id);
    if (index > -1) {
      metadata.attributes = [
        ...attributes.where((a) => a.id != data.id).toList(),
        data
      ];
      final res = await update(metadata);
      return res;
    }
    return false;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      return await super
          .copyTo(destination.id, coll: destination.resource.formColl);
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (allowMove(destination)) {
      return await super
          .moveTo(destination.id, coll: destination.resource.formColl);
    }
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
