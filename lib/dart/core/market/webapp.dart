// import { common } from '@/ts/base';
// import Resource from './resource';
// import IProduct from './iproduct';
// import { CommonStatus } from '../enum';
// import Merchandise from './merchandise';
// import { kernel, model, schema } from '../../base';

import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/market/index.dart';
import 'package:orginone/dart/core/market/resource.dart';

abstract class WebApp implements IProduct {
  @override
  final XProduct prod;
  @override
  final List<IResource> resource;
  @override
  final List<IMerchandise> merchandises;

  WebApp({
    required this.prod,
    required this.resource,
    required this.merchandises,
  });

  @override
  Future<List<IMerchandise>> getMerchandises(bool reload) async {
    if (!reload && merchandises.isNotEmpty) {
      return merchandises;
    }

    IDBelongReq idBelongReq = IDBelongReq(
        id: prod.id, page: PageRequest(offset: 0, limit: 10, filter: ''));
    ResultType res = await KernelApi.getInstance()
        .queryMerchandiseListByProduct(idBelongReq);

    if (res.success! && res.data.result) {
      merchandises =
          res.data.result.map((a) => (XMerchandiseArray.fromJson(a))).toList();
    }
    return merchandises;
  }

  @override
  Future<bool> createExtend(
    String teamId,
    List<String> destIds,
    String destType,
  ) async {
    var rs = await kernel.createSourceExtend(SourceExtendModel(
      sourceId: prod.id,
      sourceType: '产品',
      spaceId: prod.belongId,
      destIds: destIds,
      destType: destType,
      teamId: teamId,
    ));

    return rs.success!;
  }

  @override
  Future<bool> deleteExtend(
    String teamId,
    List<String> destIds,
    String destType,
  ) async {
    return (await kernel.deleteSourceExtend(SourceExtendModel(
      sourceId: prod.id,
      sourceType: '产品',
      destIds: destIds,
      destType: destType,
      spaceId: prod.belongId,
      teamId: teamId,
    )))
        .success!;
  }

  @override
  Future<IdNameArray> queryExtend(String destType, String? teamId) async {
    var res = await kernel.queryExtendBySource(SearchExtendReq(
      sourceId: prod.id,
      sourceType: '产品',
      spaceId: prod.belongId,
      destType: destType,
      teamId: teamId!,
    ));
    return res.data!;
  }

  @override
  Future<bool> publish(APrams params) async {
    var res = await kernel.createMerchandise(MerchandiseModel(
      caption: params.caption,
      marketId: params.marketId,
      sellAuth: params.sellAuth,
      information: params.information,
      price: params.price,
      days: params.days,
      productId: prod.id,
      id: '',
    ));
    if (res.success!) {
      if (res.data!.status >= CommonStatus.approveStartStatus.value) {
        merchandises.add(Merchandise(res.data));
      }
    }
    return res.success!;
  }

  @override
  Future<bool> unPublish(String id) async {
    var res = await kernel
        .deleteMerchandise(IDWithBelongReq(id: id, belongId: prod.belongId));
    if (res.success!) {
      merchandises = merchandises.where((a) => a.merchandise.id != id).toList();
    }
    return res.success!;
  }

  @override
  Future<bool> update(
    String name,
    String code,
    String typeName,
    String remark,
    String photo,
    List<ResourceModel> resources,
  ) async {
    var res = await kernel.updateProduct(ProductModel(
        id: prod.id,
        name: name,
        code: code,
        typeName: typeName,
        remark: remark,
        photo: photo,
        thingId: prod.thingId,
        belongId: prod.belongId,
        resources: resources));
    if (res.success!) {
      XProduct xProduct = XProduct(
          id: id,
          name: name,
          code: code,
          photo: photo,
          remark: remark,
          resource: [],
          merchandises: [],
          flowRelations: [],
          thing: null,
          orderSource: null,
          belong: null);
      prod = xProduct;
      res.data?.resource?.forEach((a) =>
          {resource.add(Resource(a, destIds: [], destType: '', teamId: ''))});
    }
    return res.success!;
  }
}
