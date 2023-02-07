// import { kernel, parseAvatar, schema } from '../../../base.dart';
// import {
//   AttributeModel,
//   DictModel,
//   OperationModel,
//   PageRequest,
//   SpeciesModel,
//   TargetShare,
// } from '../../../base/model';
// import { Dict } from './dict';
// import { INullDict } from './idict';
// import { INullSpeciesItem, ISpeciesItem } from './ispecies';

import 'package:orginone/dart/base/model.dart';
import '../target/species/idict.dart' show IDict;
import '../target/species/dict.dart' show Dict;
import 'package:orginone/dart/base/api/kernelapi.dart';
import '../../base/schema.dart';
import 'ispecies.dart';

/*
 * 分类系统项实现
 */
class SpeciesItem extends ISpeciesItem {
  late bool isRoot;
  KernelApi kernel = KernelApi.getInstance();
  SpeciesItem(XSpecies target, ISpeciesItem? parent) {
    children = [];
    target = target;
    parent = parent;
    id = target.id;
    name = target.name;
    isRoot = parent == null;
    if (target.nodes!.isNotEmpty) {
      for (var item in target.nodes!) {
        children.add(SpeciesItem(item, this));
      }
    }
    belongInfo = TargetShare(name: '奥集能平台', typeName: '平台');
  }

  @override
  Future<XAttributeArray> loadAttrs(String id, PageRequest page) async {
    final res = await kernel.querySpeciesAttrs(IdSpaceReq(
        id: this.id,
        spaceId: id,
        page: PageRequest(
          offset: page.offset,
          limit: page.limit,
          filter: '',
        )));
    return res.data!;
  }

  @override
  Future<XOperationArray> loadOperations(String id, PageRequest page) async {
    final res = await kernel.querySpeciesOperation(IdSpaceReq(
        id: this.id,
        spaceId: id,
        page: PageRequest(
          offset: page.offset,
          limit: page.limit,
          filter: '',
        )));
    return res.data!;
  }

  @override
  Future<ISpeciesItem> loadInfo(TargetShare info) async {
    if (info.typeName != '未知') {
      belongInfo = info;
    }
    if (target.belongId.isNotEmpty) {
      final res = await kernel.queryNameBySnowId(IdReq(id: target.belongId));
      if (res.success && res.data != null) {
        belongInfo = TargetShare(name: res.data!.name, typeName: '未知');
        // const avator = parseAvatar(res.data.photo);
        // if (avator) {
        //   this.belongInfo = { ...avator, name: res.data.name, typeName: '未知' };
        // }
      }
    }
    return this;
  }

  @override
  Future<ISpeciesItem?> create(SpeciesModel data) async {
    data.parentId = id;
    final res = await kernel.createSpecies(data);
    if (res.success && res.data != null) {
      final newItem = SpeciesItem(res.data!, this);
      children.add(newItem);
      return newItem;
    }
    return null;
  }

  @override
  Future<IDict?> createDict(DictModel data) async {
    data.speciesId = id;
    final res = await kernel.createDict(data);
    if (res.success && res.data != null) {
      return Dict(res.data!);
    }
    return null;
  }

  @override
  Future<bool> updateDict(DictModel data) async {
    final res = await kernel.updateDict(data);
    return res.success;
  }

  @override
  Future<ISpeciesItem> update(SpeciesModel data) async {
    data.id = id;
    data.code = target.code;
    data.parentId = target.parentId;
    final res = await kernel.updateSpecies(data);
    if (res.success) {
      target.name = data.name;
      target.public = data.public;
      target.authId = data.authId;
      target.belongId = data.belongId;
      target.remark = data.remark;
    }
    return this;
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteSpecies(IdReqModel(id: id, typeName: ''));
    if (res.success && parent != null && parent!.children.isNotEmpty) {
      parent!.children =
          parent!.children.where((ISpeciesItem i) => i.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<bool> createAttr(AttributeModel data) async {
    data.speciesId = id;
    data.speciesCode = target.code;
    final res = await kernel.createAttribute(data);
    return res.success;
  }

  @override
  Future<bool> updateAttr(AttributeModel data) async {
    data.speciesId = id;
    data.speciesCode = target.code;
    final res = await kernel.updateAttribute(data);
    return res.success;
  }

  @override
  Future<bool> deleteAttr(String id) async {
    final res = await kernel.deleteAttribute(IdReqModel(id: id, typeName: ''));
    return res.success;
  }

  @override
  Future<bool> createOperation(OperationModel data) async {
    data.speciesId = id;
    final res = await kernel.createOperation(data);
    return res.success;
  }

  @override
  Future<bool> updateOperation(OperationModel data) async {
    data.speciesId = id;
    final res = await kernel.updateOperation(data);
    return res.success;
  }

  @override
  Future<bool> deleteOperation(String id) async {
    final res = await kernel.deleteOperation(IdReq(id: id));
    return res.success;
  }

  @override
  Future<bool> deleteDict(String id) async {
    final res = await kernel.deleteDict(IdReqModel(id: id, typeName: ''));
    return res.success;
  }
}
