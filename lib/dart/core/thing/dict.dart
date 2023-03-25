import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';

import 'idict.dart'; 

// 分类系统项实现
class Dict extends IDict {
  KernelApi kernel = KernelApi.getInstance();
  Dict(XDict target1) {
    target = target1;
    id = target.id??"";
    name = target.name??"";
    belongInfo = TargetShare(name: "奥集能平台", typeName: "平台");
  }

  @override
  Future<XDictItemArray> loadItems(String spaceId, PageRequest page) async {
    final res = await kernel.queryDictItems(IdSpaceReq(
      id: target.id??"",
      spaceId: spaceId,
      page: PageRequest(
        offset: page.offset,
        limit: page.limit,
        filter: '',
      ),
    ));
    return res.data!;
  }

  @override
  Future<IDict?> create(DictModel data) async {
    final res = await kernel.createDict(data);
    if (res.success) {
      return Dict(res.data!);
    }
    return null;
  }

  @override
  Future<bool> createItem(DictItemModel data) async {
    data.dictId = target.id;
    final res = await kernel.createDictItem(data);
    return res.success;
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteDict(IdReqModel(id: id, typeName: ''));
    return res.success;
  }

  @override
  Future<bool> deleteItem(String id) async {
    final res = await kernel.deleteDictItem(IdReqModel(id: id, typeName: ''));
    return res.success;
  }

  @override
  Future<IDict> loadInfo(TargetShare info) async {
    if (info.typeName != '未知') {
      belongInfo = info;
    }
    if (belongInfo != null && (target.belongId?.isNotEmpty??false)) {
      final res = await kernel.queryNameBySnowId(IdReq(id: target.belongId??""));
      if (res.success && res.data != null) {
        belongInfo = TargetShare(name: res.data!.name, typeName: '未知');
        // const avator = parseAvatar(res.data.photo);
        // if (avator) {
        //   belongInfo = TargetShare(name: res.data!.name, typeName: '未知');
        //   belongInfo = { ...avator, name: res.data.name, typeName: '未知' };
        // }
      }
    }
    return this;
  }

  @override
  Future<IDict> update(DictModel data) async {
    data.code = target.code??"";
    data.id = id;
    final res = await kernel.updateDict(data);
    if (res.success) {
      target.name = data.name;
      target.public = data.public;
      target.belongId = data.belongId;
      target.remark = data.remark;
    }
    return this;
  }

  @override
  Future<bool> updateItem(DictItemModel data) async {
    final res = await kernel.updateDictItem(data);
    return res.success;
  }
}
