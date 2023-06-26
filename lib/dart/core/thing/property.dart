import 'package:flutter/material.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/main.dart';

abstract class IProperty extends IFileInfo<XProperty> {
  late List<XAttribute> attributes;

  // 更新表单逻辑
  Future<bool> update(PropertyModel data);

  // 删除表单逻辑
  Future<bool> delete();

  Future<List<XAttribute>> loadAttributes({bool reload = false});
}

class Property extends FileInfo<XProperty> implements IProperty {
  Property(super.metadata, super.directory) {
    metadata.typeName = '属性';
    attributes = [];
  }

  @override
  late List<XAttribute> attributes;

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      var data = PropertyModel.fromJson(metadata.toJson());
      data.directoryId = directory.id!;
      data.sourceId = metadata.belongId!;
      var res = await destination.createProperty(data);
      return res != null;
    }
    return false;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteProperty(IdReq(id: id!));
    if (res.success) {
      directory.propertys.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async{
    await loadAttributes(reload: reload);
    return true;
  }

  @override
  Future<List<XAttribute>> loadAttributes({bool reload = false}) async{
    if(attributes.isEmpty || reload){
      var res = await kernel.queryPropAttributes(IdReq(id: id!));
      if (res.success) {
        attributes = res.data?.result ?? [];
      }
    }
    return attributes;
  }

  @override
  Future<bool> move(IDirectory destination) async{
    if (destination.id != directory.id &&
        destination.metadata.belongId == directory.metadata.belongId) {
      var success = await update(PropertyModel.fromJson(metadata.toJson()));
      if (success) {
        directory.propertys.removeWhere((i) => i.id == id);
        directory = destination;
        destination.propertys.add(this);
      }
      return success;
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async{
    var data = PropertyModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(PropertyModel data) async{
    data.id = id!;
    data.directoryId = metadata.directoryId;
    var res = await kernel.updateProperty(data);
    return res.success;
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
}
