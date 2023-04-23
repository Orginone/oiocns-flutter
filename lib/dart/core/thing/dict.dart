import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

import 'idict.dart';

// 分类系统项实现
class Dict extends IDict {
  KernelApi kernel = KernelApi.getInstance();

  Dict(String belongId) {
    this.belongId = belongId;
  }

  @override
  Future<XDictArray> loadDict(PageRequest page) async {
    final res = await kernel.queryDict(IdBelongReq(
      belongId: belongId,
      page: PageRequest(
        offset: page.offset,
        limit: page.limit,
        filter: '',
      ),
    ));
    return res.data!;
  }

  @override
  Future<XDictItemArray> loadDictItems(
      String id, PageRequest page) async {
    final res = await kernel.queryDictItems(IdSpaceReq(
      id: id,
      spaceId: belongId,
      page: PageRequest(
        offset: page.offset,
        limit: page.limit,
        filter: '',
      ),
    ));
    return res.data!;
  }

  @override
  Future<XDict?> createDict(DictModel data) async {
    final res = await kernel.createDict(data);
    if (res.success) {
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> createItem(DictItemModel data) async {
    data.belongId = belongId;
    final res = await kernel.createDictItem(data);
    return res.success;
  }

  @override
  Future<bool> deleteDict(String id) async {
    final res = await kernel.deleteDict(IdReqModel(id: id, typeName: ''));
    return res.success;
  }

  @override
  Future<bool> deleteDictItem(String id) async {
    final res = await kernel.deleteDictItem(IdReqModel(id: id, typeName: ''));
    return res.success;
  }


  @override
  Future<XDict?> updateDict(DictModel data) async {
    data.belongId = belongId;
    final res = await kernel.updateDict(data);
    if (res.success) {
       return res.data!;
    }
    return null;
  }

  @override
  Future<bool> updateDictItem(DictItemModel data) async {
    final res = await kernel.updateDictItem(data);
    return res.success;
  }
}
